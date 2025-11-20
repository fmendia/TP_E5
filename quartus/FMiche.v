module FMiche (
    input  wire [6:0] opcode,
    output reg        reg_flag
);

    always @(*) begin
        case (opcode)
            7'b0110011: reg_flag = 1'b0;  // R-type (ADD, SUB, etc.)
            7'b0010011: reg_flag = 1'b0;  // I-type ALU (ADDI, ANDI, etc.)
            7'b0110111: reg_flag = 1'b0;  // LUI
            7'b0010111: reg_flag = 1'b0;  // AUIPC
            7'b1101111: reg_flag = 1'b0;  // JAL
            7'b1100111: reg_flag = 1'b0;  // JALR
				7'b1100011: reg_flag = 1'b0;  // Branch (BEQ, BNE, etc.)


            // No escritura en el banco de registros
				7'b0000011: reg_flag = 1'b1;  // LOAD (LW, LH, LB, etc.)
            7'b0100011: reg_flag = 1'b1;  // Store (SW, SH, SB)
            default:    reg_flag = 1'b0;  // Por defecto, desactivado
        endcase
    end

endmodule
