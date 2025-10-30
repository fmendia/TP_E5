module adder4 (
    input clk,
    input[31:0] in,
    output reg  [31:0] out
);

    always @(negedge clk) 
	 begin
        out <= in + 4;
    end

endmodule
