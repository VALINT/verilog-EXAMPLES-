////////////////////////////////////////////////////////////////////////
//	Jul 29 2018
//	Testbench for sequential divider
//	by VAL
////////////////////////////////////////////////////////////////////////

module seq_divider_tb();

	reg 			clk;
	reg 			rst;
	reg				div_start;
	reg 	[14:0]	divident;
	reg		[7:0]	divisor;
	wire			div_ready;
	wire	[9:0]	fraction;
	wire	[7:0]	remainder;
	
	seq_divider DUT(
		.clk(clk),
		.rst(rst),
		.div_start(div_start),
		.div_ready(div_ready),
		.divident(divident),
		.divisor(divisor),
		.fraction(fraction),
		.remainder(remainder)
		);
		
	initial begin
		#1000;
		divident = 'b101100100000000;
		divisor  = 'd35;
		div_start = 1;
		#11;
		div_start = 0;
		#300;
		
		divident = 'd120;
		divisor  = 'd5;
		div_start = 1;
		#11;
		div_start = 0;
		#300;
		$finish;
	end
		
	initial begin
		clk = 0;
		rst = 0;
		divident = 'd0;
		divisor  = 'd0;
		div_start = 0;
		#5 rst = 1;
		#5 rst = 0;
		
		forever #5 clk = ~clk;
	end
		
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end

endmodule
