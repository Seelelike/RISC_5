`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: zju
// Engineer: qmj
//////////////////////////////////////////////////////////////////////////////////
module EX(ALUCode_ex, ALUSrcA_ex, ALUSrcB_ex,Imm_ex, rs1Addr_ex, rs2Addr_ex, rs1Data_ex, 
          rs2Data_ex, PC_ex, RegWriteData_wb, ALUResult_mem,rdAddr_mem, rdAddr_wb, 
		  RegWrite_mem, RegWrite_wb, ALUResult_ex, MemWriteData_ex, ALU_A, ALU_B);
    input [3:0] ALUCode_ex;
    input ALUSrcA_ex;
    input [1:0]ALUSrcB_ex;
    input [31:0] Imm_ex;
    input [4:0]  rs1Addr_ex;
    input [4:0]  rs2Addr_ex;
    input [31:0] rs1Data_ex;
    input [31:0] rs2Data_ex;
	input [31:0] PC_ex;
    input [31:0] RegWriteData_wb;
    input [31:0] ALUResult_mem;
	input [4:0]rdAddr_mem;
    input [4:0] rdAddr_wb;
    input RegWrite_mem;
    input RegWrite_wb;
    output [31:0] ALUResult_ex;
    output [31:0] MemWriteData_ex;
    output [31:0] ALU_A;
    output [31:0] ALU_B;

wire [1:0]ForwardA,ForwardB;
reg [31:0] tempA,tempB,B;

assign MemWriteData_ex=tempB;

ALU alu(
	.ALUCode(ALUCode_ex),				// Operation select
	.A(ALU_A),
	.B(ALU_B),
	.ALUResult(ALUResult_ex)
	);

MUX2_1 #(32)ALUA(.x1(PC_ex) ,.x0(tempA) ,.s(ALUSrcA_ex) ,.y(ALU_A));

always @(*) begin
	case(ForwardA)
	2'd0:tempA=rs1Data_ex;
	2'd1:tempA=RegWriteData_wb;
	2'd2:tempA=ALUResult_mem;
	default:tempA=32'd0;
	endcase
end

always @(*) begin
	case(ALUSrcB_ex)
	2'd0:tempB=rs2Data_ex;
	2'd1:tempB=RegWriteData_wb;
	2'd2:tempB=ALUResult_mem;
	default:tempB=32'd0;
	endcase
end

always @(*) begin
	case(ForwardB)
	2'd0:B=tempB;
	2'd1:B=Imm_ex;
	2'd2:B=32'd4;
	default:B=32'd0;
	endcase
end
assign ALU_B=B;

assign ForwardA[0]=RegWrite_wb && (rdAddr_wb!=0)&&(rdAddr_mem!=rs1Addr_ex)&&(rdAddr_wb==rs1Addr_ex);
assign ForwardA[1]=RegWrite_mem && (rdAddr_mem!=0)&&(rdAddr_mem==rs1Addr_ex);
assign ForwardB[0]=RegWrite_wb && (rdAddr_wb!=0)&&(rdAddr_mem!=rs2Addr_ex)&&(rdAddr_wb==rs2Addr_ex);
assign ForwardB[1]=RegWrite_mem && (rdAddr_mem!=0)&&(rdAddr_mem==rs2Addr_ex);

endmodule
