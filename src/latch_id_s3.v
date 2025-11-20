module latch_id_s3 (
    input  wire        clk,
    input  wire        enable,       // 1: Deja pasar / 0: Congela (Stall)
    input  wire        flush,        // 1: Limpia (Synchronous Reset)
    
    // Entradas de datos
    input  wire [4:0]  rs1_in,
    input  wire [4:0]  rs2_in,
    input  wire [4:0]  rd_in,
    input  wire [6:0]  funct7_in,
    input  wire [2:0]  funct3_in,
    input  wire [31:0] imm_in,
    input  wire [6:0]  instr_flags_in,
    input  wire [31:0] PC_in,

    // Salidas de datos
    output reg  [4:0]  rs1_out,
    output reg  [4:0]  rs2_out,
    output reg  [4:0]  rd_out,
    output reg  [6:0]  funct7_out,
    output reg  [2:0]  funct3_out,
    output reg  [31:0] imm_out,
    output reg  [6:0]  instr_flags_out,
    output reg  [31:0] PC_out
);

    always @(posedge clk) begin
        if (flush) begin
            // Si hay flush, inyectamos una burbuja (NOP)
            PC_out          <= 32'b0; 
            rs1_out         <= 5'b0;
            rs2_out         <= 5'b0;
            rd_out          <= 5'b0;
            funct7_out      <= 7'b0;
            funct3_out      <= 3'b0;
            imm_out         <= 32'b0;
            instr_flags_out <= 7'b0; 
            
        end else if (enable) begin
            // Si enable es 1, actualizamos con los datos nuevos
            PC_out          <= PC_in;
            rs1_out         <= rs1_in;
            rs2_out         <= rs2_in;
            rd_out          <= rd_in;
            funct7_out      <= funct7_in;
            funct3_out      <= funct3_in;
            imm_out         <= imm_in;
            instr_flags_out <= instr_flags_in;
        end
        
    end

endmodule