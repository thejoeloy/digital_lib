module combinational_tb;

/*
parameter n = 2;
parameter m = 4;
reg [n-1:0] a;
wire [m-1:0] b;

Dec #(n,m) d1(a,b);



parameter k = 4;
reg [k-1 : 0] a0, a1, a2;
reg [2:0] s;
wire [3:0] b;

Mux3 #(k) mux(a2, a1, a0, s, b);


parameter k = 4;
reg [k-1 : 0] a0, a1, a2;
reg [1:0] sb;
wire [k-1:0] b;

Muxb3 #(k) muxb(a2, a1, a0, sb, b);


parameter k = 4;
reg [k-1 : 0] a0, a1, a2, a3, a4, a5;
reg [5:0] s;
wire [k-1:0] b;

Mux6a #(k) mux6(a0, a1, a2, a3, a4, a5, s, b);


   reg[3:0] a;
   wire [1:0] b;

   Enc42 enc42(a, b);


   reg[3:0] a;
   wire [1:0] b;
   wire	      c;
   Enc42a enc42a(a, b, c);


   reg[15:0] a;
   wire [3:0] b;

   Enc164 enc164(a, b);

   reg[7:0] r;
   wire [7:0] g;

   Arb arb(r, g);

   reg[7:0] r;
   wire [7:0] g;

   RArb rarb(r, g);

   reg[7:0] r;
   wire [2:0] b;

   PriorityEncoder83 pe83(r, b);

   reg[7:0] a, b;
   wire	    eq;

   EqComp ec(a, b, eq);
*/
   reg[7:0] a, b;
   wire	    gt;

   MagComp mc(a, b, gt);
   
