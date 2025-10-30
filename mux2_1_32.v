module mux2_1_32 (
    input  [31:0] a,     // entrada 0
    input  [31:0] b,     // entrada 1
    input         sel,   // señal de selección
    output [31:0] y      // salida
);

    assign y = (sel) ? b : a;

endmodule
