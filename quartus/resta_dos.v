module resta_dos (
    input  wire [31:0] din,
    output wire [31:0] dout
);

assign dout = (din > 32'd12) ? (din - 32'd12) : 32'd0;

endmodule
