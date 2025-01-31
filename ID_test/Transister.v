//ALUCode unfinish
module Transister
(
input [31:0]Instruction,
output [31:0]Imm,Offset,
output MemtoReg,MemRead,MemWrite,RegWrite,Jump,ALUSrcA,JALR,
output [1:0]ALUSrcB,
output [3:0]ALUCode
);

parameter R_type_op = 7'h33;
parameter I_type_op = 7'h13;
parameter SB_type_op = 7'h63;
parameter LW_op = 7'h03;
parameter JALR_op = 7'h67;
parameter SW_op = 7'h23;
parameter LUI_op = 7'h37;
parameter AUIPC_op = 7'h17;
parameter JAL_op = 7'h6F;

wire R_type,I_type,SB_type,LW,SW,LUI,AUIPC,JAL,Shift;
wire [6:0]op;
wire [2:0]funct3;
reg [3:0]ALUCode_reg;

assign funct3=Instruction[14:12];
assign op = Instruction[6:0];
assign R_type = (op==R_type_op);
assign I_type = (op==I_type_op);
assign SB_type = (op==SB_type_op);
assign LW = (op==LW_op);
assign JALR = (op==JALR_op);
assign SW = (op==SW_op);
assign LUI = (op==LUI_op);
assign AUIPC = (op==AUIPC_op);
assign JAL = (op==JAL_op);

assign MemtoReg = LW;
assign MemRead = LW;
assign MemWrite = SW;
assign RegWrite = R_type | I_type | LW | JALR | LUI | AUIPC | JAL;
assign Jump = JALR | JAL;
assign ALUSrcA = JALR | JAL | AUIPC;
assign ALUSrcB[1] = JAL | JALR;
assign ALUSrcB[0] = ~(R_type | JAL | JALR);

assign Shift = (funct3 == 1) | (funct3 ==5 );
assign Imm = (I_type && Shift)? {27'd0,Instruction[24:20]}:
		(I_type && ~Shift || LW)?{{20{Instruction[31]}},Instruction[31:20]}:
		(SW)?{{20{Instruction[31]}},Instruction[31:25],Instruction[11:7]}:
		(LUI || AUIPC)?{Instruction[31:12],12'd0}:32'd0;
assign Offset = (JALR)?{{20{Instruction[31]}},Instruction[31:20]}:
		(JAL)?{{11{Instruction[31]}},Instruction[31],Instruction[19:12],Instruction[20],Instruction[30:21],1'b0}:
		(SB_type)?{{19{Instruction[31]}},Instruction[31],Instruction[7],Instruction[30:25],Instruction[11:8],1'b0}:32'd0;	

always @(*)begin
	case({R_type,I_type,LUI,funct3,Instruction[30]})
		7'b1000000:ALUCode_reg=4'd0;
		7'b1000001:ALUCode_reg=4'd1;
		7'b1000010:ALUCode_reg=4'd6;
		7'b1000100:ALUCode_reg=4'd9;
		7'b1000110:ALUCode_reg=4'd10;
		7'b1001000:ALUCode_reg=4'd4;
		7'b1001010:ALUCode_reg=4'd7;
		7'b1001011:ALUCode_reg=4'd8;
		7'b1001100:ALUCode_reg=4'd5;
		7'b1001110:ALUCode_reg=4'd3;
		7'b010000x:ALUCode_reg=4'd0;
		7'b010001x:ALUCode_reg=4'd6;
		7'b010010x:ALUCode_reg=4'd9;
		7'b010011x:ALUCode_reg=4'd10;
		7'b010100x:ALUCode_reg=4'd4;
		7'b0101010:ALUCode_reg=4'd7;
		7'b0101011:ALUCode_reg=4'd8;
		7'b010110x:ALUCode_reg=4'd5;
		7'b010111x:ALUCode_reg=4'd3;
		7'b001xxxx:ALUCode_reg=4'd2;
		default:ALUCode_reg=4'd0;
	endcase
end

assign ALUCode = ALUCode_reg;


endmodule

