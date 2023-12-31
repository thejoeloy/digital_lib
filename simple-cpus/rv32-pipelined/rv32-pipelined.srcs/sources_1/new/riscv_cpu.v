`timescale 1ns / 1ps
`include "defines.v"

// Final block diagram on page 434 HP1
// 4.53 on page 415 contains  ALUsrc mux
// 4.59 on page 418 contains  missing mux controls
module riscv_cpu(
    input clk,
    input r
);

// IF Stage ----------------------------------------------------------
reg [31:0] PC; 
wire [31:0] instr;
wire pc_src, if_flush, stall, branch;
wire [31:0] read_data1, read_data2;
wire signed [31:0] read_data1_signed = read_data1;
wire signed [31:0] read_data2_signed = read_data2;
wire [31:0] imm_sext;
wire [31:0] IFID_instr_o;
wire [31:0] IFID_pc_o;

assign pc_src = ((branch && IFID_instr_o[14:12] == `f3_beq && read_data1_signed == read_data2_signed) ||
                 (branch && IFID_instr_o[14:12] == `f3_bne && read_data1_signed != read_data2_signed) ||
                 (branch && IFID_instr_o[14:12] == `f3_blt && read_data1_signed < read_data2_signed) ||
                 (branch && IFID_instr_o[14:12] == `f3_bge && read_data1_signed >= read_data2_signed) ||
                 (branch && IFID_instr_o[14:12] == `f3_bltu && read_data1 < read_data2) ||
                 (branch && IFID_instr_o[14:12] == `f3_bgeu && read_data1 >= read_data2)) ? 1'b1 : 1'b0;			 

always @(posedge clk) begin
    if (r) begin
        PC <= 0;    
    end
    else begin
        PC <= (pc_src) ? IFID_pc_o + imm_sext : (stall) ? PC : PC + 1;
    end
end

instruction_memory im1 (
	.r(r),
	.read_addr(PC),
	.instr(instr)
	//.i_mem_addr(i_mem_addr),
	//.i_mem_data(i_mem_data),
	//.i_mem_write(i_mem_write)
);

assign if_flush = (pc_src) ? 1'b1 : 1'b0;
IFID_pipe p1(
    .clk(clk),
    .r(r),
    //Inputs
    .stall(stall),
    .if_flush(if_flush),
    .IFID_instr_i(instr),
    .IFID_pc_i(PC),
    // Outputs
    .IFID_instr_o(IFID_instr_o),
    .IFID_pc_o(IFID_pc_o)
);

// ID Stage ----------------------------------------------------------

wire mem_read, mem_2_reg, mem_write, alu_src, reg_write;
wire [1:0] alu_op;
control_unit cu1(
    .r(r),
    .instr(IFID_instr_o[6:0]),
    .stall(stall),
    .mem_read(mem_read),
    .mem_2_reg(mem_2_reg),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .alu_op(alu_op), 
    .reg_write(reg_write),
    .branch(branch)  
);

wire IDEX_mem_read_o;
wire [4:0] IDEX_rd_o;
wire [4:0] IDEX_rs1_o, IDEX_rs2_o;
hazard_unit hu1(
    .r(r),
    .IDEX_mem_read(IDEX_mem_read_o),
    .IDEX_rd(IDEX_rd_o),
    .IFID_rs1(IFID_instr_o[19:15]),
    .IFID_rs2(IFID_instr_o[24:20]),
    .stall(stall)
);

immediate_generator ig1(
    .r(r),
    .instruction(IFID_instr_o),
    .imm_sext(imm_sext)
);

