// tb_cache.v


`timescale 1ns/1ps

module tb_cache;
    reg clk, rst;
    reg [31:0] address, data_in;
    reg rw;
    wire [31:0] data_out;
    wire ready;
    
    // Performance metrics
    integer hit_count;
    integer total_access;
    real hit_rate;
    
    // FSM State Parameters (must match controller)
    parameter IDLE      = 3'b000;
    parameter READ_HIT  = 3'b001;
    parameter READ_MISS = 3'b010;
    parameter WRITE_HIT = 3'b011;
    parameter WRITE_MISS= 3'b100;
    parameter EVICT     = 3'b101;
    parameter ALLOCATE  = 3'b110;
    
    cache_controller dut (
        .clk(clk),
        .rst(rst),
        .address(address),
        .data_in(data_in),
        .rw(rw),
        .data_out(data_out),
        .ready(ready)
    );
    
    always #5 clk = ~clk; // 10ns period
    
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_cache);
        
        // Initialize
        clk = 1'b0;
        rst = 1'b1;
        address = 32'b0;
        data_in = 32'b0;
        rw = 1'b0;
        hit_count = 0;
        total_access = 0;
        
        #20 rst = 1'b0;
        @(negedge clk);
        
        // Test sequence
        $display("Starting cache controller tests...");
        
        // Test 1: Write miss
        $display("Test 1: Write to 0x80000000 (expect miss)");
        test_access(1'b1, 32'h80000000, 32'h12345678, 32'hx);
        
        // Test 2: Read hit
        $display("Test 2: Read from 0x80000000 (expect hit)");
        test_access(1'b0, 32'h80000000, 32'hx, 32'h12345678);
        
        // Test 3: Write to different word in same block
        $display("Test 3: Write to 0x80000004 (expect hit)");
        test_access(1'b1, 32'h80000004, 32'hAABBCCDD, 32'hx);
        
        // Test 4: Read the new word
        $display("Test 4: Read from 0x80000004 (expect hit)");
        test_access(1'b0, 32'h80000004, 32'hx, 32'hAABBCCDD);
        
        // Test 5: LRU test - fill cache set
        $display("Test 5: LRU eviction test");
        test_access(1'b1, 32'h80008000, 32'hCAFE0001, 32'hx);
        test_access(1'b1, 32'h80010000, 32'hBEEF0002, 32'hx);
        test_access(1'b1, 32'h80018000, 32'hFACE0003, 32'hx);
        test_access(1'b1, 32'h80020000, 32'hDEAD0004, 32'hx);
        
        // Test 6: Verify eviction
        $display("Test 6: Read evicted data (expect miss)");
        test_access(1'b0, 32'h80000000, 32'hx, 32'h80000000);
        
        // Performance report
        if (total_access > 0) begin
            hit_rate = (hit_count * 100.0) / total_access;
        end else begin
            hit_rate = 0.0;
        end
        
        $display("\n=== Performance Report ===");
        $display("Total Accesses: %0d", total_access);
        $display("Cache Hits:     %0d", hit_count);
        $display("Cache Misses:   %0d", total_access - hit_count);
        $display("Hit Rate:       %0.2f%%", hit_rate);
        
        // ADD THIS LINE - $finish terminates simulation properly
        $stop;
        #10 $finish;
    end
    
    // Test access task (keep your existing task)
    task test_access;
        input op_rw;
        input [31:0] op_addr;
        input [31:0] op_wdata;
        input [31:0] exp_rdata;
        reg [2:0] final_state;
        begin
            @(negedge clk);
            address = op_addr;
            data_in = op_wdata;
            rw = op_rw;
            
            // Wait for ready
            wait(ready == 1'b1);
            final_state = dut.current_state;
            //@(negedge clk); //problem ??
            @(posedge clk);
            
            total_access = total_access + 1;
            
            if (op_rw == 1'b0) begin // Read
                $display("  Read 0x%h: Got 0x%h, Expected 0x%h (State: %b)",
                        op_addr, data_out, exp_rdata, final_state);
                if (data_out !== exp_rdata && exp_rdata !== 32'hx) begin
                    $display("  ERROR: Data mismatch!");
                end
                if (final_state == READ_HIT) begin
                    hit_count = hit_count + 1;
                    $display("  Cache HIT");
                end else begin
                    $display("  Cache MISS");
                end
            end else begin // Write
                $display("  Write 0x%h = 0x%h (State: %b)", op_addr, op_wdata, final_state);
                if (final_state == WRITE_HIT) begin
                    hit_count = hit_count + 1;
                    $display("  Cache HIT");
                end else begin
                    $display("  Cache MISS");
                end
            end
        end
    endtask
    
endmodule




/* Compilare

# Create work library
vlib work

# Compile Verilog files (no -sv flag needed)
vlog cache_controller.v tb_cache.v

# Run simulation
vsim -c -do "run -all" work.tb_cache

# For GUI with persistent session:
vsim -onfinish stop work.tb_cache

*/