module ALUOp (
  input            ALU_op_pre,
  input      [2:0] inst_oprtr,
  output reg [2:0] ALU_op
);

always @(*) begin
  if (ALU_op_pre) begin
    ALU_op = 3'b000;
  end
  else begin
    ALU_op = inst_oprtr;
  end
end
 
endmodule