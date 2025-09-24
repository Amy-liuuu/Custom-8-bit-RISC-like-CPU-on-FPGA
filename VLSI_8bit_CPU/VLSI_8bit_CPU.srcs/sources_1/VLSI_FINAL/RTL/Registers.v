module Registers (
  input        clk,
  input        rst_n,
    
  input  [1:0] rsA_addr,
  input  [1:0] rsB_addr,
  output [7:0] rsA_data,
  output [7:0] rsB_data,
    
  input        wr_en,
  input  [1:0] wr_addr,
  input  [7:0] wr_data
);

reg [7:0] regs [3:0];

// For debug maybe
wire [7:0] R0, R1, R2, R3;
assign R0 = regs[0];
assign R1 = regs[1];
assign R2 = regs[2];
assign R3 = regs[3];

assign rsA_data = regs[rsA_addr];
assign rsB_data = regs[rsB_addr];

always @(negedge clk) begin
  if (rst_n == 0) begin
    regs[0] <= 8'd0;
    regs[1] <= 8'd0;
    regs[2] <= 8'd0;
    regs[3] <= 8'd0;
  end
  else if (wr_en) begin
    regs[wr_addr] <= wr_data;
  end
  else begin
    regs[0] <= regs[0];
    regs[1] <= regs[1];
    regs[2] <= regs[2];
    regs[3] <= regs[3]; 
  end
end

endmodule