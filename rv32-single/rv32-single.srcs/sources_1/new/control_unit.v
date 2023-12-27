`timescale 1ns / 1ps
`include "defines.v"

// Truth table on page 362 (281 in actual book) of pdf of HP1 

module control_unit(
    input wire r,
    input wire [6:0] op_code,
    output wire mem_read,
    output wire mem_2_reg,
    output wire mem_write,
    output wire alu_src,
    output wire [1:0] alu_op,
    output wire reg_write,
    output wire branch
);

    assign mem_read = (op_code == `op_l && !r) ? 1'b1 : 1'b0;
    
    assign mem_2_reg = (op_code == `op_l && !r) ? 1'b1 : 1'b0;	
    
    assign mem_write = (op_code == `op_s && !r) ? 1'b1 : 1'b0;	
    
    assign alu_src = ((op_code == `op_s || op_code == `op_l) && !r) ? 1'b1 : 1'b0;	
    
    assign alu_op = (op_code == `op_r && !r) ? 2'b10 : 
                    (op_code == `op_b && !r) ? 2'b01 : 2'b00;	
    
    assign reg_write = ((op_code == `op_r || op_code == `op_l) && !r) ? 1'b1 : 1'b0;	
	     
    assign branch = (op_code == `op_b && !r) ? 1'b1 : 1'b0;
    	               
endmodule