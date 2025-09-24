`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/29/2025 09:56:14 PM
// Design Name: 
// Module Name: uart_tx_tb
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


module uart_tx_tb
(
    input       clk,
    input       rst, // active high, sync
    input       wr_valid,
    output      wr_ready,
    input [7:0] byte_in
);

reg wr_ready_r;
always @(posedge clk) begin
    if (rst) begin
        wr_ready_r <= 1'b1;
    end
    else begin
        if (wr_valid) begin
            wr_ready_r <= 1'b0;
        end
        else begin
            wr_ready_r <= 1'b1;
        end
    end
end

always @(posedge clk) begin
    if (wr_valid) begin
        if (byte_in != 13) begin
            $write("%c", byte_in);
        end
    end
end

assign wr_ready = wr_ready_r;
endmodule 