module arithmetic_tb;
   
   /*
   reg a, b;
   wire	cout, out;
   

   HalfAdder ha1(a, b, cout, out);
   
   initial begin
      $monitor("At time %t, a= %d, b= %d, cout= %d, out = %d", $time, a, b, cout, out);
      $dumpfile("arithmetic_tb.vcd");
      $dumpvars(0, arithmetic_tb);

      # 5
        a = 0;
        b = 0;

      # 5
	a = 1;
      
      # 5
	a = 0;
      b = 1;

      # 5
	a = 1;

      # 10
	$finish;
      
	
      
   end // initial begin
   
   
   reg[1:0] a, b; 
   reg cin;
   wire	cout;
   wire[1:0] out;
   
   
   FullAdder #(2) fa1(a, b, cin, cout, out);
   
   initial begin
      $monitor("At time %t, a= %d, b= %d, cin = %d,  cout= %d, out = %d", $time, a, b, cin, cout, out);
      $dumpfile("arithmetic_tb.vcd");
      $dumpvars(0, arithmetic_tb);

      # 5
        a = 0;
        b = 0;
        cin = 0;
      
      # 5
	a = 1;
        b = 0;
        cin = 0;
     
      # 5
	a = 0;
        b = 1;
        cin = 0;
      
      # 5
	a = 0;
        b = 0;
        cin = 1;
      # 5
	a = 1;
        b = 1;
        cin = 0;
      # 5
	a = 1;
        b = 0;
        cin = 1;
      # 5
	a = 0;
        b = 1;
        cin = 1;
      # 5
	a = 1;
        b = 1;
        cin = 1;
      # 5
	a = 2;
        b = 2;
        cin = 1;
      # 10
	$finish;
      
	
      
   end
   

   reg[1:0] a, b; 
   reg sub;
   wire	ovf;
   wire[1:0] out;
   AddSub1  #(2) fa1(a, b, sub, ovf, out);
   
   initial begin
      $monitor("At time %t, a= %d, b= %d, sub = %d, ovf= %d, out = %d", $time, a, b, sub, ovf, out);
      $dumpfile("arithmetic_tb.vcd");
      $dumpvars(0, arithmetic_tb);

      # 5
        a = 0;
        b = 0;
        sub = 0;
      
      # 5
	a = 1;
        b = 0;
        
     
      # 5
	a = 0;
        b = 1;
      
      # 5
	a = 0;
        b = 0;
      # 5
	a = 1;
        b = 1;
      # 5
	sub = 1;
	a = 1;
        b = 0;
        
     
      # 5
	a = 0;
        b = 1;
      
      # 5
	a = 0;
        b = 0;
      # 5
	a = 1;
        b = 1;
      # 5
	a = 2;
        b = 1;

      # 5
	a = 3;
      # 5
	b = 2;
      # 5
	b = 3;
      
      # 10
	$finish;
   end
   

   reg[1:0] a, b; 
   reg sub;
   wire	ovf;
   wire[1:0] out;
   AddSub2  #(2) fa1(a, b, sub, ovf, out);
   
   initial begin
      $monitor("At time %t, a= %d, b= %d, sub = %d, ovf= %d, out = %d", $time, a, b, sub, ovf, out);
      $dumpfile("arithmetic_tb.vcd");
      $dumpvars(0, arithmetic_tb);

      # 5
        a = 0;
        b = 0;
        sub = 0;
      
      # 5
	a = 1;
        b = 0;
        
     
      # 5
	a = 0;
        b = 1;
      
      # 5
	a = 0;
        b = 0;
      # 5
	a = 1;
        b = 1;
      # 5
	sub = 1;
	a = 1;
        b = 0;
        
     
      # 5
	a = 0;
        b = 1;
      
      # 5
	a = 0;
        b = 0;
      # 5
	a = 1;
        b = 1;
      # 5
	a = 2;
        b = 1;

      # 5
	a = 3;
      # 5
	b = 2;
      # 5
	b = 3;
      
      # 10
	$finish;
   end // initial begin

   */
   
   
endmodule // arithmetic_tb

