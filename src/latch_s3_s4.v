module latch_s3_s4 (
    input  wire        clk,
    input  wire        enable,
    input  wire        flush,
    input  wire [4:0]  rs1_in,
    input  wire [4:0]  rs2_in,
    input  wire [4:0]  rd_in,
    input  wire [31:0] rs1_data_in,
    input  wire [31:0] rs2_data_in,
    input  wire [31:0] imm_in,
    input  wire [6:0] instr_flags_in,
	 input  wire  [31:0] PC_in,
    input  wire [6:0]  funct7_in,
    input  wire [2:0]  funct3_in,
    output reg  [4:0]  rs1_out,
    output reg  [4:0]  rs2_out,
    output reg  [4:0]  rd_out,
    output reg  [31:0] rs1_data_out,
    output reg  [31:0] rs2_data_out,
    output reg  [31:0] imm_out,
    output reg  [6:0] instr_flags_out,
	 output reg  [31:0] PC_out,
	 output reg  [2:0]  funct3_out,
	 output reg  [6:0]  funct7_out

);

    always @(posedge clk) begin
        if (flush) begin
		  		PC_out  <= 32'b0;
				funct3_out <= 3'b0;
				funct7_out <= 7'b0;
				rs1_out <= 5'b0;
            rs2_out <= 5'b0;
            rd_out  <= 5'b0;
            rs1_data_out <= 32'b0;
            rs2_data_out <= 32'b0;
            imm_out <= 32'b0;
            instr_flags_out <= 7'b0;
        end else if (enable) begin
		  		PC_out  <= PC_in;
				funct3_out <= funct3_in;
				funct7_out <= funct7_in;
            rs1_out <= rs1_in;
            rs2_out <= rs2_in;
            rd_out  <= rd_in;
            rs1_data_out <= rs1_data_in;
            rs2_data_out <= rs2_data_in;
            imm_out <= imm_in;
            instr_flags_out <= instr_flags_in;
        end
    end

endmodule
