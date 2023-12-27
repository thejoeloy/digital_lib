`timescale 1ns / 1ps
`include "defines.v"

module control_unit_tb;

    // Inputs
    reg clk;
    reg r;
    reg [6:0] op_code;

    // Outputs
    wire pc_write_cond;
    wire [1:0] pc_source;
    wire pc_write;
    wire [1:0] alu_op;
    wire i_or_d;
    wire [1:0] alu_srcB;
    wire mem_read;
    wire alu_srcA;
    wire mem_write;
    wire mem_2_reg;
    wire reg_write;
    wire ir_write;

    // Instantiate the Unit Under Test (UUT)
    control_unit uut (
        .clk(clk), 
        .r(r), 
        .op_code(op_code), 
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

    // Clock generation
    initial begin
        clk = 1;
        forever #5 clk = ~clk; // Generate a clock with a period of 20ns
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        r = 1;
        op_code = 0;

        // Wait for the reset
        #5;
        r = 0;

        // Add different scenarios here
        // Example: Test a specific operation code
        #5; 
        op_code = `op_b; // Replace with a specific operation code

        // Additional test cases go here
        #20
        op_code = `op_r;
        
        #40
        op_code = `op_l;
        
        #50
        op_code = `op_s;
        // Finish simulation
        #100;
        $finish;
    end

endmodule