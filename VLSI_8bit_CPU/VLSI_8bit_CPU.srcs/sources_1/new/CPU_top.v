`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2024 02:59:36 PM
// Design Name: 
// Module Name: cpu_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module CPU_top
(
    input           sysclk_i,
    input           resetn_i,

    // uart
    input           uart_rx,
    output          uart_tx
);

wire        sys_clk;
wire        cp0_clk;
reg         rst;
reg  [5 :0] sync_rst_sr;

wire       data_mem_wr_en;
wire [7:0] data_mem_wr_addr;
wire [7:0] data_mem_wr_data;

assign SevenSegment = 8'b0;
assign Enable       = 4'b0;


clk_wiz_0 cpu_clock_gen(
    .clk_in1  (sysclk_i),
    .clk_out1 (cp0_clk)
);



// CPU
CPU 
CPU_core(
    .clk              (cp0_clk),
    .rst_n            (~rst),
    .data_mem_wr_en   (data_mem_wr_en),
    .data_mem_wr_addr (data_mem_wr_addr),
    .data_mem_wr_data (data_mem_wr_data)
);

// ====================================================================



// Modify the parameter inside uart_tx module for different clock configurations.
//uart_tx
//uart_tx_inst(
//    .i_Clock     (cp0_clk),
//    .i_Tx_DV     (data_mem_wr_en & (data_mem_wr_addr == 8'b0)),
//    .i_Tx_Byte   (data_mem_wr_data),
//    .o_Tx_Active (),
//    .o_Tx_Serial (uart_tx)
//);

uart_tx
uart_tx_inst(
    .clk       (cp0_clk),
    .rst       (rst),
    .wr_valid  (data_mem_wr_en & (data_mem_wr_addr == 8'b0)),
    .byte_in   (data_mem_wr_data),
    .wr_ready  (),
    .tx_serial (UART_TX)
);




always @(posedge cp0_clk) begin
    if (!resetn_i) begin
        sync_rst_sr <= 6'b111_111;
    end
    else begin
        sync_rst_sr <= {sync_rst_sr[4:0], 1'b0};
    end
end

always @(posedge cp0_clk) begin
    rst <= sync_rst_sr[5];
end




endmodule