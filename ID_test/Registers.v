module Registers
# (parameter Bitwidth = 5)
(
	input [Bitwidth-1:0] ReadRegister1,ReadRegister2,WriteRegister,
	input RegWrite,clk,
	input [2**Bitwidth-1:0]WriteData,
	output [2**Bitwidth-1:0] ReadData1,ReadData2
);

reg [2**Bitwidth-1:0]regs[2**Bitwidth-1:0];
wire rs1Sel,rs2Sel;
wire [2**Bitwidth-1:0] TempReadData1,TempReadData2;

assign rs1Sel = RegWrite&&(WriteRegister!=0)&&(WriteRegister == ReadRegister1);
assign rs2Sel = RegWrite&&(WriteRegister!=0)&&(WriteRegister == ReadRegister2);


assign TempReadData1 = (ReadRegister1 == 0)? 0:regs[ReadRegister1];
assign TempReadData2 = (ReadRegister2 == 0)? 0:regs[ReadRegister2];

always @ (posedge clk) begin
	if(RegWrite) begin
		regs[WriteRegister] <= WriteData;
	end
end

MUX2_1 #(.Bitwidth(32)) Sel1(.x0(TempReadData1),.x1(WriteData),.s(rs1Sel),.y(ReadData1));
MUX2_1 #(32) Sel2(.x0(TempReadData2),.x1(WriteData),.s(rs2Sel),.y(ReadData2));

endmodule
