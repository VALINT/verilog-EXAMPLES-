////////////////////////////////////////////////////////////////////////
//	Jul 28 2018
//	full adder
// 	by VAL
////////////////////////////////////////////////////////////////////////

module adder(
	termA,
	termB,
	sum,
	carry
	);
	
	parameter N = 8;
	
	input		[N-1:0]		termA;
	input		[N-1:0]		termB;
	output reg	[N-1:0]		sum;
	output reg				carry;
	
	always @ *
	begin
		{carry, sum} = termA + termB;
	end
	
endmodule
