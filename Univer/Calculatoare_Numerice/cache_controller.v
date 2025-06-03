// cache_controller.v

`timescale 1ns/1ps

module cache_controller(
    input clk,
    input rst,
    input [31:0] address,
    input [31:0] data_in,
    input rw,        // 0=read, 1=write
    output reg [31:0] data_out,
    output reg ready
);

// FSM State Parameters
parameter IDLE      = 3'b000;
parameter READ_HIT  = 3'b001;
parameter READ_MISS = 3'b010;
parameter WRITE_HIT = 3'b011;
parameter WRITE_MISS= 3'b100;
parameter EVICT     = 3'b101;
parameter ALLOCATE  = 3'b110;

// Cache Parameters
parameter NUM_WAYS        = 4;
parameter BLOCK_SIZE_BYTES= 64;
parameter WORD_SIZE_BYTES = 4;
parameter NUM_SETS        = 128;
parameter MEM_DELAY       = 20;
parameter OFFSET_BITS     = 6;
parameter SET_INDEX_BITS  = 7;
parameter TAG_BITS        = 19;
parameter WORDS_PER_BLOCK = 16;

// Cache Storage
reg [TAG_BITS-1:0]    tags [0:NUM_SETS*NUM_WAYS-1];
reg [511:0]           data_lines [0:NUM_SETS*NUM_WAYS-1];
reg                   valid [0:NUM_SETS*NUM_WAYS-1];
reg                   dirty [0:NUM_SETS*NUM_WAYS-1];
reg [15:0]            lru_timestamps [0:NUM_SETS*NUM_WAYS-1];

// Global timestamp counter
reg [15:0] age_timestamp_global;

// FSM state register
reg [2:0] current_state, next_state;

// Internal registers
reg [31:0] current_address_reg;
reg [31:0] current_data_in_reg;
reg        current_rw_reg;
reg [TAG_BITS-1:0] current_tag;
reg [SET_INDEX_BITS-1:0] current_set_idx;
reg [OFFSET_BITS-1:0] current_offset;
reg [3:0] current_word_offset;
reg [1:0] hit_way_idx;
reg [1:0] victim_way_idx;
reg [4:0] mem_access_delay_counter;

// Helper variables
integer i;
reg hit_found;

// Address parsing for current address input (for hit detection)
wire [TAG_BITS-1:0] input_tag = address[31:13];
wire [SET_INDEX_BITS-1:0] input_set_idx = address[12:6];
wire [OFFSET_BITS-1:0] input_offset = address[5:0];
wire [3:0] input_word_offset = address[5:2];

// Hit detection using current address input (not latched)
always @(*) begin
    hit_found = 1'b0;
    hit_way_idx = 2'b00;
    
    // Check way 0
    if (valid[input_set_idx*NUM_WAYS + 0] && 
        (tags[input_set_idx*NUM_WAYS + 0] == input_tag)) begin
        hit_found = 1'b1;
        hit_way_idx = 2'b00;
    end
    // Check way 1  
    else if (valid[input_set_idx*NUM_WAYS + 1] && 
             (tags[input_set_idx*NUM_WAYS + 1] == input_tag)) begin
        hit_found = 1'b1;
        hit_way_idx = 2'b01;
    end
    // Check way 2
    else if (valid[input_set_idx*NUM_WAYS + 2] && 
             (tags[input_set_idx*NUM_WAYS + 2] == input_tag)) begin
        hit_found = 1'b1;
        hit_way_idx = 2'b10;
    end
    // Check way 3
    else if (valid[input_set_idx*NUM_WAYS + 3] && 
             (tags[input_set_idx*NUM_WAYS + 3] == input_tag)) begin
        hit_found = 1'b1;
        hit_way_idx = 2'b11;
    end
end

// Address parsing for latched address (for cache operations)
always @(*) begin
    current_tag = current_address_reg[31:13];
    current_set_idx = current_address_reg[12:6];
    current_offset = current_address_reg[5:0];
    current_word_offset = current_address_reg[5:2];
end

// Main FSM
always @(posedge clk or posedge rst) begin
    if (rst) begin
        current_state <= IDLE;
        ready <= 1'b0;
        age_timestamp_global <= 16'b0;
        data_out <= 32'h0;
        
        for (i = 0; i < NUM_SETS*NUM_WAYS; i = i + 1) begin
            valid[i] <= 1'b0;
            dirty[i] <= 1'b0;
            tags[i] <= {TAG_BITS{1'b0}};
            data_lines[i] <= 512'b0;
            lru_timestamps[i] <= 16'b0;
        end
        mem_access_delay_counter <= 5'b0;
    end else begin
        current_state <= next_state;
        ready <= 1'b0;
        
        case (current_state)
            IDLE: begin
                current_address_reg <= address;
                current_data_in_reg <= data_in;
                current_rw_reg <= rw;
                
                if (hit_found) begin
                    next_state <= (rw ? WRITE_HIT : READ_HIT);
                end else begin
                    next_state <= (rw ? WRITE_MISS : READ_MISS);
                end
            end
            
            READ_HIT: begin
                data_out <= data_lines[input_set_idx*NUM_WAYS + hit_way_idx][input_word_offset*32 +: 32];
                lru_timestamps[input_set_idx*NUM_WAYS + hit_way_idx] <= age_timestamp_global;
                age_timestamp_global <= age_timestamp_global + 1;
                ready <= 1'b1;
                next_state <= IDLE;
            end
            
            WRITE_HIT: begin
                data_lines[input_set_idx*NUM_WAYS + hit_way_idx][input_word_offset*32 +: 32] <= current_data_in_reg;
                dirty[input_set_idx*NUM_WAYS + hit_way_idx] <= 1'b1;
                lru_timestamps[input_set_idx*NUM_WAYS + hit_way_idx] <= age_timestamp_global;
                age_timestamp_global <= age_timestamp_global + 1;
                ready <= 1'b1;
                next_state <= IDLE;
            end
            
            READ_MISS, WRITE_MISS: begin
                //modified from here - fix victim selection logic to avoid multiple assignments
                // Find invalid way first using explicit if-else chain
                if (!valid[current_set_idx*NUM_WAYS + 0]) begin
                    victim_way_idx <= 2'b00;
                end else if (!valid[current_set_idx*NUM_WAYS + 1]) begin
                    victim_way_idx <= 2'b01;
                end else if (!valid[current_set_idx*NUM_WAYS + 2]) begin
                    victim_way_idx <= 2'b10;
                end else if (!valid[current_set_idx*NUM_WAYS + 3]) begin
                    victim_way_idx <= 2'b11;
                end else begin
                    // All valid, find LRU using explicit comparisons
                    if ((lru_timestamps[current_set_idx*NUM_WAYS + 0] <= lru_timestamps[current_set_idx*NUM_WAYS + 1]) &&
                        (lru_timestamps[current_set_idx*NUM_WAYS + 0] <= lru_timestamps[current_set_idx*NUM_WAYS + 2]) &&
                        (lru_timestamps[current_set_idx*NUM_WAYS + 0] <= lru_timestamps[current_set_idx*NUM_WAYS + 3])) begin
                        victim_way_idx <= 2'b00;
                    end else if ((lru_timestamps[current_set_idx*NUM_WAYS + 1] <= lru_timestamps[current_set_idx*NUM_WAYS + 2]) &&
                                 (lru_timestamps[current_set_idx*NUM_WAYS + 1] <= lru_timestamps[current_set_idx*NUM_WAYS + 3])) begin
                        victim_way_idx <= 2'b01;
                    end else if (lru_timestamps[current_set_idx*NUM_WAYS + 2] <= lru_timestamps[current_set_idx*NUM_WAYS + 3]) begin
                        victim_way_idx <= 2'b10;
                    end else begin
                        victim_way_idx <= 2'b11;
                    end
                end
                //stopped modifying here
                
                if (valid[current_set_idx*NUM_WAYS + victim_way_idx] && 
                    dirty[current_set_idx*NUM_WAYS + victim_way_idx]) begin
                    next_state <= EVICT;
                end else begin
                    next_state <= ALLOCATE;
                end
                mem_access_delay_counter <= 5'b0;
            end
            
            EVICT: begin
                if (mem_access_delay_counter < MEM_DELAY) begin
                    mem_access_delay_counter <= mem_access_delay_counter + 1;
                    next_state <= EVICT;
                end else begin
                    dirty[current_set_idx*NUM_WAYS + victim_way_idx] <= 1'b0;
                    next_state <= ALLOCATE;
                    mem_access_delay_counter <= 5'b0;
                end
            end
            
            ALLOCATE: begin
                if (mem_access_delay_counter < MEM_DELAY) begin
                    mem_access_delay_counter <= mem_access_delay_counter + 1;
                    next_state <= ALLOCATE;
                end else begin
                    tags[current_set_idx*NUM_WAYS + victim_way_idx] <= current_tag;
                    valid[current_set_idx*NUM_WAYS + victim_way_idx] <= 1'b1;
                    dirty[current_set_idx*NUM_WAYS + victim_way_idx] <= 1'b0;
                    
                    data_lines[current_set_idx*NUM_WAYS + victim_way_idx] <= {
                        current_address_reg + 60, current_address_reg + 56,
                        current_address_reg + 52, current_address_reg + 48,
                        current_address_reg + 44, current_address_reg + 40,
                        current_address_reg + 36, current_address_reg + 32,
                        current_address_reg + 28, current_address_reg + 24,
                        current_address_reg + 20, current_address_reg + 16,
                        current_address_reg + 12, current_address_reg + 8,
                        current_address_reg + 4,  current_address_reg
                    };
                    
                    lru_timestamps[current_set_idx*NUM_WAYS + victim_way_idx] <= age_timestamp_global;
                    age_timestamp_global <= age_timestamp_global + 1;
                    
                    if (current_rw_reg) begin
                        data_lines[current_set_idx*NUM_WAYS + victim_way_idx][current_word_offset*32 +: 32] <= current_data_in_reg;
                        dirty[current_set_idx*NUM_WAYS + victim_way_idx] <= 1'b1;
                    end else begin
                        data_out <= data_lines[current_set_idx*NUM_WAYS + victim_way_idx][current_word_offset*32 +: 32];
                    end
                    
                    ready <= 1'b1;
                    next_state <= IDLE;
                end
            end
            
            default: next_state <= IDLE;
        endcase
    end
end

endmodule
