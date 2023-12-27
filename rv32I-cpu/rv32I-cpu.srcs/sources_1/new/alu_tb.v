`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/26/2023 06:21:32 PM
// Design Name: 
// Module Name: alu_tb
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

module alu_tb();

   reg r;
   reg [6:0] op_code;
   reg [9:0] func_code;
   reg [31:0] alu_in1, alu_in2;
   wire alu_result; 
   
   alu dut(
       .r(r),
       .op_code(op_code),
       .func_code(func_code),
       .alu_in1(alu_in1),
       .alu_in2(alu_in2),
       .alu_result(alu_result)
   );
   
   initial begin
        $monitor("At time %t", $time);
      	$dumpfile("riscv_cpu_tb.vcd");
      	$dumpvars(0, riscv_cpu_tb);
      	r = 1;
      	op_code = 6'b0110111;
      	func_code = 0; // f3 , f7
      	alu_in1 = 0;
      	alu_in2 = 0;
      	
      	// lui
      	# 10
      	op_code = 6'b0110111;
      	func_code = 0;
      	alu_in2 = 32'hFFFFF_000;
      	
      	// aiupc
      	# 10
      	op_code = 6'b0010111;
      	func_code = 0;
      	alu_in1 = 32'hFFFFF_FFF;
      	alu_in2 = 32'hFFFFF_000;
      	
      	//  add
      	# 10
      	func_code = 10'b000_0000000;
      	alu_in1 = 2;
      	alu_in2 = 2;
      	
      	// sub 
      	# 10
      	func_code = 10'b000_0100000;
      	alu_in1 = 7;
      	alu_in2 = 4;
      	
      	// sll 
      	# 10
      	func_code = 10'b001_0000000;
      	alu_in1 = 1;
      	alu_in2 = 5;
      	
      	// slt 
      	# 10
      	func_code = 10'b010_0000000;
      	alu_in1 = 1;
      	alu_in2 = 2;
      	
      	// sltu 
      	# 10
      	func_code = 10'b011_0000000;
      	alu_in1 = 1;
      	alu_in2 = 2;
      	
      	// xor 
      	# 10
      	func_code = 10'b100_0000000;
      	alu_in1 = 32'hFFFF_FFFF;
      	alu_in2 = 32'h0000_000E;
      	
      	// srl 
      	# 10
      	func_code = 10'b101_0000000;
      	alu_in1 = 32'h8000_0000;
      	alu_in2 = 31;
      	
      	// sra 
      	# 10
      	func_code = 10'b101_0100000;
      	alu_in1 = 32'h8000_0000;
      	alu_in2 = 31;
      	
      	// or 
      	# 10
      	func_code = 10'b110_0000000;
      	alu_in1 = 32'hFFFF_0000;
      	alu_in2 = 32'h0000_FFFF;
      	
      	// and 
      	# 10
      	func_code = 10'b111_0000000;
      	alu_in1 = 32'hFFFF_FFFF;
      	alu_in2 = 32'hFFFF_FFFF;
      	
      	# 20
      	$finish;
    end
    
endmodule
