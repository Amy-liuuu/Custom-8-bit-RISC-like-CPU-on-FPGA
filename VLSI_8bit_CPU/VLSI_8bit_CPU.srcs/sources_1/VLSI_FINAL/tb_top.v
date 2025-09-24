
module tb_top;

reg  sys_reset = 1;
reg  sys_clock = 0;

wire usr_reset;
wire clk, rst;
// External reset signal
assign usr_reset = sys_reset;

// --------- System Clock Generator --------------------------------------------
assign clk = sys_clock;

always
  #((1000_000_000/100_000_000)/2) sys_clock <= ~sys_clock; // 100 MHz

localparam RST_CYCLES=5;
reg [RST_CYCLES-1 : 0] rst_count = {RST_CYCLES{1'b1}};
assign rst = rst_count[RST_CYCLES-1];

always @(posedge clk)
begin
    if (usr_reset)
        rst_count <= {RST_CYCLES{1'b1}};
    else
        rst_count <= {rst_count[RST_CYCLES-2 : 0], 1'b0};
end


wire       data_mem_wr_en;
wire [7:0] data_mem_wr_addr;
wire [7:0] data_mem_wr_data;

wire mmio_en;
assign mmio_en = (data_mem_wr_addr == 8'b0000_0000) & data_mem_wr_en;
// CPU
CPU 
CPU_core(
    .clk              (clk),
    .rst_n            (~rst),
    .data_mem_wr_en   (data_mem_wr_en),
    .data_mem_wr_addr (data_mem_wr_addr),
    .data_mem_wr_data (data_mem_wr_data)
);



// UART stuff
uart_tx_tb
uart_tx_tb_inst(
    .clk       (clk),
    .rst       (rst),
    .wr_valid  (data_mem_wr_en & (data_mem_wr_addr == 8'b0)),
    .byte_in   (data_mem_wr_data),
    .wr_ready  (uart_tx_stat)
);


// clock stuff

event reset_trigger;
event reset_done_trigger;

initial begin
  forever begin
    @ (reset_trigger);
    sys_reset = 1;
    @ (posedge clk);
    @ (posedge clk);
    sys_reset = 0;
    -> reset_done_trigger;
  end
end

initial
begin: TEST_CASE
    #10 -> reset_trigger;
end

endmodule