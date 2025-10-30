`timescale 1ns/1ps

module tb_prog_ram;

  reg clock;
  reg [9:0] address;
  wire [31:0] q;

  prog_ram dut (
    .clock(clock),
    .address(address),
    .data(32'b0),
    .wren(1'b0),
    .q(q)
  );

  // Clock 50 MHz
  initial begin
    clock = 0;
    forever #10 clock = ~clock; // período 20 ns
  end

  initial begin
    address = 0;

    @(posedge clock); // flanco 1
    $display("t=%0t | address=%0d | q=%0d (esperado 102)", $time, address, q);

    address = 1; // cambio de address

    @(posedge clock); // flanco 2
    $display("t=%0t | address=%0d | q=%0d (esperado 64)", $time, address, q);

    address = 2;
    @(posedge clock); // flanco 3
    $display("t=%0t | address=%0d | q=%0d (esperado 3)", $time, address, q);
    
	 address = 20;
	 @(posedge clock); // flanco 4
    $display("t=%0t | address=%0d | q=%0d (esperado 21)", $time, address, q);
	 
	 address = 0;
    @(posedge clock); // flanco 5
    $display("t=%0t | address=%0d | q=%0d (esperado 102)", $time, address, q);


    #20;
    $stop;
  end

endmodule
