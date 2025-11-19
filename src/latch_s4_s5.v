module latch_s4_s5 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        enable,
    input  wire        flush,
    input  wire [31:0] alu_result_in,
    input  wire [4:0]  rd_in,
    input  wire [15:0] instr_flags_in,
    output reg  [31:0] alu_result_out,
    output reg  [4:0]  rd_out,
    output reg  [15:0] instr_flags_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n || flush) begin
            alu_result_out <= 32'b0;
            rd_out <= 5'b0;
            instr_flags_out <= 16'b0;
        end else if (enable) begin
            alu_result_out <= alu_result_in;
            rd_out <= rd_in;
            instr_flags_out <= instr_flags_in;
        end
    end

endmodule
