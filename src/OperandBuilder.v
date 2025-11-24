module OperandBuilder (
    input  wire [31:0] rs1d, rs2d, pc, imm,
    input  wire [6:0]  iflags,      // opcode son 7 bits
    output reg  [31:0] A, B
);

    always @(*) begin
        case (iflags)
            // Tipo I (OP-IMM): A = rs1, B = imm
            7'b0010011: begin
                A = rs1d;
                B = imm;
            end

            // Tipo R (OP): A = rs1, B = rs2
            7'b0110011: begin
                A = rs1d;
                B = rs2d;
            end

            // Tipo U (LUI): A = imm << 12, B = 0
            7'b0110111:begin //LUI
				    A = imm;
                B = 32'b0;
				end
				// Tipo U (AUIPC): A = imm << 12, B = pc
            7'b0010111: begin 
                A = imm;
                B = pc;
            end
				// Tipo J (JAL): A = PC, B = 4

				7'b1101111: begin 
                A = pc;
                B = 4;
            end
				7'b1100111: begin //JALR
                A = pc;
                B = 4;
            end
            7'b1100011: begin// BRANCH (B-TYPE)
                A = rs1d;
                B = rs2d;      // comparación rs1 vs rs2
            end


            default: begin
                A = 32'b0;
                B = 32'b0;
            end
        endcase
    end

endmodule
