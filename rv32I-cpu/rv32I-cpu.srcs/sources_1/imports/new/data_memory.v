
`timescale 1ns / 1ps

module data_memory (
	input r,
	input [31:0] address,
	input write_en,
	input read_en,
	input [31:0] write_data,
	output reg [31:0] read_data
);
	
	parameter MEMSIZE = 1024; 
	reg [31:0] memory[0:MEMSIZE-1];
    
    integer i;
	initial begin
	   for (i = 0; i < MEMSIZE - 1; i = i + 1) begin
            if (i == 4) begin
                memory[i] = 68;
            end 
            else begin
                memory[i] = 0;
            end	   
	   end
	end
	
	
	always @(*) begin
		if (r) begin
		  read_data = 0;
		end
		else if (write_en) begin
			read_data = 0;
			memory[address] = write_data;
		end
		else if (read_en) begin
			read_data = memory[address];
		end
		else begin
		  read_data = 0;
		end
	end
    

endmodule

/*
`timescale 1ns / 1ps

module data_memory (
	input clk,
	input r,
	input [31:0] address,
	input write_en,
	input read_en,
	input [31:0] write_data,
	output reg [31:0] read_data
);
	
	parameter MEMSIZE = 1024; 
    reg [31:0] memory[0:MEMSIZE-1];

    // Initial block for simulation purposes
    integer i;
    initial begin
        for (i = 0; i < MEMSIZE; i = i + 1) begin
            memory[i] = (i == 4) ? 68 : 0;
        end
    end

    // Synchronous read/write operations with reset
    always @(posedge clk) begin
        if (r) begin
            read_data <= 0; // Reset read_data to zero
        end
        else if (write_en) begin
            memory[address] <= write_data;
        end
        else if (read_en) begin
            read_data <= memory[address];
        end
    end
	
endmodule
*/