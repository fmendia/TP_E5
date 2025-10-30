// Copyright (C) 2025  Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, the Altera Quartus Prime License Agreement,
// the Altera IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Altera and sold by Altera or its authorized distributors.  Please
// refer to the Altera Software License Subscription Agreements 
// on the Quartus Prime software download page.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 24.1std.0 Build 1077 03/04/2025 SC Lite Edition"
// CREATED		"Tue Oct  7 17:23:22 2025"

module IFU(
	clk1,
	sel_pc,
	pc_rst,
	Inst_in,
	Inst_out,
	PC_out
);


input wire	clk1;
input wire	sel_pc;
input wire	pc_rst;
input wire	[31:0] Inst_in;
output wire	[31:0] Inst_out;
output wire	[31:0] PC_out;

wire	clk;
wire	select;
wire	[31:0] SYNTHESIZED_WIRE_5;
wire	[31:0] SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_2;
wire	[31:0] SYNTHESIZED_WIRE_4;

assign	PC_out = SYNTHESIZED_WIRE_5;
assign	SYNTHESIZED_WIRE_2 = 0;




adder4	b2v_inst(
	.clk(clk),
	.in(SYNTHESIZED_WIRE_5),
	.out(SYNTHESIZED_WIRE_4));


reg32	b2v_inst1(
	.clk(clk),
	.rst(pc_rst),
	.d(SYNTHESIZED_WIRE_1),
	.qo(SYNTHESIZED_WIRE_5));



reg32	b2v_inst20(
	.clk(clk),
	.rst(SYNTHESIZED_WIRE_2),
	.d(Inst_in),
	.qo(Inst_out));


mux2_1_32	b2v_inst4(
	.sel(select),
	.a(SYNTHESIZED_WIRE_5),
	.b(SYNTHESIZED_WIRE_4),
	.y(SYNTHESIZED_WIRE_1));

assign	clk = clk1;
assign	select = sel_pc;

endmodule
