////////////////////////////////////////////////////////////////////////
//	Jul 28 2018
//	Testbench fot seq_adder_tb
//	by VAL
////////////////////////////////////////////////////////////////////////

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
