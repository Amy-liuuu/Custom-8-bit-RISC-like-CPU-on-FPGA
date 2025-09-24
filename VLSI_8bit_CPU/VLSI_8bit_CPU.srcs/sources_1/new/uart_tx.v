`timescale 1ns / 1ps
`include "parameters.vh"

//////////////////////////////////////////////////////////////////////////////////
// Company: CAS lab
// Create Date: 01/11/2025 08:18:43 PM
// Module Name: uart_tx
//////////////////////////////////////////////////////////////////////////////////

module uart_tx
(
    input       clk,
    input       rst, // active high, sync
    input       wr_valid,
    output      wr_ready,
    input [7:0] byte_in,
    output      tx_serial
);

parameter CLKS_PER_BIT = `CPU_CLK / `UART_BAUD_RATE;
parameter S_IDLE    = 2'd2;
parameter S_TX_SEND = 2'd1;
parameter S_END_BIT = 2'd0; // accept next data at END_BIT to reduce delay

// DFFs
reg [1:0] state_r;
reg [8:0] start_w_byte_r;
reg       wr_ready_r;
reg       early_in;   // High when accept input data at 'end bit' state
reg [3:0] sent_count; // countdown, 8~0 start bit + byte
reg [$clog2(CLKS_PER_BIT)-1:0] clk_count; // countdown

reg [1:0] next_state;
wire      wr_ready_internal;

always @(posedge clk) begin
    if (rst) state_r <= S_IDLE;
    else     state_r <= next_state;
end

always @(*) begin
    case (state_r)
    S_IDLE: begin
        if (wr_valid) next_state = S_TX_SEND;
        else          next_state = S_IDLE;
    end
    S_TX_SEND: begin
        if (sent_count == 0) next_state = S_END_BIT;
        else                 next_state = S_TX_SEND;
    end
    S_END_BIT: begin
        if (clk_count == 0) begin
            if (early_in) next_state = S_TX_SEND;
            else          next_state = S_IDLE;
        end
        else next_state = S_END_BIT;
    end
    default: begin
        next_state = state_r;
    end
    endcase
end

// 'early_in' will be high when input data is accepted @ END_BIT state
always @(posedge clk) begin
    if (rst) begin
        early_in <= 1'b0;
    end
    else if (state_r == S_END_BIT && wr_valid) begin
        early_in <= 1'b1;
    end
    else if (next_state == S_TX_SEND) begin
        early_in <= 1'b0;
    end
end

always @(posedge clk) begin
    if (wr_ready & wr_valid) begin
        start_w_byte_r <= {byte_in, 1'b0};
    end
    else if (clk_count == 0 && state_r == S_TX_SEND) begin
        start_w_byte_r <= {1'b0, start_w_byte_r[8:1]};
    end
end

always @(posedge clk) begin
    if (rst || state_r[1] == 1'b1) begin
        clk_count <= CLKS_PER_BIT;
    end
    else if (state_r[1] == 1'b0) begin // encoding hack, END_BIT & TX_SEND have 0 @ MSB bit
        if (clk_count == 0) begin
            clk_count <= CLKS_PER_BIT;
        end
        else begin
            clk_count <= clk_count - 1'b1;
        end
    end
end

always @(posedge clk) begin
    if (rst || state_r[0] == 1'b0) begin // encoding hack, END_BIT & IDLE have 0 @ LSB bit
        sent_count <= 4'd9;
    end
    else if (state_r == S_TX_SEND && clk_count == 1) begin
        sent_count <= sent_count - 1'b1;
    end
end

always @(posedge clk) begin
    if (rst) begin
        wr_ready_r <= 1'b1;
    end
    else if ((state_r == S_IDLE || state_r == S_END_BIT) && wr_valid) begin
        wr_ready_r <= 1'b0;
    end
    else if (state_r == S_TX_SEND && next_state == S_END_BIT) begin
        wr_ready_r <= 1'b1;
    end
end

assign wr_ready_internal = (state_r == S_IDLE || state_r == S_END_BIT);
assign tx_serial         = (state_r[0] == 1'b0) ? 1'b1 : start_w_byte_r[0];
assign wr_ready          = wr_ready_r;

endmodule