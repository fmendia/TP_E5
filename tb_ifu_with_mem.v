`timescale 1ns/1ps

module tb_ifu_with_mem;

  // ============================
  // Señales
  // ============================
  reg clk;
  reg pc_rst;
  reg sel_pc;
  wire [31:0] inst_out;
  wire [31:0] pc_out;
  wire [31:0] mem_out;

  // ============================
  // Memoria de instrucciones
  // ============================
  prog_ram memory (
    .clock(clk),
    .address(pc_out[11:2]),  // PC/4 -> palabra de 32 bits
    .data(32'b0),
    .wren(1'b0),
    .q(mem_out)
  );

  // ============================
  // IFU
  // ============================
  IFU dut (
    .Inst_in(mem_out),
    .pc_rst(pc_rst),
    .sel_pc(sel_pc),
    .clk1(clk),
    .Inst_out(inst_out),
    .PC_out(pc_out)
  );

  // ============================
  // Generador de clock
  // ============================
  initial begin
    clk = 0;
    forever #10 clk = ~clk; // 50 MHz
  end

  // ============================
  // Secuencia de prueba
  // ============================
  initial begin
    // Estado inicial
    sel_pc = 0;		//0 es realimentar el PC, 1 es habilitar PC = PC + 4.
    pc_rst = 1;     // reset activo
    #25;
    pc_rst = 0;     // libera reset (PC = 0)

    // Ciclo 1 -> leer posición 0
    @(posedge clk);
    #1;
	 sel_pc=0;
	 #100
    $display("PC=%0d | Inst=%0d (esperado 102)", pc_out, inst_out);
	 sel_pc=1;
	 

    // Ciclo 2 -> leer posición 1
    @(posedge clk);
    #1;
	 sel_pc=0;
	 #100
    $display("PC=%0d | Inst=%0d (esperado 64)", pc_out, inst_out);
	 sel_pc=1;
    // Ciclo 3 -> leer posición 2
    @(posedge clk);
    #1;
	 sel_pc=0;
	 #100
    $display("PC=%0d | Inst=%0d (esperado valor posicion 3(3))", pc_out, inst_out);
	 sel_pc=1;
    #50;
    $stop;
  end

endmodule