// Test each possible input of a for decoder
/*
initial begin
    $monitor("At time %t, a = %d, b = %d", $time, a, b);
    $dumpfile("combinational_tb.vcd");
    $dumpvars(0, combinational_tb);
    # 5 a = 0;
    # 5 a = 1;
    # 5 a = 2;
    # 5 a = 3;
end

// Test for mux3
initial begin
    $monitor("At time %t, a0 = %d, a1 = %d, a2 = %d, sb = %d, b = %d", $time, a0, a1, a2, sb, b);
    $dumpfile("combinational_tb.vcd");
    $dumpvars(0, combinational_tb);
    
    # 5
    a0 = 0;
    a1 = 0;
    a2 = 0;
    s = 0;
    
    # 5
    a0 = 1;
    a1 = 2;
    a2 = 4;
    s = 0;
    
    # 5
    s = 1;
    
    #5
    s = 2;
    
    #5
    s = 4;
    
    #5
    $finish;
    
end

// muxb3 test 
initial begin
    $monitor("At time %t, a0 = %d, a1 = %d, a2 = %d, sb = %d, b = %d", $time, a0, a1, a2, sb, b);
    $dumpfile("combinational_tb.vcd");
    $dumpvars(0, combinational_tb);
    
    # 5
    a0 = 0;
    a1 = 0;
    a2 = 0;
    sb = 0;
    
    # 5
    a0 = 1;
    a1 = 2;
    a2 = 4;
    sb = 0;
    
    # 5
    sb = 1;
    
    #5
    sb = 2;
    
    #5
    sb = 4;
    
    #5
    $finish;
    
end



// mux6 test
initial begin
    $monitor("At time %t, a0 = %d, a1 = %d, a2 = %d, a3 = %d, a4 = %d, a5 = %d, s = %d, b = %d", $time, a0, a1, a2, a3, a4, a5, s, b);
    $dumpfile("combinational_tb.vcd");
    $dumpvars(0, combinational_tb);
    
    # 5
    a0 = 1;
    a1 = 2;
    a2 = 3;
    a3 = 4;
    a4 = 5;
    a5 = 6;
    
    # 5
    
    s = 6'b000001;
    
    # 5

    s = 6'b000010;
    
    # 5
    s = 6'b000100;
    
    #5
    s = 6'b001000;
    
    #5
    s = 6'b010000;
    
    #5
    s = 6'b100000;
    #5
    
    $finish;
    
end


   // Enc42 test
   initial begin
      $monitor("At time %t, a= %d, b = %d", $time, a, b);
      $dumpfile("combinational_tb.vcd");
      $dumpvars(0, combinational_tb);

      # 5
	a = 0;

      # 5
	a = 1;
      # 5
	a = 2;
      # 5
	a = 3;
      # 5
	a = 4;
      # 5
	a = 5;
      # 5
	a = 6;
      # 5
	a = 7;
      # 5
	a = 8;
      # 5
	a = 9;
      # 5
	a = 10;
      # 5
	a = 11;
      # 5
	a = 12;
      # 5
	a = 13;
      # 5
	a = 14;
      # 5
	a = 15;
      # 5
	$finish;	
   end 


   // Enc42a test
   initial begin
      $monitor("At time %t, a= %d, b = %d, c = %d", $time, a, b, c);
      $dumpfile("combinational_tb.vcd");
      $dumpvars(0, combinational_tb);

      # 5
	a = 0;
      # 5
	a = 1;
      # 5
	a = 2;
      # 5
	a = 3;
      # 5
	a = 4;
      # 5
	a = 5;
      # 5
	a = 6;
      # 5
	a = 7;
      # 5
	a = 8;
      # 5
	a = 9;
      # 5
	a = 10;
      # 5
	a = 11;
      # 5
	a = 12;
      # 5
	a = 13;
      # 5
	a = 14;
      # 5
	a = 15;
      # 5
	$finish;	
   end 

   // Enc164 test
   initial begin
      $monitor("At time %t, a= %d, b = %d", $time, a, b);
      $dumpfile("combinational_tb.vcd");
      $dumpvars(0, combinational_tb);

      # 5
	a = 0;
      repeat (50) # 5 a = a + 1;
       
      $finish;
   end
  
   // Arb test
   initial begin
      $monitor("At time %t, r= %d, g= %d", $time, r, g);
      $dumpfile("combinational_tb.vcd");
      $dumpvars(0, combinational_tb);

      # 5
	r = 0;
      repeat (50) # 5 r = r + 1;
       
      $finish;
   end 

   // RArb test
   initial begin
      $monitor("At time %t, r= %d, g= %d", $time, r, g);
      $dumpfile("combinational_tb.vcd");
      $dumpvars(0, combinational_tb);

      # 5
	r = 0;
      repeat (50) # 5 r = r + 1;
       
      $finish;
   end

    // Priority Encoder test
   initial begin
      $monitor("At time %t, r= %d, b= %d", $time, r, b);
      $dumpfile("combinational_tb.vcd");
      $dumpvars(0, combinational_tb);

      # 5
	r = 0;
      repeat (50) # 5 r = r + 1;
       
      $finish;
   end

   initial begin
      $monitor("At time %t, a= %d, b= %d, eq= %d", $time, a, b, eq);
      $dumpfile("combinational_tb.vcd");
      $dumpvars(0, combinational_tb);

      # 5
      a = 0;
      b = 0;
      # 5
      a = 1;
      b = 1;
      # 5
      a = 27;
      b = 27;
      # 5
      a = 1;
      b = 2;
      
      
        
      
      repeat (50) begin
	 # 5
	 a = a + 1;
	 b = b + 1;
	 
      end
      
       
      $finish;
   end
*/
initial begin
      $monitor("At time %t, a= %d, b= %d, gt= %d", $time, a, b, gt);
      $dumpfile("combinational_tb.vcd");
      $dumpvars(0, combinational_tb);

      # 5
      a = 0;
      b = 0;
      # 5
      a = 1;
      b = 1;
      # 5
      a = 27;
      b = 27;
      # 5
      a = 1;
      b = 2;
      
      
        
      
      repeat (50) begin
	 # 5
	 a = a + 1;
	 b = b + 1;
      end
   
      # 5
      a = 2;
      b = 1;
      
	 
      repeat (50) begin
	 # 5
	 a = a + 1;
	 b = b + 1;
      end
      
       
      $finish;
   end   
   
endmodule

