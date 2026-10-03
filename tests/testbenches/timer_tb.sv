/**
 * @file timer_tb.sv
 * @author Geeoon Chung
 * @brief testbench for the timer module
 */

module timer_tb #(
    parameter int WIDTH=8,
    parameter int SELECT_BITS=4,
    parameter int CLOCK_PERIOD=100
) ();
    // inputs
    logic clk;
    logic rst;
    logic [WIDTH-1:0] count;

    // outputs
    logic done;

    timer #(
        .WIDTH(WIDTH),
        .SELECT_BITS(SELECT_BITS)
    ) dut (
        .clk,
        .rst,
        .count,

        .done
    );

    initial begin
        clk = 0;
        forever begin
            #(CLOCK_PERIOD/2) clk = ~clk;
        end  // forever
    end  // initial

    initial begin
        // dump waveforms
        $dumpfile("waveforms/timer_tb.vcd");
        $dumpvars;

        $display(" -- Starting timer test -- ");
        for (int i = 0; i < 2**WIDTH; i++) begin
            // start timer
            rst = 1;
            count = (WIDTH)'(i);
            @(posedge clk); #5;
            rst = 0; #5;
            // wait
            repeat(i) begin
                assert(~done);
                @(posedge clk); #5;
            end
            
            // check timer stays
            repeat(10) begin
                assert(done);
                @(posedge clk); #5;
            end
        end

        $display(" -- FINISHED TESTS -- ");
        $finish;
    end
endmodule  // lfsr_timer_tb
