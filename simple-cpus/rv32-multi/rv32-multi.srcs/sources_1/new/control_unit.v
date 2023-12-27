`timescale 1ns / 1ps
`include "defines.v"

// FSM on page 381 of HP1 

module control_unit(
    input clk,
    input r,
    input [6:0] op_code,
	output reg pc_write_cond,
	output reg [1:0] pc_source,
	output reg pc_write,
	output reg [1:0] alu_op,
	output reg i_or_d,
	output reg [1:0] alu_srcB,
	output reg mem_read,
	output reg alu_srcA,
	output reg mem_write,
	output reg mem_2_reg,
	output reg reg_write,
	output reg ir_write
);

    reg [4:0] state;
    localparam INSTR_FETCH = 0;
    localparam INSTR_DEC = 1;
    localparam MEM_ADDR_COMP = 2;
    localparam MEM_ACCESS1 = 3;
    localparam MEM_READ_COMP = 4;
    localparam MEM_ACCESS2 = 5;
    localparam EXEC = 6;
    localparam R_COMPLETE = 7;
    localparam B_COMPLETE = 8;
    
    always @(posedge clk) begin
        if (r) begin
            state <= INSTR_FETCH;
            mem_read <= 1;
            mem_write <= 0;
            mem_2_reg <= 0;
            reg_write <= 0;
            alu_srcA <= 0;
            i_or_d <= 0;
            ir_write <= 1;
            alu_srcB <= 2'b01;
            alu_op <= 2'b00;
            pc_write <= 1;
            pc_source <= 0;
            pc_write_cond <= 0;
        end
        else begin
            case(state)
                INSTR_FETCH : begin
                    state <= INSTR_DEC;
                    alu_srcA <= 0;
                    alu_srcB <= 2'b10;
                    alu_op <= 2'b00;
                    mem_read <= 0;
                    pc_write <= 0;
                    ir_write <= 0;
                end
                INSTR_DEC : begin
                    state <= ((op_code == `op_l || op_code == `op_s) && !r) ? MEM_ADDR_COMP :
                             (op_code == `op_r && !r) ? EXEC :
                             (op_code == `op_b && !r) ? B_COMPLETE : 0;
                    
                    alu_srcA <= (!r) ? 1 : 0;
                    
                    alu_srcB <= ((op_code == `op_l || op_code == `op_s) && !r) ? 2'b10 :
                             ((op_code == `op_r || op_code == `op_b) && !r) ? 2'b00 : 0;
                    
                    alu_op <= ((op_code == `op_l || op_code == `op_s) && !r) ? 2'b00 :
                             (op_code == `op_r && !r) ? 2'b10 :
                             (op_code == `op_b && !r) ? 2'b01 : 0;
                             
                    pc_write_cond <= (op_code == `op_b && !r) ? 1 : 0;
                    pc_source <= (op_code == `op_b && !r) ? 1 : 0;
                end
                MEM_ADDR_COMP : begin
                    state <= (op_code == `op_l && !r) ? MEM_ACCESS1 :
                             (op_code == `op_s && !r) ? MEM_ACCESS2 : 0;
                             
                    mem_read <= (op_code == `op_l && !r) ? 1 : 0;
                    mem_write <= (op_code == `op_s && !r) ? 1 : 0;
                    i_or_d <= 1;
                     
                end
                MEM_ACCESS1 : begin
                    state <= MEM_READ_COMP;
                    reg_write <= 1;
                    mem_2_reg <= 1;
                end
                MEM_READ_COMP : begin
                    state <= INSTR_FETCH;
                    mem_read <= 1;
                    mem_write <= 0;
                    mem_2_reg <= 0;
                    reg_write <= 0;
                    alu_srcA <= 0;
                    i_or_d <= 0;
                    ir_write <= 1;
                    alu_srcB <= 2'b01;
                    alu_op <= 2'b00;
                    pc_write <= 1;
                    pc_source <= 0;
                    pc_write_cond <= 0;
                end
                MEM_ACCESS2 : begin
                    state <= INSTR_FETCH;
                    mem_read <= 1;
                    mem_write <= 0;
                    mem_2_reg <= 0;
                    reg_write <= 0;
                    alu_srcA <= 0;
                    i_or_d <= 0;
                    ir_write <= 1;
                    alu_srcB <= 2'b01;
                    alu_op <= 2'b00;
                    pc_write <= 1;
                    pc_source <= 0;
                    pc_write_cond <= 0;
                end
                EXEC : begin
                    state <= R_COMPLETE;
                    reg_write <= 1;
                    mem_2_reg <= 0;
                end
                R_COMPLETE : begin
                    state <= INSTR_FETCH;
                    mem_read <= 1;
                    mem_write <= 0;
                    mem_2_reg <= 0;
                    reg_write <= 0;
                    alu_srcA <= 0;
                    i_or_d <= 0;
                    ir_write <= 1;
                    alu_srcB <= 2'b01;
                    alu_op <= 2'b00;
                    pc_write <= 1;
                    pc_source <= 0;
                    pc_write_cond <= 0;
                end
                B_COMPLETE : begin
                    state <= INSTR_FETCH;
                    mem_read <= 1;
                    mem_write <= 0;
                    mem_2_reg <= 0;
                    reg_write <= 0;
                    alu_srcA <= 0;
                    i_or_d <= 0;
                    ir_write <= 1;
                    alu_srcB <= 2'b01;
                    alu_op <= 2'b00;
                    pc_write <= 1;
                    pc_source <= 0;
                    pc_write_cond <= 0;
                end
                default : begin
                    state <= INSTR_FETCH;
                    mem_read <= 1;
                    mem_write <= 0;
                    mem_2_reg <= 0;
                    reg_write <= 0;
                    alu_srcA <= 0;
                    i_or_d <= 0;
                    ir_write <= 1;
                    alu_srcB <= 2'b01;
                    alu_op <= 2'b00;
                    pc_write <= 1;
                    pc_source <= 0;
                    pc_write_cond <= 0;
                end
            endcase
        end    
    end

    

endmodule 