`timescale 1ns / 1ps
`include "defines.v"

// page 413 HP1 contains truth table

module control_unit(
    input wire r,
    input wire [6:0] instr,
    input wire stall,
    output wire mem_read,
    output wire mem_2_reg,
    output wire mem_write,
    output wire alu_src,
    output wire [1:0] alu_op,
    output wire reg_write,
    output wire branch
    );
	
	assign mem_read = (instr == `op_l && !r && !stall) ? 1'b1 : 1'b0;
	
	assign mem_2_reg = (instr == `op_l && !r && !stall) ? 1'b1 : 1'b0;
	
	assign mem_write = (instr == `op_s && !r && !stall) ? 1'b1 : 1'b0;
	
	assign reg_write = ((instr == `op_l || instr == `op_r || instr == `op_i) &&
	                    !r && !stall) ? 1'b1 : 1'b0;
	                     
	assign branch = (instr == `op_b && !r && !stall) ? 1'b1 : 1'b0;
	
	assign alu_src = ((instr == `op_s || instr == `op_l || instr == `op_i) &&
	                  !r && !stall) ? 1'b1 : 1'b0;
	                  
    assign alu_op = ((instr == `op_r) && !r && !stall) ? 2'b10 :
                    ((instr == `op_b) && !r && !stall) ? 2'b01 : 2'b00; 
                    
endmodule