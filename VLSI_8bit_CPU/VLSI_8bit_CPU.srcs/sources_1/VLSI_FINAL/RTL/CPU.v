module CPU (
  input        clk,
  input        rst_n,
  output       data_mem_wr_en,
  output [7:0] data_mem_wr_addr,
  output [7:0] data_mem_wr_data
);


// Register signals
wire [7:0] rsA_data;
wire [7:0] rsB_data;
wire       regs_wr_en;
wire [7:0] regs_wr_data;

// program counter
wire [7:0] pc_in;
wire [7:0] pc_out;
wire [7:0] pc_a1;

// instruction memory
wire [7:0] inst;


wire       addr_reg_wr_en;
wire       branch_en;
wire       data_mem_rd_en;
wire       use_imm;
wire       ALU_op_pre;

wire [7:0] data_mem_rd_data;
wire [2:0] ALU_op;

wire [7:0] addr_reg;


wire [7:0] ALU_opB;
wire [7:0] ALU_result;

wire [7:0] addr_reg_in;

assign data_mem_wr_data = rsA_data;
assign data_mem_wr_addr = rsB_data;


Registers 
registers_inst(
  .clk      (clk),
  .rst_n    (rst_n),
  
  .rsA_addr (inst[1:0]),
  .rsB_addr (inst[3:2]),
  .rsA_data (rsA_data),
  .rsB_data (rsB_data),

  .wr_en    (regs_wr_en),
  .wr_addr  (inst[1:0]),
  .wr_data  (regs_wr_data)
);

ProgramCounter
program_counter_inst(
  .clk           (clk),
  .rst_n         (rst_n),
  .next_inst_in  (pc_in),
  .next_inst_out (pc_out)
);

PCALU
pcalu_inst(
  .PC       (pc_out),
  .PCALU_a1 (pc_a1)
);

AddrReg
addrreg_inst(
  .clk        (clk),
  .rst_n      (rst_n),
  .write      (addr_reg_wr_en),
  .write_data (addr_reg_in),
  .addr_reg   (addr_reg)
);

InstructionMemory
instructionmemory_inst(
  .clk      (clk),
  .readAddr (pc_out),
  .inst     (inst)
);

Control 
control_inst(
  .inst_input     (inst),
  .reg_file_wr_en (regs_wr_en),
  .data_mem_wr_en (data_mem_wr_en),
  .addr_reg_wr_en (addr_reg_wr_en),
  .branch_en      (branch_en),
  .data_mem_rd    (data_mem_rd_en),
  .use_imm        (use_imm),
  .ALU_op_pre     (ALU_op_pre)
);

DataMemory
datamemory_inst(
  .clk        (clk),
  .wr_en      (data_mem_wr_en),
  .addr       (rsB_data),
  .write_data (rsA_data),
  .read_data  (data_mem_rd_data)
);

ALUOp
aluop_inst(
  .ALU_op_pre (ALU_op_pre),
  .inst_oprtr (inst[6:4]),
  .ALU_op     (ALU_op)
);

ALU
alu_inst(
  .opA    (rsA_data),
  .opB    (ALU_opB),
  .ALU_op (ALU_op),
  .result (ALU_result)
);

MUX21
mux_aluop_inst(
  .data_0   (rsB_data),
  .data_1   ({4'b0000, inst[5:2]}),
  .select   (use_imm),
  .data_out (ALU_opB)
);

MUX21
mux_addr_inst(
  .data_0   (pc_a1),
  .data_1   (addr_reg),
  .select   (branch_en & ALU_result[0]),
  .data_out (pc_in)
);

MUX21
mux_writeback_inst(
  .data_0   (ALU_result),
  .data_1   (data_mem_rd_data),
  .select   (data_mem_rd_en),
  .data_out (regs_wr_data)
);

MUX21
mux_addrreg_inst(
  .data_0   (rsA_data),
  .data_1   (pc_a1),
  .select   (inst[2]),
  .data_out (addr_reg_in)
);


endmodule