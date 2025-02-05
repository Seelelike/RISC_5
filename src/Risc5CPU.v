`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: zju
// Engineer: qmj
//////////////////////////////////////////////////////////////////////////////////
module Risc5CPU(clk, reset, JumpFlag, Instruction_id, ALU_A, 
                     ALU_B, ALUResult_ex, PC, MemDout_mem,Stall);
    input clk;
    input reset;
    output[1:0] JumpFlag;
    output [31:0] Instruction_id;
    output [31:0] ALU_A;
    output [31:0] ALU_B;
    output [31:0] ALUResult_ex;
    output [31:0] PC;
    output [31:0] MemDout_mem;
    output Stall;

//IF_DEFINE
wire Branch,Jump,IFWrite,IF_flush;

wire [31:0] JumpAddr,Instruction_if,PC;
IF If(clk, reset, Branch,Jump, IFWrite, JumpAddr,Instruction_if,PC,IF_flush);

//ID_DEFINE

wire ALUSrcA_id;
wire [1:0]ALUSrcB_id;
wire [31:0]PC_id;

wire MemtoReg_id, RegWrite_id, MemWrite_id, MemRead_id;
wire [3:0]ALUCode_id;
wire [31:0]Imm_id,rs1Data_id, rs2Data_id;
wire [4:0]rs1Addr_id,rs2Addr_id,rdAddr_id;

//EX_DEFINE
reg MemtoReg_id_reg, RegWrite_id_reg, MemWrite_id_reg, MemRead_id_reg,ALUSrcA_id_reg;
reg [3:0]ALUCode_id_reg;
reg [1:0]ALUSrcB_id_reg;
reg [4:0]rs1Addr_id_reg,rs2Addr_id_reg,rdAddr_id_reg;
reg [31:0]Imm_id_reg,rs1Data_id_reg, rs2Data_id_reg,PC_id_reg;

wire MemtoReg_ex, RegWrite_ex, MemWrite_ex, MemRead_ex,ALUSrcA_ex;
wire [3:0]ALUCode_ex;
wire [1:0]ALUSrcB_ex;
wire [4:0]rs1Addr_ex,rs2Addr_ex,rdAddr_ex;
wire [31:0]Imm_ex,rs1Data_ex, rs2Data_ex,PC_ex;

wire [31:0]MemWriteData_ex;

//MEM_DEFINE
reg MemtoReg_ex_reg,RegWrite_ex_reg,MemWrite_ex_reg;
reg [31:0]ALUResult_ex_reg,MemWriteData_ex_reg;
reg [4:0]rdAddr_ex_reg;

wire MemtoReg_mem,RegWrite_mem,MemWrite_mem;
wire [31:0]ALUResult_mem,MemWriteData_mem;
wire [4:0]rdAddr_mem;

wire [31:0]MemDout_mem;

//WB_DEFINE
reg [31:0]MemDout_mem_reg,ALUResult_mem_reg;
reg MemtoReg_mem_reg,RegWrite_mem_reg;
reg [4:0]rdAddr_mem_reg;

wire [31:0]MemDout_wb,ALUResult_wb;
wire MemtoReg_wb,RegWrite_wb;
wire [4:0]rdAddr_wb;

//IF

ID id(clk,Instruction_id, PC_id, RegWrite_wb, rdAddr_wb, RegWriteData_wb, MemRead_ex, 
          rdAddr_ex, MemtoReg_id, RegWrite_id, MemWrite_id, MemRead_id, ALUCode_id, 
			 ALUSrcA_id, ALUSrcB_id,  Stall, Branch, Jump, IFWrite,  JumpAddr, Imm_id,
			 rs1Data_id, rs2Data_id,rs1Addr_id,rs2Addr_id,rdAddr_id);


reg [31:0]PC_reg,Instruction_reg;
always@(posedge clk or posedge reset) begin
	if(reset)begin
	PC_reg <=32'd0;
	Instruction_reg<=32'd0;
	end
	else if(IFWrite)begin
	PC_reg<=PC;
	Instruction_reg<=Instruction_if;
	end
end
assign Instruction_id=Instruction_reg;
assign PC_id=PC_reg;



//EX



EX ex(ALUCode_ex, ALUSrcA_ex, ALUSrcB_ex,Imm_ex, rs1Addr_ex, rs2Addr_ex, rs1Data_ex, 
          rs2Data_ex, PC_ex, RegWriteData_wb, ALUResult_mem,rdAddr_mem, rdAddr_wb, 
		  RegWrite_mem, RegWrite_wb, ALUResult_ex, MemWriteData_ex, ALU_A, ALU_B);



always@(posedge clk or posedge reset) begin
	if(reset || Stall)begin
	ALUCode_id_reg<=0;
	ALUSrcA_id_reg<=0;
	ALUSrcB_id_reg<=0;
	MemWrite_id_reg<=0;
	MemRead_id_reg<=0;
	MemtoReg_id_reg<=0;
	RegWrite_id_reg<=0;
	PC_id_reg<=0;
	Imm_id_reg<=0;
	rs1Data_id_reg<=0;
	rs2Data_id_reg<=0;
	rs1Addr_id_reg<=0;
	rs2Addr_id_reg<=0;
	rdAddr_id_reg<=0;
	end
	else begin
	ALUCode_id_reg<=ALUCode_id;
	ALUSrcA_id_reg<=ALUSrcA_id;
	ALUSrcB_id_reg<=ALUSrcB_id;
	MemWrite_id_reg<=MemWrite_id;
	MemRead_id_reg<=MemRead_id;
	MemtoReg_id_reg<=MemtoReg_id;
	RegWrite_id_reg<=RegWrite_id;
	PC_id_reg<=PC_id;
	Imm_id_reg<=Imm_id;
	rs1Data_id_reg<=rs1Data_id;
	rs2Data_id_reg<=rs2Data_id;
	rs1Addr_id_reg<=rs1Addr_id;
	rs2Addr_id_reg<=rs2Addr_id;
	rdAddr_id_reg<=rdAddr_id;
	end
end
assign ALUCode_ex=ALUCode_id_reg;
assign ALUSrcA_ex=ALUSrcA_id_reg;
assign ALUSrcB_ex=ALUSrcB_id_reg;
assign Imm_ex=Imm_id_reg;
assign rs1Addr_ex=rs1Addr_id_reg;
assign rs2Addr_ex=rs2Addr_id_reg;
assign rs1Data_ex=rs1Data_id_reg;
assign rs2Data_ex=rs2Data_id_reg;
assign MemRead_ex=MemRead_id_reg;
assign MemtoReg_ex=MemtoReg_id_reg;
assign MemWrite_ex=MemWrite_id_reg;
assign RegWrite_ex=RegWrite_id_reg;
assign rdAddr_ex=rdAddr_id_reg;
assign PC_ex=PC_id_reg;

//MEM


RAM ram(clk,MemWrite_mem,ALUResult_mem[7:2],MemWriteData_mem,MemDout_mem);

always@(posedge clk or posedge reset) begin
	if(reset) begin
	MemtoReg_ex_reg<=0;
	RegWrite_ex_reg<=0;
	MemWrite_ex_reg<=0;
	ALUResult_ex_reg<=0;
	MemWriteData_ex_reg<=0;
	rdAddr_ex_reg<=0;
	end
	else begin
	MemtoReg_ex_reg<=MemtoReg_ex;
	RegWrite_ex_reg<=RegWrite_ex;
	MemWrite_ex_reg<=MemWrite_ex;
	ALUResult_ex_reg<=ALUResult_ex;
	MemWriteData_ex_reg<=MemWriteData_ex;
	rdAddr_ex_reg<=rdAddr_ex;
	end
end

assign MemtoReg_mem=MemtoReg_ex_reg;
assign RegWrite_mem=RegWrite_ex_reg;
assign MemWrite_mem=MemWrite_ex_reg;
assign ALUResult_mem=ALUResult_ex_reg;
assign MemWriteData_mem=MemWriteData_ex_reg;
assign rdAddr_mem=rdAddr_ex_reg;

//WB


MUX2_1 #(32) wbmux(.x0(RegWrite_wb) ,.x1(MemDout_wb) ,.s(MemtoReg_wb) ,.y(RegWriteData_wb));

always@(posedge clk or posedge reset) begin
	if(reset) begin
	MemDout_mem_reg<=0;
	MemtoReg_mem_reg<=0;
	RegWrite_mem_reg<=0;
	ALUResult_mem_reg<=0;
	rdAddr_mem_reg<=0;
	end
	else begin
	MemDout_mem_reg<=MemDout_mem;
	MemtoReg_mem_reg<=MemtoReg_mem;
	RegWrite_mem_reg<=RegWrite_mem;
	ALUResult_mem_reg<=ALUResult_mem;
	rdAddr_mem_reg<=rdAddr_mem;
	end
end
assign MemDout_wb=MemDout_mem_reg;
assign MemtoReg_wb=MemtoReg_mem_reg;
assign RegWrite_wb=RegWrite_mem_reg;
assign ALUResult_wb=ALUResult_mem_reg;
assign rdAddr_wb=rdAddr_mem_reg;

endmodule
