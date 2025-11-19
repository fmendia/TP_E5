module latch_if_id (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        enable,
    input  wire        flush,
    input  wire [31:0] instr_in,
    output reg  [31:0] instr_out
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            instr_out <= 32'b0;
        else if (flush)
            instr_out <= 32'b0;
        else if (enable)
            instr_out <= instr_in;
    end

endmodule
