module ProgramCounter (
  input        clk,
  input        rst_n,
  input  [7:0] next_inst_in,
  output [7:0] next_inst_out
);

reg [7:0] PC_r;
assign next_inst_out = PC_r;

always @(posedge clk) begin
  if (rst_n == 0) PC_r <= 'd0;
  else            PC_r <= next_inst_in;
end

endmodule


module PCALU (
  input  [7:0] PC,
  output [7:0] PCALU_a1
);

assign PCALU_a1 = PC + 1'd1;

endmodule


module AddrReg(
  input            clk,
  input            rst_n,
  input            write,
  input      [7:0] write_data,
  output reg [7:0] addr_reg
);


always @(posedge clk) begin
  if (rst_n == 0) addr_reg <= 'd0;
  else if (write) addr_reg <= write_data;
  else            addr_reg <= addr_reg;
end

endmodule

module MUX21 #(
  parameter DATA_SZ = 8
) (
  input  [DATA_SZ-1:0] data_0,
  input  [DATA_SZ-1:0] data_1,
  input                select,
  output [DATA_SZ-1:0] data_out
);

assign data_out = (select == 'd1) ? data_1 : data_0;

endmodule