//====================================================================
// Módulo: reg32_enable (Versión modificada para usar Enable)
//====================================================================
module reg32_enable (
    input  [31:0] d,     // Dato de entrada (32 bits)
    input         clk,   // Clock
    input         rst,   // Reset asíncrono activo en alto
    input         en,    // <<-- ¡NUEVA SEÑAL de HABILITACIÓN!
    output [31:0] qo     // Salida (32 bits)
);

    reg [31:0] q;

    always @(posedge clk) begin
        if (rst)
            q <= 32'd0;
        // Si no hay reset, solo actualiza si 'en' está activo (1)
        else if (en)
            q <= d;
        // Si 'en' es 0, el registro retiene el valor anterior (q <= q, implícito)
    end

    assign qo = q;

endmodule