`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
//////////////////////////////////////////////////////////////////////////////////
module ID(clk,Instruction_id, PC_id, RegWrite_wb, rdAddr_wb, RegWriteData_wb, MemRead_ex, 
          rdAddr_ex, MemtoReg_id, RegWrite_id, MemWrite_id, MemRead_id, ALUCode_id, 
			 ALUSrcA_id, ALUSrcB_id,  Stall, Branch, Jump, IFWrite,  JumpAddr, Imm_id,
			 rs1Data_id, rs2Data_id,rs1Addr_id,rs2Addr_id,rdAddr_id);
    input clk;
    input [31:0] Instruction_id;
    input [31:0] PC_id;
    input RegWrite_wb;
    input [4:0] rdAddr_wb;
    input [31:0] RegWriteData_wb;
    input MemRead_ex;
    input [4:0] rdAddr_ex;
    output MemtoReg_id;
    output RegWrite_id;
    output MemWrite_id;
    output MemRead_id;
    output [3:0] ALUCode_id;
    output ALUSrcA_id;
    output [1:0]ALUSrcB_id;
    output Stall;
    output Branch;
    output Jump;
    output IFWrite;
    output [31:0] JumpAddr;
    output [31:0] Imm_id;
    output [31:0] rs1Data_id;
    output [31:0] rs2Data_id;
	output[4:0] rs1Addr_id,rs2Addr_id,rdAddr_id;
 
assign rs1Addr_id = Instruction_id[19:15];
assign rs2Addr_id = Instruction_id[24:20];
assign rdAddr_id = Instruction_id[11:7];


Registers #(5) Registers1
(
	.ReadRegister1(Instruction_id[19:15]),
	.ReadRegister2(Instruction_id[24:20]),
	.WriteRegister(rdAddr_wb),
	.RegWrite(RegWrite_wb),
	.clk(clk),
	.ReadData1(rs1Data_id),
	.ReadData2(rs2Data_id),
	.WriteData(RegWriteData_wb)
);


wire [31:0] offset,JALR_reg;
wire JALR;
Transister Transister1
(
	.Instruction(Instruction_id),
	.Imm(Imm_id),
	.Offset(offset),
	.MemtoReg(MemtoReg_id),
	.MemRead(MemRead_id),
	.MemWrite(MemWrite_id),
	.RegWrite(RegWrite_id),
	.Jump(Jump),
	.ALUSrcA(ALUSrcA_id),
	.ALUSrcB(ALUSrcB_id),
	.ALUCode(ALUCode_id),
	.JALR(JALR)
);

Branch_Test Branch_test
(
	.rs1Data(rs1Data_id),
	.rs2Data(rs2Data_id),
	.funct3(Instruction_id[14:12]),
	.op(Instruction_id[6:0]),
	.Branch(Branch)
);

MUX2_1 #(.Bitwidth(32)) MUX1 (.x0(PC_id) ,.x1(rs1Data_id) ,.s(JALR) ,.y(JALR_reg));
assign JumpAddr=JALR_reg+offset;

//maoxian
assign Stall=((rdAddr_ex == rs1Addr_id)||(rdAddr_ex==rs2Addr_id)) && MemRead_ex;
assign IFWrite=~Stall;

endmodule
