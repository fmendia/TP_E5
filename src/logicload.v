module logicload (
    input  wire [31:0] mem_data,   // dato leído de memoria (palabra de 32 bits)
    input  wire [2:0]  funct3,     // selecciona tipo de carga
    input  wire [31:0] rs1,        // base
    input  wire [31:0] Imm,        // desplazamiento inmediato
    output reg  [31:0] reg_data    // dato extendido listo para el registro destino
);

    wire [31:0] addr;
    wire [1:0]  byte_offset;
    reg  [7:0]  selected_byte;

    assign addr = rs1 + Imm;
    assign byte_offset = addr[1:0]; // selecciona qué byte usar

    always @(*) begin
        // Selección de byte según byte_offset
        case (byte_offset)
            2'b00: selected_byte = mem_data[7:0];
            2'b01: selected_byte = mem_data[15:8];
            2'b10: selected_byte = mem_data[23:16];
            2'b11: selected_byte = mem_data[31:24];
            default: selected_byte = 8'h00;
        endcase

        // Extensión según funct3
        case (funct3)
            3'b000:  // LB - Load Byte (sign-extend)
                reg_data = {{24{selected_byte[7]}}, selected_byte};

            3'b100:  // LBU - Load Byte Unsigned
                reg_data = {24'b0, selected_byte};

            3'b001:  // LH - Load Halfword (sign-extend)
                case (addr[1])
                    1'b0: reg_data = {{16{mem_data[15]}}, mem_data[15:0]};
                    1'b1: reg_data = {{16{mem_data[31]}}, mem_data[31:16]};
                endcase

            3'b101:  // LHU - Load Halfword Unsigned
                case (addr[1])
                    1'b0: reg_data = {16'b0, mem_data[15:0]};
                    1'b1: reg_data = {16'b0, mem_data[31:16]};
                endcase

            3'b010:  // LW - Load Word
                reg_data = mem_data;

            default:
                reg_data = 32'b0;
        endcase
    end

endmodule
