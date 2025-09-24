module ALU (
  input      [7:0] opA,
  input      [7:0] opB,
  input      [2:0] ALU_op,
  output reg [7:0] result
);

always @(*) begin
  case(ALU_op)
    3'b000:  result = opA + opB;
    3'b001:  result = opA - opB;
    3'b010:  result = opA | opB;
    3'b011:  result = opA & opB;
    3'b100:  result = (opA == opB) ? 8'b1 : 8'b0;
    3'b101:  result = (opA == opB) ? 8'b0 : 8'b1;
    3'b110:  result = {opA[3:0], 4'b0};
    default: result = 8'b1111_1111;
  endcase
end

endmodule