module loadstore_ctrl (  //La salida vale 1 si es load o store, 0 en caso contrario
    input  wire [6:0] opcode_lsc,
    output reg  [1:0] loadstore_lsc //00 nada, 01 load, 10 store


	 );

    always @(*) begin
        case (opcode_lsc)
            7'b0110011: loadstore_lsc = 2'b00;  // R-type (ADD, SUB, etc.)
            7'b0010011: loadstore_lsc = 2'b00;  // I-type ALU (ADDI, ANDI, etc.)
            7'b0000011: loadstore_lsc = 2'b01;  // LOAD (LW, LH, LB, etc.)
            7'b0110111: loadstore_lsc = 2'b00;  // LUI
            7'b0010111: loadstore_lsc = 2'b00;  // AUIPC
            7'b1101111: loadstore_lsc = 2'b00;  // JAL
            7'b1100111: loadstore_lsc = 2'b00;  // JALR
            7'b1100011: loadstore_lsc = 2'b00;  // Branch (BEQ, BNE, etc.)
            7'b0100011: loadstore_lsc = 2'b10;  // Store (SW, SH, SB)
            default:    loadstore_lsc = 2'b00;  // Por defecto, desactivado
        endcase
    end

endmodule
