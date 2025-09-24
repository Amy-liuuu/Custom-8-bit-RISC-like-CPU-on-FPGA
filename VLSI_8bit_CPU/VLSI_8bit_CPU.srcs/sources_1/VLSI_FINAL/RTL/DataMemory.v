module DataMemory 
(
    input        clk,
    input        wr_en,
    input  [7:0] addr,
    input  [7:0] write_data,
    output [7:0] read_data
);

DataLUTRAM #(.XLEN(8), .ADDR_WIDTH(8), .DATA_ENTRY(256))
i_memory
(
    .clk(clk),
    .addr(addr),
    .data_in(write_data),
    .we(wr_en),
    .data_out(read_data)
); 

endmodule