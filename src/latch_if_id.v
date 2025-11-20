module latch_if_id (
    input  wire        clk,
    input  wire        enable,
    input  wire        flush,
    input  wire [31:0] instr_in,
    output reg  [31:0] instr_out
);

    always @(posedge clk) begin
        if (flush)
            instr_out <= 32'b0;
        else if (enable)
            instr_out <= instr_in;
    end

endmodule
