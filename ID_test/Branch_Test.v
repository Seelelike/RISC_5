module Branch_Test
(
input [31:0]rs1Data,rs2Data,
input [2:0]funct3,
input [6:0]op,
output reg Branch
);

parameter SB_type_op = 7'h63;
parameter beq_funct3 = 3'o0;
parameter bne_funct3 = 3'o1;
parameter blt_funct3 = 3'o4;
parameter bge_funct3 = 3'o5;
parameter bltu_funct3 = 3'o6;
parameter bgeu_funct3 = 3'o7;

wire SB_type,isLT,isLTU;
wire [31:0]sum;
assign sum=rs1Data+rs2Data+1;
assign SB_type = (op==SB_type_op);

assign isLT= rs1Data[31] & (~rs2Data[31]) | (rs1Data[31]~^rs2Data[31]) & sum[31];
assign isLTU= (~rs1Data[31]) & (rs2Data[31]) | (rs1Data[31]~^rs2Data[31]) & sum[31];


always @(*)begin
	if(SB_type==1'b1) begin	
	case(funct3)
		beq_funct3:Branch=~(|sum[31:0]);
		bne_funct3:Branch=(|sum[31:0]);
		blt_funct3:Branch=isLT;
		bge_funct3:Branch=(~isLT);
		bltu_funct3:Branch=isLTU;
		bgeu_funct3:Branch=(~isLTU);
		default:Branch=1'b0;
	endcase
	end
	else Branch=1'b0;

end
endmodule
