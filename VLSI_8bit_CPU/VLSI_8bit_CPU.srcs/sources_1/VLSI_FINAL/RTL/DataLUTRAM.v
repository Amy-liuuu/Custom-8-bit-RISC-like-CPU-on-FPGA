module DataLUTRAM #(XLEN = 32, ADDR_WIDTH = 32, DATA_ENTRY = 256)
(
    input                   clk,
    input  [ADDR_WIDTH-1:0] addr,
    input  [XLEN      -1:0] data_in,
    input                   we,
    output [XLEN      -1:0] data_out
);

(*ram_style = "distributed"*) reg [XLEN-1:0] LUTRAM [DATA_ENTRY-1:0];

initial begin
    $readmemb("MEMORY_PRELOAD_DATA.mem", LUTRAM);
end

always @(posedge clk) begin
    if (we) begin
        LUTRAM[addr] <= data_in;
    end
end

assign data_out = LUTRAM[addr];

endmodule