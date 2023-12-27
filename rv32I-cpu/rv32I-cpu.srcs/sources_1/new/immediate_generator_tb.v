`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2023 06:51:33 PM
// Design Name: 
// Module Name: immediate_generator_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module immediate_generator_tb();

    reg r;
    reg [31:0] instruction;
    wire [31:0] imm_sext;

    immediate_generator dut(
    .r(r),
    .instruction(IFID_instr_o),
    .imm_sext(imm_sext)
    );
    
    initial begin
        $monitor("At time %t", $time);
      	$dumpfile("riscv_cpu_tb.vcd");
      	$dumpvars(0, riscv_cpu_tb);
      	r = 1;
        instruction = 0;
        
        #10
        // B 
        instruction = 32'b0000_0000_0000_0000_0000_0000_0110_0011;
        
        #10
        // I 
        instruction = 32'b0000_0000_0000_0000_0000_0000_0001_0011;
        
        #10
        // S 
        instruction = 32'b0000_0000_0000_0000_0000_0000_0010_0011;
        
        #10
        // L
        instruction = 32'b0000_0000_0000_0000_0000_0000_0000_0011;
        
        #10
        // jal 
        instruction = 32'b0000_0000_0000_0000_0000_0000_0110_1111;
        
        #10
        // jalr
        instruction = 32'b0000_0000_0000_0000_0000_0000_0010_0011;
        
        #10
        // lui
        instruction = 32'b0000_0000_0000_0000_0000_0000_0011_0111;
        
        #10
        // auipc
        instruction = 32'b0000_0000_0000_0000_0000_0000_0001_0111; 
         
        $finish;     	
   end
    

endmodule
