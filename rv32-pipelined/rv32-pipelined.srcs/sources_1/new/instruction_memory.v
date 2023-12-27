`timescale 1ns / 1ps
module instruction_memory (
	input r,
	input [31:0] read_addr,
	output reg [31:0] instr
	//input [31:0] i_mem_addr,
	//input [31:0] i_mem_data,
	//input i_mem_write
);

    localparam MEMSIZE = 1024;
    localparam MEMWIDTH = 32;
    reg [MEMWIDTH-1:0] i_memory[0:MEMSIZE-1];
	/*
	integer i;
	initial begin
	   for (i = 0; i < MEMSIZE - 1; i = i + 1) begin
	      i_memory[i] = 0;
	   end
	end
	*/
	always @(*) begin
		if (r) begin
			instr = 32'b0;
		end
		/*
		else if (i_mem_write) begin
		    i_memory[i_mem_addr[9:0]] = i_mem_data;
		    instr = instr;
		end
		*/
		else begin
			instr = i_memory[read_addr[9:0]];
		end
	end
	
	
	// Complete test
    // Assumes x1 = 1, x2 = 5, and rest of registers are 0 at runtime    
    integer i;
	initial begin
	   for (i = 0; i < MEMSIZE - 1; i = i + 1) begin
            
            if (i == 0) begin
                i_memory[i] = 32'b0000000_00010_00001_000_00011_0110011; // add x3, x1, x2        
            end
            
            else if (i == 1) begin
                i_memory[i] = 32'b0100000_00001_00010_000_00100_0110011; // sub x4, x1, x2
            end
            
            else if (i == 2) begin
                i_memory[i] = 32'b0000000_00010_00001_111_00101_0110011; // and x5, x1, x3
            end
            
            else if(i == 3) begin
                i_memory[i] = 32'b0000000_00010_00100_110_00110_0110011; // or x6, x4, x2           
            end
            
            else if (i == 4) begin
                i_memory[i] = 32'b000000000100_00000_010_00111_0000011; // lw x7, 4(x0)          
            end
            
            else if (i == 5) begin
                i_memory[i] = 32'b0000000_00111_00000_010_00000_0100011; // sw x7, 0(x0)
            end
            
            else if (i == 6) begin
                i_memory[i] = 32'b0000000_00110_00010_000_01010_1100011; // beq x2, x6, offset
            end
            
            else if (i == 16) begin
                i_memory[i] = 32'b0000000_00011_00001_000_00011_0110011; // add x3, x3, x2
            end
            
            else begin
                i_memory[i] = 0;
            end	   
	    end
	end
    
endmodule

