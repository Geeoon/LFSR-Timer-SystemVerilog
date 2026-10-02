/**
 * @file timer_tb.sv
 * @author Geeoon Chung
 * @brief testbench for the timer module
 */

module timer_tb #(
    parameter int WIDTH=2,
    parameter int SELECT_BITS=1,
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
        $dumpfile("waveforms/lfsr_timer_tb.vcd");
        $dumpvars;

        $display(" -- Starting timer test -- ");
        for (int i = 0; i < 4; i++) begin
            // start timer
            rst = 1;
            count = (WIDTH)'(i);
            @(posedge clk); #5;
            rst = 0; #5;
            repeat(i) begin
                $display("%d: %b, %b, %b, %p", i, done, dut.rst, dut.mux_out[-1], dut.mux_out);
                @(posedge clk); #5;
            end
            $display("%d: %b, %b, %b, %p", i, done, dut.rst, dut.mux_out[-1], dut.mux_out);
        end

        // rst = 1;
        // count = 3;
        // @(posedge clk); #5;
        // rst = 0;
        // repeat(100) begin
        //     $display("%b, %p", done, dut.mux_out);
        //     @(posedge clk); #5;
        // end

        $finish;
        // there should be COUNT cycles before the signal is high
        // repeat(count) begin
        //     assert(~done);
        //     @(posedge clk); #5;
        // end  // repeat

        // repeat(10) begin
        //     assert(done);
        //     @(posedge clk); #5;
        // end  // repeat

        // $display(" -- FINISHED TESTS -- ");
        $finish;
    end
endmodule  // lfsr_timer_tb
