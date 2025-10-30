module reg32 (
    input  [31:0] d,     // dato de entrada (32 bits)
    input         clk,   // clock
    input         rst,   // reset asíncrono activo en alto
    output [31:0] qo     // salida (32 bits)
);

    reg [31:0] q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 32'd0;       // inicializa el PC (o registro) en cero
        else
            q <= d;           // carga del dato en flanco positivo
    end

    assign qo = q;

endmodule

