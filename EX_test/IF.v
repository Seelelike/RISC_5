`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  zju
// Engineer: qmj
//////////////////////////////////////////////////////////////////////////////////
module IF(clk, reset, Branch,Jump, IFWrite, JumpAddr,Instruction_if,PC,IF_flush);
    input clk;
    input reset;
    input Branch;
    input Jump;
    input IFWrite;
    input [31:0] JumpAddr;
    output [31:0] Instruction_if;
    output [31:0] PC;
    output IF_flush;

wire PCSource;
wire [31:0]PC_temp;



assign PCSource=Branch || Jump;
reg [31:0]PC_reg;
assign PC=PC_reg;

MUX2_1 #(32) Sou(.x1(JumpAddr) ,.x0(PC+32'd4) ,.s(PCSource) ,.y(PC_temp));

InstructionROM rom(.addr(PC[5:0]) ,.dout(Instruction_if));

always @(posedge clk or posedge reset) begin
	if(reset) begin
	PC_reg<=32'd0;
	end
	else if(IFWrite) begin
	PC_reg<=PC_temp;
	end
end

assign IF_flush=IFWrite;

endmodule
