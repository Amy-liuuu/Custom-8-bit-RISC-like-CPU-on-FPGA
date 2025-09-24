module Control (
  input  [7:0] inst_input,
  output reg   reg_file_wr_en,
  output reg   data_mem_wr_en,
  output reg   addr_reg_wr_en,
  output reg   branch_en,
  output reg   data_mem_rd,
  output reg   use_imm,
  output       ALU_op_pre
);



wire [3:0] oprtr_series;
wire [3:0] oprnd_series;
assign oprtr_series = inst_input[7:4];
assign oprnd_series = inst_input[3:0];
assign ALU_op_pre  = (oprtr_series[3:2] == 2'b11) ? 1'b1 : 1'b0;


always @(*) begin
  if (oprtr_series == 4'b0111) begin // LJ
    reg_file_wr_en = 1'b0;
    data_mem_wr_en = 1'b0;
    addr_reg_wr_en = 1'b1; // asserted
    branch_en      = 1'b0;
    data_mem_rd    = 1'b0;
    use_imm        = 1'b0;
  end
  else if (oprtr_series[3:1] == 3'b010) begin // B-type
    reg_file_wr_en = 1'b0;
    data_mem_wr_en = 1'b0;
    addr_reg_wr_en = 1'b0;
    branch_en      = 1'b1; // asserted
    data_mem_rd    = 1'b0;
    use_imm        = 1'b0;
  end
  else if (oprtr_series[3:2] == 2'b11) begin // I-type addi
    reg_file_wr_en = 1'b1; // asserted
    data_mem_wr_en = 1'b0;
    addr_reg_wr_en = 1'b0;
    branch_en      = 1'b0;
    data_mem_rd    = 1'b0;
    use_imm        = 1'b1;
  end
  else if (oprtr_series[3:0] == 4'b0110) begin // sl4
    reg_file_wr_en = 1'b1; // asserted
    data_mem_wr_en = 1'b0;
    addr_reg_wr_en = 1'b0;
    branch_en      = 1'b0;
    data_mem_rd    = 1'b0;
    use_imm        = 1'b0;
  end
  else if (oprtr_series[3:0] == 4'b0001) begin // L-type LB
    reg_file_wr_en = 1'b1; // assert
    data_mem_wr_en = 1'b0;
    addr_reg_wr_en = 1'b0;
    branch_en      = 1'b0;
    data_mem_rd    = 1'b1;
    use_imm        = 1'b0;
  end
  else if (oprtr_series[3:0] == 4'b0011) begin // L-type SB
    reg_file_wr_en = 1'b0;
    data_mem_wr_en = 1'b1; // assert
    addr_reg_wr_en = 1'b0;
    branch_en      = 1'b0;
    data_mem_rd    = 1'b1;
    use_imm        = 1'b0;
  end
  else if (oprtr_series[3:2] == 2'b10) begin // R-type
    reg_file_wr_en = 1'b1; // assert
    data_mem_wr_en = 1'b0;
    addr_reg_wr_en = 1'b0;
    branch_en      = 1'b0;
    data_mem_rd    = 1'b0;
    use_imm        = 1'b0;
  end
  else begin
    reg_file_wr_en = 'h0;
    data_mem_wr_en = 'h0;
    addr_reg_wr_en = 'h0;
    branch_en      = 'h0;
    data_mem_rd    = 'h0;
    use_imm        = 'h0;
  end
end
  
endmodule