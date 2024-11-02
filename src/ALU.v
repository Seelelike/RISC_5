//******************************************************************************
// MIPS verilog model
//
// ALU.v
//******************************************************************************

module ALU (
	// Outputs
	   ALUResult,
	// Inputs
	   ALUCode, A, B);
	input [3:0]	ALUCode;				// Operation select
	input [31:0]	A, B;
	output [31:0]	ALUResult;
	
// Decoded ALU operation select (ALUsel) signals
   parameter	 alu_add=  4'b0000;
   parameter	 alu_sub=  4'b0001;
   parameter	 alu_lui=  4'b0010;
   parameter	 alu_and=  4'b0011;
   parameter	 alu_xor=  4'b0100;
   parameter	 alu_or =  4'b0101;
   parameter 	 alu_sll=  4'b0110;
   parameter	 alu_srl=  4'b0111;
   parameter	 alu_sra=  4'b1000;
   parameter	 alu_slt=  4'b1001;
   parameter	 alu_sltu= 4'b1010; 	

wire [31:0]ALUCode_0,Adder_b,Adder_d0,Adder_d1,Adder_d2,Adder_d3,Adder_d4,Adder_d5,Adder_d6,Adder_d7,Adder_d8,Adder_d9,Adder_d10;

reg signed [31:0] A_reg;

always @(*) begin
	A_reg = A;
end

assign Adder_B = (ALUCode[0]==1'b0)? B: ~B;
assign Adder_d1= Adder_d0;
assign Adder_d2= B;
assign Adder_d3= A&B;
assign Adder_d4= A^B;
assign Adder_d5= A|B;
assign Adder_d6= A<<B;
assign Adder_d7= A>>B;
assign Adder_d8= A_reg >>> B;
assign Adder_d9= A[31] && (~B[31]) || (A[31]~^B[31]) && Adder_d0[31];
assign Adder_d10= (~A[31]) && B[31] || (A[31]~^B[31]) && Adder_d0[31];



adder_32bits Adder(
	.a(A),
	.b(Adder_B),
	.ci(ALUCode[0]),
	.s(Adder_d0),
	.co()
	);

reg [31:0] reg_result;

always @(*) begin
case(ALUCode)
            4'b0000: reg_result = Adder_d0;  
            4'b0001: reg_result = Adder_d1;  
            4'b0010: reg_result = Adder_d2;  
            4'b0011: reg_result = Adder_d3;  
            4'b0100: reg_result = Adder_d4;  
            4'b0101: reg_result = Adder_d5;  
            4'b0110: reg_result = Adder_d6;  
            4'b0111: reg_result = Adder_d7;  
            4'b1000: reg_result = Adder_d8;  
            4'b1001: reg_result = Adder_d9;  
	    4'b1010: reg_result = Adder_d10;
            default: reg_result = 32'd0;   // ????0??? latch
        endcase
    end

assign ALUResult=reg_result;

endmodule

