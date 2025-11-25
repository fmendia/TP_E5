module latch_s4_s5 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        enable,
    input  wire        flush,
    input  wire [31:0] alu_result_in,
    input  wire [4:0]  rd_in,
    input  wire [6:0] instr_flags_in,
    input  wire [2:0]  funct3_in,
    output reg  [31:0] alu_result_out,
    output reg  [4:0]  rd_out,
    output reg  [6:0] instr_flags_out,
	 output reg  [2:0]  funct3_out

	 
);

    always @(posedge clk) begin
        if (flush) begin
            alu_result_out <= 32'b0;
            rd_out <= 5'b0;
            instr_flags_out <= 16'b0;
				funct3_out <= 2'b0;
        end else if (enable) begin
            funct3_out <= funct3_in;
				alu_result_out <= alu_result_in;
            rd_out <= rd_in;
            instr_flags_out <= instr_flags_in;
        end
    end

endmodule
