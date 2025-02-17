`timescale 1ns/1ps

module AdvancedCounter_tb;

    // Testbench Signals
    logic clk;
    logic rst;
    logic en_inc;
    logic en_dec;
    logic load;
    logic hold;
    logic [3:0] load_value;
    logic [3:0] count;

    // Clock Generation 
    always #10 clk = ~clk;

    // DUT Instantiation
    AdvancedCounter DUT (
        .clk(clk),
        .rst(rst),
        .en_inc(en_inc),
        .en_dec(en_dec),
        .load(load),
        .hold(hold),
        .load_value(load_value),
        .count(count)
    );

    // Functional Coverage
    covergroup counter_cg @(posedge clk);
        coverpoint rst { bins active = {1}; } // Reset coverage
        coverpoint load { bins active = {1}; } // Load coverage
        coverpoint hold { bins active = {1}; } // Hold coverage
        coverpoint en_inc { bins active = {1}; } // Increment coverage
        coverpoint en_dec { bins active = {1}; } // Decrement coverage
        coverpoint count {
            bins min_value = {4'b0000};
            bins max_value = {4'b1111};
        } // Min & Max value coverage
    endgroup

    counter_cg cg = new(); // Instantiate coverage

    // Stimulus Task
    task apply_stimulus(
        input logic rst_in,
        input logic load_in,
        input logic hold_in,
        input logic en_inc_in,
        input logic en_dec_in,
        input logic [3:0] load_val
    );
        rst = rst_in;
        load = load_in;
        hold = hold_in;
        en_inc = en_inc_in;
        en_dec = en_dec_in;
        load_value = load_val;
        #20; // Wait for a clock cycle
    endtask

    // Test Sequence
    initial begin
        // Initialize
        clk = 0;
        rst = 0;
        en_inc = 0;
        en_dec = 0;
        load = 0;
        hold = 0;
        load_value = 4'b0000;

        // Monitor Output
        $monitor("Time=%0t | rst=%b | load=%b | hold=%b | en_inc=%b | en_dec=%b | count=%b",
                 $time, rst, load, hold, en_inc, en_dec, count);

        // Reset Test
        apply_stimulus(1, 0, 0, 0, 0, 4'b0000);
        #20;
        apply_stimulus(0, 0, 0, 0, 0, 4'b0000);

        // Load Test
        apply_stimulus(0, 1, 0, 0, 0, 4'b1010);
        #20;
        apply_stimulus(0, 0, 0, 0, 0, 4'b0000);

        // Hold Test
        apply_stimulus(0, 0, 1, 1, 0, 4'b0000);
        #20;

        // Increment Test
        apply_stimulus(0, 0, 0, 1, 0, 4'b0000);
        #40;

        // Decrement Test
        apply_stimulus(0, 0, 0, 0, 1, 4'b0000);
        #40;

        // Simultaneous Increment & Decrement (Should hold value)
        apply_stimulus(0, 0, 0, 1, 1, 4'b0000);
        #40;

        // Boundary Test (Max Value)
        apply_stimulus(0, 1, 0, 0, 0, 4'b1111);
        #20;
        apply_stimulus(0, 0, 0, 1, 0, 4'b0000);
        #40;

        // Boundary Test (Min Value)
        apply_stimulus(0, 1, 0, 0, 0, 4'b0000);
        #20;
        apply_stimulus(0, 0, 0, 0, 1, 4'b0000);
        #40;

        // End Test
        rst = 1'b1;
        #10
        rst = 1'b0;
        #10
        rst = 1'b1;
        $display("Test Completed.");
        $stop;
    end

    initial begin
        $dumpfile("AdvancedCounter.vcd");
        $dumpvars(AdvancedCounter_tb);

    end
endmodule
