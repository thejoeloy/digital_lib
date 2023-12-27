`timescale 1ns / 1ps
// Block diagram on page 368 of pdf of HP 1
module riscv_cpu(
    input clk,
    input r,
    input [31:0] i_mem_addr,
	input [31:0] i_mem_data,
	input i_mem_write
);

reg [31:0] PC, alu_out;
wire zero, pc_write, pc_write_cond;
wire [1:0] pc_source;
wire [31:0] alu_result, target, imm_sext;
assign target = (pc_source == 2'b10) ? imm_sext : 
                (pc_source == 2'b01) ? alu_out : alu_result;
always @(posedge clk) begin
    if (r) begin
        PC <= 0;
    end
    else begin
        if ((pc_write_cond && zero) || pc_write) begin
            PC <= target;
        end
        else begin
            PC <= PC;
        end
    end
end

reg [31:0] B;
wire [31:0] mem_data;
wire [31:0] address;
wire i_or_d, mem_read, mem_write;
assign address = (i_or_d) ? alu_out : PC;
memory m1(
    .r(r),
    .address(address),
    .write_data(B),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_data(mem_data)
);

reg [31:0] instr_o;
wire ir_write;
always @(posedge clk) begin
    if (r) begin
        instr_o <= 0;
    end
    else begin
        if (ir_write) begin
            instr_o <= mem_data;
        end
    end
end

reg [31:0] mem_data_o;
always @(posedge clk) begin
    if (r) begin
        mem_data_o <= 0;
    end
    else begin
        mem_data_o <= mem_data;
    end
end

wire alu_srcA, mem_2_reg, reg_write;
wire [1:0] alu_srcB, alu_op;
control_unit cu1(
    .clk(clk),
    .r(r),
    .op_code(instr_o),
	.pc_write_cond(pc_write_cond),
	.pc_source(pc_source),
	.pc_write(pc_write),
	.alu_op(alu_op),
	.i_or_d(i_or_d),
	.alu_srcB(alu_srcB),
	.mem_read(mem_read),
	.alu_srcA(alu_srcA),
	.mem_write(mem_write),
	.mem_2_reg(mem_2_reg),
	.reg_write(reg_write),
	.ir_write(ir_write)
);

wire [31:0] read_data1, read_data2, write_data;
assign write_data = (mem_2_reg) ? mem_data_o : alu_out;
register_file rf1(
    .r(r),
    .rs1(instr_o[19:15]), 
    .rs2(instr_o[24:20]), 
    .write_addr(instr_o[11:7]),
    .write_enable(reg_write),
    .write_data(write_data),
    .read_data1(read_data1),
    .read_data2(read_data2)
);

immediate_generator ig1(
    .r(r),
    .instruction(instr_o),
    .imm_sext(imm_sext)
);

wire [3:0] operation;
alu_control ac1(
    .r(r),
    .alu_op(alu_op),
    .func_code({instr_o[31:25], instr_o[14:12]}), //{f7, f3}
    .operation(operation)
);

reg [31:0] A;
always @(posedge clk) begin
    if (r) begin
        A <= 0;
    end
    else begin
        A <= read_data1;
    end
end

always @(posedge clk) begin
    if (r) begin
        B <= 0;
    end
    else begin
        B <= read_data2;
    end
end

wire [31:0] alu_in1, alu_in2;
assign alu_in1 = (alu_srcA) ? A : PC;
assign alu_in2 = (alu_srcB == 2'b01) ? 1 : (alu_srcB == 2'b10) ? imm_sext : B;
alu alu1(
    .r(r),
	.alu_op(operation),
	.alu_in1(alu_in1),
	.alu_in2(alu_in2),
	.zero(zero),
	.alu_result(alu_result)
);

always @(posedge clk) begin
    if (r) begin
        alu_out <= 0;        
    end
    else begin
        alu_out <= alu_result;
    end
end


endmodule