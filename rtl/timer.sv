/**
 * @file timer.sv
 * @author Geeoon Chung
 * @brief An LFSR-based timer
 * @see https://www.physics.otago.ac.nz/reports/electronics/ETR2012-1.pdf
 * @param WIDTH         the width of the input
 * @param SELECT_BITS         number of select bits per mux, look at your hardware and
 *                      choose the highest value that's still efficient
 * @param[in] clk       the clock driving the sequential logic
 * @param[in] rst       an active high reset
 * @param[in] count     how long the timer should last
 * @param[out] done     whether or not the timer has reached the end
 */
module timer #(
    parameter int WIDTH,
    parameter int SELECT_BITS=4,

    localparam int LAYERS=(WIDTH + SELECT_BITS - 1) / SELECT_BITS,
    localparam int PADDED_LENGTH=LAYERS * SELECT_BITS
)(
    input logic clk,
    input logic rst,
    input logic [WIDTH-1:0] count,

    output logic done
);
    /* verilator lint_off UNOPTFLAT */
    if (WIDTH < 1) begin
        $error("WIDTH needs to be at least 1.");
    end
    if (SELECT_BITS < 1) begin
        $error("SELECT_BITS needs to be at least 1.");
    end

    logic [PADDED_LENGTH-1:0] padded;

    logic [(2**SELECT_BITS)-1:0] mux_in [0:LAYERS-1];
    logic mux_out [-1:LAYERS-1];
    assign mux_out[-1] = rst;
    assign done = ~mux_out[LAYERS-1];
    for (genvar i = 0; i < LAYERS; i++) begin
        // timers
        for (genvar j = 1; j < 2**SELECT_BITS; j++) begin
            lfsr_timer #(
                .COUNT(j*(2**(SELECT_BITS*i)))
            ) timer_m (
                .clk,
                .rst(rst | mux_out[i-1]),
                .done(mux_in[i][j])
            );
        end
        assign mux_in[i][0] = ~mux_out[i-1];
        // mux
        assign mux_out[i] = ~mux_in[i][padded[((i+1)*SELECT_BITS)-1:i*SELECT_BITS]];
    end
    /* verilator lint_on UNOPTFLAT */

    always_ff @(posedge clk) begin
        if (rst) begin
            padded <= (PADDED_LENGTH)'(count);
        end
    end  // always_ff
endmodule  // timer
