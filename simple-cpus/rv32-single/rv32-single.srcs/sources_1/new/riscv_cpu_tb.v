`timescale 1ns / 1ps
module riscv_cpu_tb();

    reg clk = 1;
    reg r;
    reg [31:0] i_mem_addr;
	reg [31:0] i_mem_data;
	reg i_mem_write;
    
    riscv_cpu dut(
        .clk(clk),
        .r(r),
        .i_mem_addr(i_mem_addr),
        .i_mem_data(i_mem_data),
        .i_mem_write(i_mem_write)
    );
    
    always begin
        # 5 clk = ~clk;    
    end
    
    initial begin
        $monitor("At time %t", $time);
      	$dumpfile("riscv_cpu_tb.vcd");
      	$dumpvars(0, riscv_cpu_tb);
      	r = 1;
      	i_mem_addr = 0;
      	i_mem_data = 0;
      	i_mem_write = 0;
      	# 5
      	r = 0;
      	# 20
      	$finish;
    end
    
endmodule
