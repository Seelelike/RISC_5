module Registers_tb;

  reg [4:0] ReadRegister1, ReadRegister2, WriteRegister;
  reg RegWrite, clk;
  reg [31:0] WriteData;
  wire [31:0] ReadData1, ReadData2;

  // Instantiate the Register module
  Registers #(5) dut (
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .clk(clk),
    .WriteData(WriteData),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
  );

  initial begin
    // Initialize inputs
    ReadRegister1 = 3; // Example values, change as needed
    ReadRegister2 = 5;
    WriteRegister = 7;
    RegWrite = 1;
    clk = 0;
    WriteData = 32'hA5A5A5A5;

#10 RegWrite = 0;
ReadRegister2 = 7;

end
always begin

    #5 clk = ~clk;


end

endmodule

