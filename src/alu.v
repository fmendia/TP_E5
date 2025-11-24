module alu (
    input  wire [31:0] A, B,
    input  wire [6:0]  iflags,   // opcode
    input  wire [2:0]  funct3,
    input  wire [6:0]  funct7,
    output reg  [31:0] Result,
    output reg  [5:0]  CCR_flags  // CCR: EQ|NE|LT|GE|LTU|GEU
);

    always @(*) begin
        Result = 32'b0;     // valor por defecto
        CCR_flags = 6'b0;   // valor por defecto del CCR

        //Definir flags del CCR
        if(A==B) begin
            CCR_flags[5] = 1;   // EQ
            CCR_flags[2] = 1;   // GE
            CCR_flags[0] = 1;   // GEU           
        end
        else begin //Acá ya puede ser mayor o menor
				CCR_flags[4] = 1; //NE
            //Unsigned:
            if(A<B) begin
                CCR_flags[1] = 1;
            end else begin
                CCR_flags[0] = 1;
            end
            //Signed:
            if($signed(A)<$signed(B)) begin
                CCR_flags[3] = 1;
            end else begin
                CCR_flags[2] = 1;
            end
        end

        case (iflags)
            // -------------------------------------------------
            // Tipo R (0110011): operaciones entre registros
            // -------------------------------------------------
            7'b0110011: begin
                case (funct3)
                    3'b000: begin // ADD / SUB
                        if (funct7 == 7'b0100000)
                            Result = A - B; // SUB
                        else
                            Result = A + B; // ADD
                    end
                    3'b001: Result = A << B[4:0];              // SLL
                    3'b010: Result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0; // SLT
                    3'b011: Result = (A < B) ? 32'b1 : 32'b0; // SLTU
                    3'b100: Result = A ^ B;                   // XOR
                    3'b101: begin // SRL / SRA
                        if (funct7 == 7'b0100000)
                            Result = $signed(A) >>> B[4:0];   // SRA
                        else
                            Result = A >> B[4:0];             // SRL
                    end
                    3'b110: Result = A | B;                   // OR
                    3'b111: Result = A & B;                   // AND
                    default: Result = 32'b0;
                endcase
            end

            // -------------------------------------------------
            // Tipo I (0010011): operaciones inmediato
            // -------------------------------------------------
            7'b0010011: begin
                case (funct3)
                    3'b000: Result = A + B;                   // ADDI
                    3'b010: Result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0; // SLTI
                    3'b011: Result = (A < B) ? 32'b1 : 32'b0; // SLTIU
                    3'b100: Result = A ^ B;                   // XORI
                    3'b110: Result = A | B;                   // ORI
                    3'b111: Result = A & B;                   // ANDI
                    3'b001: Result = A << B[4:0];             // SLLI
                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            Result = $signed(A) >>> B[4:0];   // SRAI
                        else
                            Result = A >> B[4:0];             // SRLI
                    end
                    default: Result = 32'b0;
                endcase
            end

            // -------------------------------------------------
            // Tipo U (LUI, AUIPC)
            // -------------------------------------------------
            7'b0110111: Result = A;       // LUI → carga imm << 12 en B
            7'b0010111: Result = A + B;   // AUIPC → pc + imm << 12


            // -------------------------------------------------
            // Tipo J (JAL, JALR)
            // -------------------------------------------------
            7'b1101111: Result = A + B;   // PC + 4
            7'b1100111: Result = A + B;   // PC + 4

            // -------------------------------------------------
            // Default
            // -------------------------------------------------

            default: Result = 32'b0;
        endcase
    end

endmodule