// cache_controller.v

`timescale 1ns/1ps

module cache_controller(
    input           clk,
    input           rst,
    input  [31:0]   address,
    input  [31:0]   data_in,
    input           rw,        // 0=read, 1=write
    output reg [31:0] data_out,
    output reg      ready
);

  // FSM states
  parameter IDLE       = 3'b000;
  parameter READ_HIT   = 3'b001;
  parameter READ_MISS  = 3'b010;
  parameter WRITE_HIT  = 3'b011;
  parameter WRITE_MISS = 3'b100;
  parameter EVICT      = 3'b101;
  parameter ALLOCATE   = 3'b110;

  // Cache parameters
  parameter NUM_WAYS         = 4;
  parameter BLOCK_SIZE_BYTES = 64;
  parameter NUM_SETS         = 128;
  parameter MEM_DELAY        = 20;
  parameter OFFSET_BITS      = 6;
  parameter SET_BITS         = 7;
  parameter TAG_BITS         = 19;

  // Storage arrays (flat index = set*NUM_WAYS + way)
  reg [TAG_BITS-1:0]           tags          [0:NUM_SETS*NUM_WAYS-1];
  reg [BLOCK_SIZE_BYTES*8-1:0] data_lines    [0:NUM_SETS*NUM_WAYS-1];
  reg                          valid         [0:NUM_SETS*NUM_WAYS-1];
  reg                          dirty         [0:NUM_SETS*NUM_WAYS-1];
  reg [31:0]                   lru_timestamp [0:NUM_SETS*NUM_WAYS-1];

  // LRU global counter, temp block
  reg [31:0] global_time;
  reg [BLOCK_SIZE_BYTES*8-1:0] temp_block;

  // FSM and request latches
  reg [2:0]   current_state, next_state;
  reg [31:0]  req_data;
  reg         req_rw;
  reg [31:0]  req_addr;

  // Latched address fields
  reg [TAG_BITS-1:0]     req_tag_r;
  reg [SET_BITS-1:0]     req_set_r;
  reg [3:0]              req_word_r;

  // Hit detection
  reg [1:0]  hit_way;
  reg        hit_found;
  integer    i;
  reg [1:0]  victim_way;
  reg [4:0]  delay_ctr;

  // ------------------------------------------------------------
  // Combinational Hit Detect (uses latched req_tag_r & req_set_r)
  // ------------------------------------------------------------
  always @(*) begin
    hit_found = 1'b0;
    hit_way   = 2'b00;
    for (i = 0; i < NUM_WAYS; i = i + 1) begin
      if ( valid[{req_set_r,i}] && tags[{req_set_r,i}] == req_tag_r ) begin
        hit_found = 1'b1;
        hit_way   = i[1:0];
      end
    end
  end

  // ------------------------------------------------------------
  // Combinational Read‐Data Mux (stable after latching)
  // ------------------------------------------------------------
  wire [31:0] read_data =
    data_lines[{req_set_r,hit_way}][req_word_r*32 +: 32];

  // ------------------------------------------------------------
  // Main FSM
  // ------------------------------------------------------------
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      current_state <= IDLE;
      ready         <= 1'b0;
      data_out      <= 32'b0;
      global_time   <= 32'b0;
      delay_ctr     <= 5'b0;
      // Initialize arrays
      for (i = 0; i < NUM_SETS*NUM_WAYS; i = i + 1) begin
        valid[i]         <= 1'b0;
        dirty[i]         <= 1'b0;
        tags[i]          <= {TAG_BITS{1'b0}};
        data_lines[i]    <= {BLOCK_SIZE_BYTES*8{1'b0}};
        lru_timestamp[i] <= 32'b0;
      end
    end else begin
      current_state <= next_state;
      ready         <= 1'b0;

      case (current_state)
        // --------------------------------------------------------
        IDLE: begin
          // Latch request info
          req_addr  <= address;
          req_data  <= data_in;
          req_rw    <= rw;
          // Derive fields from address
          req_tag_r  <= address[31:32-TAG_BITS];
          req_set_r  <= address[OFFSET_BITS +: SET_BITS];
          req_word_r <= address[OFFSET_BITS-1:2];

          // Next state based on hit
          if (hit_found)
            next_state <= (rw ? WRITE_HIT : READ_HIT);
          else
            next_state <= (rw ? WRITE_MISS : READ_MISS);
        end

        // --------------------------------------------------------
        READ_HIT: begin
          data_out <= read_data;      // valid immediately
          ready    <= 1'b1;
          // update LRU
          lru_timestamp[{req_set_r,hit_way}] <= global_time;
          global_time <= global_time + 1;
          next_state  <= IDLE;
        end

        // --------------------------------------------------------
        WRITE_HIT: begin
          data_lines[{req_set_r,hit_way}][req_word_r*32 +: 32] <= req_data;
          dirty[{req_set_r,hit_way}] <= 1'b1;
          ready                      <= 1'b1;
          lru_timestamp[{req_set_r,hit_way}] <= global_time;
          global_time <= global_time + 1;
          next_state  <= IDLE;
        end

        // --------------------------------------------------------
        READ_MISS, WRITE_MISS: begin
          // Find invalid or LRU way
          victim_way = 2'b00;
          for (i = 0; i < NUM_WAYS; i = i + 1)
            if (!valid[{req_set_r,i}]) victim_way = i[1:0];
          if (&valid[req_set_r*NUM_WAYS +: NUM_WAYS]) begin
            integer j; reg [31:0] min_t;
            min_t      = lru_timestamp[{req_set_r,0}];
            victim_way = 2'b00;
            for (j = 1; j < NUM_WAYS; j = j + 1)
              if (lru_timestamp[{req_set_r,j}] < min_t) begin
                min_t      = lru_timestamp[{req_set_r,j}];
                victim_way = j[1:0];
              end
          end
          if (valid[{req_set_r,victim_way}] && dirty[{req_set_r,victim_way}])
            next_state <= EVICT;
          else
            next_state <= ALLOCATE;
          delay_ctr <= 5'b0;
        end

        // --------------------------------------------------------
        EVICT: begin
          if (delay_ctr < MEM_DELAY) begin
            delay_ctr <= delay_ctr + 1;
            next_state <= EVICT;
          end else begin
            dirty[{req_set_r,victim_way}] <= 1'b0;
            next_state <= ALLOCATE;
            delay_ctr <= 5'b0;
          end
        end

        // --------------------------------------------------------
        ALLOCATE: begin
          if (delay_ctr < MEM_DELAY) begin
            delay_ctr <= delay_ctr + 1;
            next_state <= ALLOCATE;
          end else begin
            tags[{req_set_r,victim_way}]  <= req_tag_r;
            valid[{req_set_r,victim_way}] <= 1'b1;
            dirty[{req_set_r,victim_way}] <= req_rw;

            if (req_rw) begin
              // Write‐allocate: build block with only that word
              temp_block = {BLOCK_SIZE_BYTES*8{1'b0}};
              temp_block[req_word_r*32 +: 32] = req_data;
              data_lines[{req_set_r,victim_way}] <= temp_block;
            end else begin
              // Read‐miss: fill with pattern
              data_lines[{req_set_r,victim_way}] <= {
                req_addr+60, req_addr+56, req_addr+52, req_addr+48,
                req_addr+44, req_addr+40, req_addr+36, req_addr+32,
                req_addr+28, req_addr+24, req_addr+20, req_addr+16,
                req_addr+12, req_addr+ 8, req_addr+ 4, req_addr
              };
            end

            // Output newly allocated data
            data_out <= read_data;
            ready    <= 1'b1;
            lru_timestamp[{req_set_r,victim_way}] <= global_time;
            global_time <= global_time + 1;
            next_state  <= IDLE;
          end
        end

        default: next_state <= IDLE;
      endcase
    end
  end
endmodule
