module mux3_2_32 (
    input  wire [31:0] a,   // entrada 0
    input  wire [31:0] b,   // entrada 1
    input  wire [31:0] c,   // entrada 2
    input  wire [1:0]  sel, // señal de selección
    output reg  [31:0] y    // salida
);

always @(*) begin
    case (sel)
        2'b00: y = a;
        2'b01: y = b;
        2'b10: y = c;
        default: y = a;
    endcase
end

endmodule
