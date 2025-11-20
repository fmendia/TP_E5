module clk_5phase_cyclonev (
    input  wire clk_in,   // clock original
    input  wire reset,    // reset del PLL (activo en alto)
    output wire clk0,     // 0°
    output wire clk1,     // 72°
    output wire clk2,     // 144°
    output wire clk3,     // 216°
    output wire clk4,     // 288°
    output wire locked    // PLL locked
);

    PPL2 pll_inst (
        .inclk0(clk_in),
        .areset(reset),
        .c0(clk0),
        .c1(clk1),
        .c2(clk2),
        .c3(clk3),
        .c4(clk4),
        .locked(locked)
    );

endmodule
