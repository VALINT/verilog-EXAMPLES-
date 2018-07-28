////////////////////////////////////////////////////////////////////////
//	Jul 28 2018
//	Testbench fot seq_adder_tb
//	by VAL
////////////////////////////////////////////////////////////////////////

module seq_adder_tb();
	parameter N = 8;
	
	reg				clk;
	reg				rst;
	reg		[N-1:0]	termA;
	reg		[N-1:0]	termB;
	wire	[N-1:0]	sum;
	wire			carry;
	
	seq_adder DUT(
	.clk(clk),
	.rst(rst),
	.termA(termA),
	.termB(termB),
	.sum(sum),
	.carry(carry)
	);
		
	task trans;
		input  [7:0] ta;
		input  [7:0] tb;
		begin
			termA = ta;
			termB = tb;
			checker(ta,tb);
		end
	endtask

	task checker;
		input  [7:0] ta;
		input  [7:0] tb;
		begin
			@(posedge clk)
			#3;
			if(ta + tb == (carry*256+sum))
				$display("A - %0d, B - %0d, C - %0b, S - %0d", ta, tb, carry, sum, "True");
			else
				$display("A - %0d, B - %0d, C - %0b, S - %0d", ta, tb, carry, sum, "False");
		end
	endtask
		
initial begin : test_module
		integer	a;
		integer	b;
		integer counter;
		counter = 0;
	
	#1;
	repeat(10000)
	begin
		@(posedge clk);
		begin
			counter = counter + 1;
			if(counter > 10)
			begin
				counter = 0;
				a = $urandom_range(0,255);
				b = $urandom_range(0,255);
				trans(a,b);
			end
		end
	end
		$finish;
end
		
	initial begin
		clk = 0;
		termA = 0;
		termB = 0;
		rst = 0;
		#5 rst = 1;
		#5 rst = 0;
		
		forever #5 clk = ~clk;
	end
		
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end
	
endmodule


/*
`include "interface.sv"

`include "random_test.sv"

module testbench_top;
	
	bit clk;
	bit rst;
	
	always #5 clk = ~clk;
	
	initial begin
		rst = 1;
		#5 rst = 0;
	end
	
	intf tintf(clk, rst);
	
	test t1(tintf);
	
	seq_adder DUT(
		.clk(tintf.clk),
		.rst(tintf.rst),
		.termA(tintf.termA),
		.termB(tintf.termB),
		.sum(tintf.sum),
		.carry(tintf.carry)
		);
		
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end
	
endmodule
*/
