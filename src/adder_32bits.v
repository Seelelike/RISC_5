module adder_32bits(
	input [31:0]a,b,
	input ci,
	output [31:0]s,
	output co
);

wire [7:0]a7_0,b7_0,s7_0,a15_8,b15_8,s15_8,a23_16,b23_16,s23_16,a31_24,b31_24,s31_24;
assign a7_0=a[7:0];
assign b7_0=b[7:0];
assign a15_8=a[15:8];
assign b15_8=b[15:8];
assign a23_16=a[23:16];
assign b23_16=b[23:16];
assign a31_24=a[31:24];
assign b31_24=b[31:24];

wire ci1,ci2,ci3,co2_1,co2_0,co3_1,co3_0,co4_1,co4_0;
wire [7:0]so2_1,so2_0,so3_1,so3_0,so4_1,so4_0;

adder_8bits u1(.a(a7_0) ,.b(b7_0) ,.cin(ci) ,.cout(ci1) ,.s(s[7:0]));

adder_8bits u2_1(.a(a15_8) ,.b(b15_8) ,.cin(1'b1) ,.cout(co2_1) ,.s(so2_1));
adder_8bits u2_0(.a(a15_8) ,.b(b15_8) ,.cin(1'b0) ,.cout(co2_0) ,.s(so2_0));
MUX2_1 u2(.x1(so2_1) ,.x0(so2_0) ,.s(ci1) ,.y(s[15:8]));
assign ci2=co2_0 | ci1&co2_1;

adder_8bits u3_1(.a(a23_16) ,.b(b23_16) ,.cin(1'b1) ,.cout(co3_1) ,.s(so3_1));
adder_8bits u3_0(.a(a23_16) ,.b(b23_16) ,.cin(1'b0) ,.cout(co3_0) ,.s(so3_0));
MUX2_1 u3(.x1(so3_1) ,.x0(so3_0) ,.s(ci2) ,.y(s[23:16]));
assign ci3=co3_0 | ci2&co3_1;

adder_8bits u4_1(.a(a31_24) ,.b(b31_24) ,.cin(1'b1) ,.cout(co4_1) ,.s(so4_1));
adder_8bits u4_0(.a(a31_24) ,.b(b31_24) ,.cin(1'b0) ,.cout(co4_0) ,.s(so4_0));
MUX2_1 u4(.x1(so4_1) ,.x0(so4_0) ,.s(ci3) ,.y(s[31:24]));
assign co=co4_0 | ci3&co4_1;

endmodule
