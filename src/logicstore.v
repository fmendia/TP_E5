module logicstore (
    input  wire [2:0]  funct3_ls,     // selecciona tipo de carga
    output reg  [3:0] byte_enable_ls    // dato extendido listo para el registro destino
);

    always @(*) begin
        case (funct3_ls)
            3'b000:  // SB - Store byte
                byte_enable_ls = 4'b001;

            3'b001:  // SH - Store HalfWord
                byte_enable_ls = 4'b0011;

            3'b010:  // SW - Store Word
                byte_enable_ls = 4'b1111;

            default:
                byte_enable_ls = 4'b000;  // caso por defecto
        endcase
    end

endmodule
