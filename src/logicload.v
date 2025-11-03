module logicload (
    input  wire [31:0] mem_data,   // dato leído de memoria
    input  wire [2:0]  funct3,     // selecciona tipo de carga
    output reg  [31:0] reg_data    // dato extendido listo para el registro destino
);

    always @(*) begin
        case (funct3)
            3'b000:  // LB - Load Byte (sign-extend)
                reg_data = {{24{mem_data[7]}},  mem_data[7:0]};

            3'b001:  // LH - Load Halfword (sign-extend)
                reg_data = {{16{mem_data[15]}}, mem_data[15:0]};

            3'b010:  // LW - Load Word
                reg_data = mem_data;

            3'b100:  // LBU - Load Byte Unsigned
                reg_data = {24'b0, mem_data[7:0]};

            3'b101:  // LHU - Load Halfword Unsigned
                reg_data = {16'b0, mem_data[15:0]};

            default:
                reg_data = 32'b0;  // caso por defecto
        endcase
    end

endmodule
