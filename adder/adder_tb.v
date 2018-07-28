////////////////////////////////////////////////////////////////////////
//	Jul 28 2018
//	full adder testbench
// 	by VAL
////////////////////////////////////////////////////////////////////////

module adder_tb();

	parameter N = 8;
	
	integer	a;
	integer b;
	
	reg		[N-1:0]		termA;
	reg		[N-1:0]		termB;
	wire	[N-1:0]		sum;
	wire				carry;

	adder DUT(
		.termA(termA),
		.termB(termB),
		.sum(sum),
		.carry(carry)
		);

	initial begin
		termA = 0;
		termB = 0;
		#1;
		for(a = 0;a < 256;a = a + 1)
		begin
			for(b = 0;b < 256;b = b + 1)
			begin
				termA = a;
				termB = b;
				#1;
				if(a + b == (carry*256 + sum))
					$display("TermA - ",a," TermB - ",b," Carry - ",carry," Sum - ",sum," True");
				else
					$display("TermA - ",a," TermB - ",b," Carry - ",carry," Sum - ",sum," False");	
			end
		end
		$finish;
	end
	
	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end
	
endmodule
