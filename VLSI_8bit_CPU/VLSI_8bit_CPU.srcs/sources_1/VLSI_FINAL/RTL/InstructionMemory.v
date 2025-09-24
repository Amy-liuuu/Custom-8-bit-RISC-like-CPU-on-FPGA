module InstructionMemory 
(
    input        clk,
    input  [7:0] readAddr,
    output [7:0] inst
);

InstructionLUTRAM #(.XLEN(8), .ADDR_WIDTH(8), .DATA_ENTRY(256))
i_memory
(
    .clk(clk),
    .addr(readAddr),
    .data_in(8'b0),
    .we(1'b0),
    .data_out(inst)
);

endmodule