////////////////////////////////////////////////////////////////////////
//	Jul 29 2018
//	Testbench for sequential divider
//	by VAL
////////////////////////////////////////////////////////////////////////

module seq_divider_tb();

	reg 			clk;
	reg 			rst;
	reg				div_start;
	reg 	[7:0]	divident;
	reg		[7:0]	divisor;
	wire			div_ready;
	wire	[7:0]	fraction;
	wire	[7:0]	remainder;
	integer			math;
	seq_divider DUT(
		.clk(clk),
		.rst(rst),
		.div_start(div_start),
		.div_ready(div_ready),
		.divident(divident),
		.divisor(divisor),
		.quiontent(fraction),
		.remainder(remainder)
		);
		
task trans;
		input  [7:0] ax;
		input  [7:0] bx;
		begin
			divident = ax;
			divisor = bx;
			checker(ax,bx);
		end
	endtask

	task checker;
		input  [7:0] ax;
		input  [7:0] bx;
		begin
			@(posedge clk)
			#3;
			div_start = 0;
			math = ax/bx;
			@(posedge div_ready)
			#3
			if((math == fraction))
				$display("A - %3d, B - %3d, Q - %3d, M - %3d", ax, bx, fraction, math, "	True");
			else 
				$display("A - %3d, B - %3d, Q - %3d, M - %3d", ax, bx, fraction, math, "	False");
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
				div_start = 1;
				trans(a,b);
			end
			
		end
	end
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
