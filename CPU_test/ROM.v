module RAM (
    input clk,               // ????
    input we,                // ???
    input [5:0] addr,        // ?? (6?????0-63)
    input [31:0] din,        // ????
    output reg [31:0] dout        // ????
);
    // ??????
    reg [31:0] ram [63:0];

    always @(posedge clk) begin
        if (we) begin
            ram[addr] <= din;      // ???
        end
        dout <= ram[addr];         // ???
    end
endmodule