wire [31:0] write_data;
wire [4:0] MEMWB_rd_o;
wire MEMWB_reg_write_o;
register_file rf1(
    .clk(clk),
    .r(r),
    .rs1(IFID_instr_o[19:15]), 
    .rs2(IFID_instr_o[24:20]), 
    .write_addr(MEMWB_rd_o),
    .write_enable(MEMWB_reg_write_o),
    .write_data(write_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

wire [31:0] IDEX_imm_sext_o;
wire [31:0] IDEX_read_data1_o, IDEX_read_data2_o;
wire IDEX_reg_write_o, IDEX_mem_2_reg_o, IDEX_mem_write_o,
     IDEX_alu_src_o;
wire [1:0] IDEX_alu_op_o;
wire [9:0] IDEX_func_code_o;
IDEX_pipe p2(
    .clk(clk),          // Clock signal
    .r(r),            // Reset signal
    // Inputs
    .IDEX_rs1_i(IFID_instr_o[19:15]),   // IDEX RS1 input
    .IDEX_rs2_i(IFID_instr_o[24:20]),   // IDEX RS2 input
    .IDEX_rd_i(IFID_instr_o[11:7]),    // IDEX RD input
    .IDEX_imm_sext_i(imm_sext),  // IDEX immediate sign-extended input
    .IDEX_read_data1_i(read_data1), // IDEX read data 1 input
    .IDEX_read_data2_i(read_data2), // IDEX read data 2 input
    .IDEX_reg_write_i(reg_write),  // IDEX register write input
    .IDEX_mem_2_reg_i(mem_2_reg),  // IDEX memory to register input
    .IDEX_mem_read_i(mem_read),   // IDEX memory read input
    .IDEX_mem_write_i(mem_write),  // IDEX memory write input
    .IDEX_alu_src_i(alu_src),    // IDEX ALU source input
    .IDEX_alu_op_i(alu_op), // IDEX ALU opcode input
    .IDEX_func_code_i({IFID_instr_o[31:25], IFID_instr_o[14:12]}), // {f7, f3} 
    // Outputs
    .IDEX_rs1_o(IDEX_rs1_o), 
    .IDEX_rs2_o(IDEX_rs2_o), 
    .IDEX_rd_o(IDEX_rd_o),  
    .IDEX_imm_sext_o(IDEX_imm_sext_o), 
    .IDEX_read_data1_o(IDEX_read_data1_o), 
    .IDEX_read_data2_o(IDEX_read_data2_o), 
    .IDEX_reg_write_o(IDEX_reg_write_o), 
    .IDEX_mem_2_reg_o(IDEX_mem_2_reg_o), 
    .IDEX_mem_read_o(IDEX_mem_read_o), 
    .IDEX_mem_write_o(IDEX_mem_write_o), 
    .IDEX_alu_src_o(IDEX_alu_src_o), 
    .IDEX_alu_op_o(IDEX_alu_op_o),
    .IDEX_func_code_o(IDEX_func_code_o)
);

// EX Stage ----------------------------------------------------------

wire EXMEM_reg_write_o, EXMEM_mem_2_reg_o;
wire [4:0] EXMEM_rd_o;
wire [1:0] forwardA, forwardB;
forward_unit f1(
    .r(r),
    .EXMEM_reg_write(EXMEM_reg_write_o),
    .MEMWB_reg_write(MEMWB_reg_write_o),
    .IDEX_rs1(IDEX_rs1_o),
    .IDEX_rs2(IDEX_rs2_o),
    .EXMEM_rd(EXMEM_rd_o),
    .MEMWB_rd(MEMWB_rd_o),
    .forwardA(forwardA),
    .forwardB(forwardB)
);

wire [3:0] operation;
alu_control ac1(
    .r(r),
    .alu_op(IDEX_alu_op_o),
    .func_code(IDEX_func_code_o), //{f7, f3}
    .operation(operation)
);

wire [31:0] alu_in1, alu_in2, alu_in2_partial, alu_result, EXMEM_alu_result_o;
assign alu_in1 = (forwardA == 2'b00) ? IDEX_read_data1_o :
	                 (forwardA == 2'b10) ? EXMEM_alu_result_o : 
	                 (forwardA == 2'b01) ? write_data : 0;
	                 
assign alu_in2_partial = (forwardB == 2'b00) ? IDEX_read_data2_o :
	                 (forwardB == 2'b10) ? EXMEM_alu_result_o : 
	                 (forwardB == 2'b01) ? write_data : 0;

assign alu_in2 = (IDEX_alu_src_o) ? IDEX_imm_sext_o : alu_in2_partial;

alu alu1(
    .r(r),
    .alu_op(operation),
	.alu_in1(alu_in1),
	.alu_in2(alu_in2),
	.alu_result(alu_result)
);

wire EXMEM_mem_read_o, EXMEM_mem_write_o;
wire [31:0] EXMEM_alu_in2_o;
EXMEM_pipe p3(
    .clk(clk),
    .r(r),
    .EXMEM_alu_result_i(alu_result),
    .EXMEM_alu_in2_i(alu_in2_partial),
    .EXMEM_rd_i(IDEX_rd_o),
    .EXMEM_reg_write_i(IDEX_reg_write_o),
    .EXMEM_mem_2_reg_i(IDEX_mem_2_reg_o),
    .EXMEM_mem_read_i(IDEX_mem_read_o),
    .EXMEM_mem_write_i(IDEX_mem_write_o),
    .EXMEM_alu_result_o(EXMEM_alu_result_o),
    .EXMEM_alu_in2_o(EXMEM_alu_in2_o),
    .EXMEM_rd_o(EXMEM_rd_o),
    .EXMEM_reg_write_o(EXMEM_reg_write_o),
    .EXMEM_mem_2_reg_o(EXMEM_mem_2_reg_o),
    .EXMEM_mem_read_o(EXMEM_mem_read_o),
    .EXMEM_mem_write_o(EXMEM_mem_write_o)
);

// MEM Stage ----------------------------------------------------------
wire [31:0] read_data;
data_memory dm1(
	//.clk(clk),
	.r(r),
	.address(EXMEM_alu_result_o),
	.write_en(EXMEM_mem_write_o),
	.read_en(EXMEM_mem_read_o),
	.write_data(EXMEM_alu_in2_o),
	.read_data(read_data)
);

wire MEMWB_mem_2_reg_o;
wire [31:0] MEMWB_alu_result_o, MEMWB_read_data_o;
MEMWB_pipe p4(
    .clk(clk),
    .r(r),
    .MEMWB_reg_write_i(EXMEM_reg_write_o),
    .MEMWB_mem_2_reg_i(EXMEM_mem_2_reg_o),
    .MEMWB_rd_i(EXMEM_rd_o),
    .MEMWB_alu_result_i(EXMEM_alu_result_o),
    .MEMWB_read_data_i(read_data),
    .MEMWB_reg_write_o(MEMWB_reg_write_o),
    .MEMWB_mem_2_reg_o(MEMWB_mem_2_reg_o),
    .MEMWB_rd_o(MEMWB_rd_o),
    .MEMWB_alu_result_o(MEMWB_alu_result_o),
    .MEMWB_read_data_o(MEMWB_read_data_o)
);

// WB Stage ----------------------------------------------------------

assign write_data = (MEMWB_mem_2_reg_o) ? MEMWB_read_data_o : MEMWB_alu_result_o;
                       
endmodule

/*
`timescale 1ns / 1ps
`include "defines.v"

// Final block diagram on page 434 HP1
// 4.53 on page 415 contains  ALUsrc mux
// 4.59 on page 418 contains  missing mux controls
(* keep = "true" *) module riscv_cpu(
    input clk,
    input r
);

// IF Stage ----------------------------------------------------------
(* keep = "true" *) reg [31:0] PC; 
(* keep = "true" *) wire [31:0] instr;
(* keep = "true" *) wire pc_src, if_flush, stall, branch;
(* keep = "true" *) wire [31:0] read_data1, read_data2;
(* keep = "true" *) wire signed [31:0] read_data1_signed = read_data1;
(* keep = "true" *) wire signed [31:0] read_data2_signed = read_data2;
(* keep = "true" *) wire [31:0] imm_sext;
(* keep = "true" *) wire [31:0] IFID_instr_o;
(* keep = "true" *) wire [31:0] IFID_pc_o;

assign pc_src = ((branch && IFID_instr_o[14:12] == `f3_beq && read_data1_signed == read_data2_signed) ||
                 (branch && IFID_instr_o[14:12] == `f3_bne && read_data1_signed != read_data2_signed) ||
                 (branch && IFID_instr_o[14:12] == `f3_blt && read_data1_signed < read_data2_signed) ||
                 (branch && IFID_instr_o[14:12] == `f3_bge && read_data1_signed >= read_data2_signed) ||
                 (branch && IFID_instr_o[14:12] == `f3_bltu && read_data1 < read_data2) ||
                 (branch && IFID_instr_o[14:12] == `f3_bgeu && read_data1 >= read_data2)) ? 1'b1 : 1'b0;			 

(* keep = "true" *) always @(posedge clk) begin
    if (r) begin
        PC <= 0;    
    end
    else begin
        PC <= (pc_src) ? IFID_pc_o + imm_sext : (stall) ? PC : PC + 1;
    end
end

(* keep = "true" *) instruction_memory im1 (
	.r(r),
	.read_addr(PC),
	.instr(instr)
	//.i_mem_addr(i_mem_addr),
	//.i_mem_data(i_mem_data),
	//.i_mem_write(i_mem_write)
);

assign if_flush = (pc_src) ? 1'b1 : 1'b0;
(* keep = "true" *) IFID_pipe p1(
    .clk(clk),
    .r(r),
    //Inputs
    .stall(stall),
    .if_flush(if_flush),
    .IFID_instr_i(instr),
    .IFID_pc_i(PC),
    // Outputs
    .IFID_instr_o(IFID_instr_o),
    .IFID_pc_o(IFID_pc_o)
);

// ID Stage ----------------------------------------------------------

(* keep = "true" *) wire mem_read, mem_2_reg, mem_write, alu_src, reg_write;
(* keep = "true" *) wire [1:0] alu_op;
(* keep = "true" *) control_unit cu1(
    .r(r),
    .instr(IFID_instr_o[6:0]),
    .stall(stall),
    .mem_read(mem_read),
    .mem_2_reg(mem_2_reg),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .alu_op(alu_op), 
    .reg_write(reg_write),
    .branch(branch)  
);

(* keep = "true" *) wire IDEX_mem_read_o;
(* keep = "true" *) wire [4:0] IDEX_rd_o;
(* keep = "true" *) wire [4:0] IDEX_rs1_o, IDEX_rs2_o;
(* keep = "true" *) hazard_unit hu1(
    .r(r),
    .IDEX_mem_read(IDEX_mem_read_o),
    .IDEX_rd(IDEX_rd_o),
    .IFID_rs1(IFID_instr_o[19:15]),
    .IFID_rs2(IFID_instr_o[24:20]),
    .stall(stall)
);

(* keep = "true" *) immediate_generator ig1(
    .r(r),
    .instruction(IFID_instr_o),
    .imm_sext(imm_sext)
);

(* keep = "true" *) wire [31:0] write_data;
(* keep = "true" *) wire [4:0] MEMWB_rd_o;
(* keep = "true" *) wire MEMWB_reg_write_o;
(* keep = "true" *) register_file rf1(
    .clk(clk),
    .r(r),
    .rs1(IFID_instr_o[19:15]), 
    .rs2(IFID_instr_o[24:20]), 
    .write_addr(MEMWB_rd_o),
    .write_enable(MEMWB_reg_write_o),
    .write_data(write_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

(* keep = "true" *) wire [31:0] IDEX_imm_sext_o;
(* keep = "true" *) wire [31:0] IDEX_read_data1_o, IDEX_read_data2_o;
(* keep = "true" *) wire IDEX_reg_write_o, IDEX_mem_2_reg_o, IDEX_mem_write_o,
     IDEX_alu_src_o;
(* keep = "true" *) wire [1:0] IDEX_alu_op_o;
(* keep = "true" *) wire [9:0] IDEX_func_code_o;
(* keep = "true" *) IDEX_pipe p2(
    .clk(clk),          // Clock signal
    .r(r),            // Reset signal
    // Inputs
    .IDEX_rs1_i(IFID_instr_o[19:15]),   // IDEX RS1 input
    .IDEX_rs2_i(IFID_instr_o[24:20]),   // IDEX RS2 input
    .IDEX_rd_i(IFID_instr_o[11:7]),    // IDEX RD input
    .IDEX_imm_sext_i(imm_sext),  // IDEX immediate sign-extended input
    .IDEX_read_data1_i(read_data1), // IDEX read data 1 input
    .IDEX_read_data2_i(read_data2), // IDEX read data 2 input
    .IDEX_reg_write_i(reg_write),  // IDEX register write input
    .IDEX_mem_2_reg_i(mem_2_reg),  // IDEX memory to register input
    .IDEX_mem_read_i(mem_read),   // IDEX memory read input
    .IDEX_mem_write_i(mem_write),  // IDEX memory write input
    .IDEX_alu_src_i(alu_src),    // IDEX ALU source input
    .IDEX_alu_op_i(alu_op), // IDEX ALU opcode input
    .IDEX_func_code_i({IFID_instr_o[31:25], IFID_instr_o[14:12]}), // {f7, f3} 
    // Outputs
    .IDEX_rs1_o(IDEX_rs1_o), 
    .IDEX_rs2_o(IDEX_rs2_o), 
    .IDEX_rd_o(IDEX_rd_o),  
    .IDEX_imm_sext_o(IDEX_imm_sext_o), 
    .IDEX_read_data1_o(IDEX_read_data1_o), 
    .IDEX_read_data2_o(IDEX_read_data2_o), 
    .IDEX_reg_write_o(IDEX_reg_write_o), 
    .IDEX_mem_2_reg_o(IDEX_mem_2_reg_o), 
    .IDEX_mem_read_o(IDEX_mem_read_o), 
    .IDEX_mem_write_o(IDEX_mem_write_o), 
    .IDEX_alu_src_o(IDEX_alu_src_o), 
    .IDEX_alu_op_o(IDEX_alu_op_o),
    .IDEX_func_code_o(IDEX_func_code_o)
);

// EX Stage ----------------------------------------------------------

(* keep = "true" *) wire EXMEM_reg_write_o, EXMEM_mem_2_reg_o;
(* keep = "true" *) wire [4:0] EXMEM_rd_o;
(* keep = "true" *) wire [1:0] forwardA, forwardB;
(* keep = "true" *) forward_unit f1(
    .r(r),
    .EXMEM_reg_write(EXMEM_reg_write_o),
    .MEMWB_reg_write(MEMWB_reg_write_o),
    .IDEX_rs1(IDEX_rs1_o),
    .IDEX_rs2(IDEX_rs2_o),
    .EXMEM_rd(EXMEM_rd_o),
    .MEMWB_rd(MEMWB_rd_o),
    .forwardA(forwardA),
    .forwardB(forwardB)
);

(* keep = "true" *) wire [3:0] operation;
(* keep = "true" *) alu_control ac1(
    .r(r),
    .alu_op(IDEX_alu_op_o),
    .func_code(IDEX_func_code_o), //{f7, f3}
    .operation(operation)
);

(* keep = "true" *) wire [31:0] alu_in1, alu_in2, alu_in2_partial, alu_result, EXMEM_alu_result_o;
assign alu_in1 = (forwardA == 2'b00) ? IDEX_read_data1_o :
	                 (forwardA == 2'b10) ? EXMEM_alu_result_o : 
	                 (forwardA == 2'b01) ? write_data : 0;
	                 
assign alu_in2_partial = (forwardB == 2'b00) ? IDEX_read_data2_o :
	                 (forwardB == 2'b10) ? EXMEM_alu_result_o : 
	                 (forwardB == 2'b01) ? write_data : 0;

assign alu_in2 = (IDEX_alu_src_o) ? IDEX_imm_sext_o : alu_in2_partial;

(* keep = "true" *) alu alu1(
    .r(r),
    .alu_op(operation),
	.alu_in1(alu_in1),
	.alu_in2(alu_in2),
	.alu_result(alu_result)
);

(* keep = "true" *) wire EXMEM_mem_read_o, EXMEM_mem_write_o;
(* keep = "true" *) wire [31:0] EXMEM_alu_in2_o;
(* keep = "true" *) EXMEM_pipe p3(
    .clk(clk),
    .r(r),
    .EXMEM_alu_result_i(alu_result),
    .EXMEM_alu_in2_i(alu_in2_partial),
    .EXMEM_rd_i(IDEX_rd_o),
    .EXMEM_reg_write_i(IDEX_reg_write_o),
    .EXMEM_mem_2_reg_i(IDEX_mem_2_reg_o),
    .EXMEM_mem_read_i(IDEX_mem_read_o),
    .EXMEM_mem_write_i(IDEX_mem_write_o),
    .EXMEM_alu_result_o(EXMEM_alu_result_o),
    .EXMEM_alu_in2_o(EXMEM_alu_in2_o),
    .EXMEM_rd_o(EXMEM_rd_o),
    .EXMEM_reg_write_o(EXMEM_reg_write_o),
    .EXMEM_mem_2_reg_o(EXMEM_mem_2_reg_o),
    .EXMEM_mem_read_o(EXMEM_mem_read_o),
    .EXMEM_mem_write_o(EXMEM_mem_write_o)
);

// MEM Stage ----------------------------------------------------------
(* keep = "true" *) wire [31:0] read_data;
(* keep = "true" *) data_memory dm1(
	//.clk(clk),
	.r(r),
	.address(EXMEM_alu_result_o),
	.write_en(EXMEM_mem_write_o),
	.read_en(EXMEM_mem_read_o),
	.write_data(EXMEM_alu_in2_o),
	.read_data(read_data)
);

(* keep = "true" *) wire MEMWB_mem_2_reg_o;
(* keep = "true" *) wire [31:0] MEMWB_alu_result_o, MEMWB_read_data_o;
(* keep = "true" *) MEMWB_pipe p4(
    .clk(clk),
    .r(r),
    .MEMWB_reg_write_i(EXMEM_reg_write_o),
    .MEMWB_mem_2_reg_i(EXMEM_mem_2_reg_o),
    .MEMWB_rd_i(EXMEM_rd_o),
    .MEMWB_alu_result_i(EXMEM_alu_result_o),
    .MEMWB_read_data_i(read_data),
    .MEMWB_reg_write_o(MEMWB_reg_write_o),
    .MEMWB_mem_2_reg_o(MEMWB_mem_2_reg_o),
    .MEMWB_rd_o(MEMWB_rd_o),
    .MEMWB_alu_result_o(MEMWB_alu_result_o),
    .MEMWB_read_data_o(MEMWB_read_data_o)
);

// WB Stage ----------------------------------------------------------

assign write_data = (MEMWB_mem_2_reg_o) ? MEMWB_read_data_o : MEMWB_alu_result_o;
                       
endmodule
*/