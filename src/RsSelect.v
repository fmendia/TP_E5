module RsSelect (
    input  wire [1:0]  loadstore_rss,  // 1 = load/store, 0 = ALU normal
	 input  wire [31:0] rs1_rss,
	 input  wire [31:0] rs2_rss,
    output wire [31:0] rs1_data_rss,
	 output wire [31:0] rs2_data_rss

);

    assign rs1_data_rss = (loadstore_rss != 2'b00) ? 0 : rs1_rss;
    assign rs2_data_rss = (loadstore_rss != 2'b00) ? 0 : rs2_rss;


endmodule
