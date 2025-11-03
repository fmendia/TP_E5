module DataSelect (
    input  wire [1:0]  loadstore_ds,  //00 nada, 01 load, 10 store
	 input  wire [31:0] rs2_ds,
    output wire [31:0] mem_data_ds,
	 output wire mem_write_ds
);

    assign mem_data_ds = (loadstore_ds != 2'b10) ? 0 : rs2_ds;
	 assign mem_write_ds = (loadstore_ds != 2'b10) ? 0 : 1;


endmodule
