module adder_8bits(
	input [7:0]a,b,
	input cin,
	output [7:0]s,
	output cout
);

wire [7:0] g,p;
wire c0,c1,c2,c3,c4,c5,c6;
assign g=a & b;
assign p=a | b;

assign c0=g[0] | p[0]&cin;
assign c1=g[1] | p[1]&g[0] | p[1]&p[0]&cin;
assign c2=g[2] | p[2]&g[1] | p[2]&p[1]&g[0] | p[2]&p[1]&p[0]&cin;
assign c3=g[3] | p[3]&g[2] | p[3]&p[2]&g[1] | p[3]&p[2]&p[1]&g[0] | p[3]&p[2]&p[1]&p[0]&cin; 
assign c4=g[4] | p[4]&g[3] | p[4]&p[3]&g[2] | p[4]&p[3]&p[2]&g[1] | p[4]&p[3]&p[2]&p[1]&g[0] | p[4]&p[3]&p[2]&p[1]&p[0]&cin;
assign c5=g[5] | p[5]&g[4] | p[5]&p[4]&g[3] | p[5]&p[4]&p[3]&g[2] | p[5]&p[4]&p[3]&p[2]&g[1] | p[5]&p[4]&p[3]&p[2]&p[1]&g[0] | p[5]&p[4]&p[3]&p[2]&p[1]&p[0]&cin;
assign c6=g[6] | p[6]&g[5] | p[6]&p[5]&g[4] | p[6]&p[5]&p[4]&g[3] | p[6]&p[5]&p[4]&p[3]&g[2] | p[6]&p[5]&p[4]&p[3]&p[2]&g[1] | p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&g[0] | p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&p[0]&cin;
assign cout=g[7] | p[7]&g[6] | p[7]&p[6]&g[5] | p[7]&p[6]&p[5]&g[4] | p[7]&p[6]&p[5]&p[4]&g[3] | p[7]&p[6]&p[5]&p[4]&p[3]&g[2] | p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&g[1] | p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&g[0] | p[7]&p[6]&p[5]&p[4]&p[3]&p[2]&p[1]&p[0]&cin;

assign s[0]=(p[0]&(!g[0]))^cin;
assign s[1]=(p[1]&(!g[1]))^c0;
assign s[2]=(p[2]&(!g[2]))^c1;
assign s[3]=(p[3]&(!g[3]))^c2;
assign s[4]=(p[4]&(!g[4]))^c3;
assign s[5]=(p[5]&(!g[5]))^c4;
assign s[6]=(p[6]&(!g[6]))^c5;
assign s[7]=(p[7]&(!g[7]))^c6;
endmodule
