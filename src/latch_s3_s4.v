module latch_s3_s4 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        enable,
    input  wire        flush,
    input  wire [4:0]  rs1_in,
    input  wire [4:0]  rs2_in,
    input  wire [4:0]  rd_in,
    input  wire [31:0] rs1_data_in,
    input  wire [31:0] rs2_data_in,
    input  wire [31:0] imm_in,
    input  wire [15:0] instr_flags_in,
    output reg  [4:0]  rs1_out,
    output reg  [4:0]  rs2_out,
    output reg  [4:0]  rd_out,
    output reg  [31:0] rs1_data_out,
    output reg  [31:0] rs2_data_out,
    output reg  [31:0] imm_out,
    output reg  [15:0] instr_flags_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || flush) begin
            rs1_out <= 5'b0;
            rs2_out <= 5'b0;
            rd_out  <= 5'b0;
            rs1_data_out <= 32'b0;
            rs2_data_out <= 32'b0;
            imm_out <= 32'b0;
            instr_flags_out <= 16'b0;
        end else if (enable) begin
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
