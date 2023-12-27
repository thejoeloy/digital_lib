`timescale 1ns / 1ps

module riscv_cpu(
    input clk,
    input r,
    input [31:0] i_mem_addr,
	input [31:0] i_mem_data,
	input i_mem_write
);

wire [31:0] instr, imm_sext;
reg [31:0] PC;
wire branch, zero;
always @(posedge clk) begin
    if (r) begin
        PC <= 0;
    end
    else begin
        PC <= (branch && zero) ? PC + imm_sext : PC + 1;
    end
end

instruction_memory im1(
	.r(r),
	.read_addr(PC),
	.instr(instr),
	.i_mem_addr(i_mem_addr),
	.i_mem_data(i_mem_data),
	.i_mem_write(i_mem_write)
);

wire mem_read, mem_2_reg, mem_write, alu_src, reg_write;
wire [1:0] alu_op;
control_unit cu1(
    .r(r),
    .op_code(instr[6:0]),
    .mem_read(mem_read),
    .mem_2_reg(mem_2_reg),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .alu_op(alu_op),
    .reg_write(reg_write),
    .branch(branch)
);

wire [31:0] read_data1, read_data2, write_data;
register_file rf1(
    .r(r),
    .rs1(instr[19:15]), 
    .rs2(instr[24:20]), 
    .write_addr(instr[11:7]),
    .write_enable(reg_write),
    .write_data(write_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

immediate_generator ig1(
    .r(r),
    .instruction(instr),
    .imm_sext(imm_sext)
);

wire [3:0] operation;
alu_control ac1(
    .r(r),
    .alu_op(alu_op),
    .func_code({instr[31:25], instr[14:12]}), //{f7, f3}
    .operation(operation)
);

wire [31:0] alu_in1, alu_in2, alu_result;
assign alu_in1 = read_data1;
assign alu_in2 = (alu_src) ? imm_sext : read_data2;
alu alu1(
    .r(r),
	.alu_op(operation),
	.alu_in1(alu_in1),
	.alu_in2(alu_in2),
	.zero(zero),
	.alu_result(alu_result)
);

wire [31:0] read_data;
data_memory dm1(
	.r(r),
	.address(alu_result),
	.write_en(mem_write),
	.read_en(mem_read),
	.write_data(read_data2),
	.read_data(read_data)
);
    
assign write_data = (mem_2_reg) ? read_data : alu_result;
   
endmodule
