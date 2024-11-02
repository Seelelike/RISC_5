module MUX2_1
# (parameter Bitwidth = 8)
(
	input [Bitwidth-1:0]x0,x1,
	input s,
	output [Bitwidth-1:0]y
);
	assign y=s?x1:x0;

endmodule

