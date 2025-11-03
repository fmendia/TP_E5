module regwrite_ctrl (
    input  wire [6:0] opcode,
    output reg        reg_write_en
);

    always @(*) begin
        case (opcode)
            7'b0110011: reg_write_en = 1'b1;  // R-type (ADD, SUB, etc.)
            7'b0010011: reg_write_en = 1'b1;  // I-type ALU (ADDI, ANDI, etc.)
            7'b0000011: reg_write_en = 1'b1;  // LOAD (LW, LH, LB, etc.)
            7'b0110111: reg_write_en = 1'b1;  // LUI
            7'b0010111: reg_write_en = 1'b1;  // AUIPC
            7'b1101111: reg_write_en = 1'b1;  // JAL
            7'b1100111: reg_write_en = 1'b1;  // JALR

            // No escritura en el banco de registros
            7'b1100011: reg_write_en = 1'b0;  // Branch (BEQ, BNE, etc.)
            7'b0100011: reg_write_en = 1'b0;  // Store (SW, SH, SB)
            default:    reg_write_en = 1'b0;  // Por defecto, desactivado
        endcase
    end

endmodule
