module AddrSelect (
    input  wire [1:0]  loadstore_as,  // 00: nada, 01: load, 10: store
    input  wire [31:0] rs1_as,
    input  wire [31:0] Imm_as,
    output wire [9:0]  mem_address_as   // solo 10 bits porque hay 1024 palabras
);

    wire [31:0] addr_full_as;
	 
    assign addr_full_as = rs1_as + Imm_as;

    assign mem_address_as = (loadstore_as != 2'b00) ?
                         ((addr_full_as < 1024) ? addr_full_as[9:0] : 10'b0) :
                         10'b0;

endmodule
