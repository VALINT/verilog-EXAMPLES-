////////////////////////////////////////////////////////////////////////
//	Jul 28 2018
//	full adder
// 	by VAL
////////////////////////////////////////////////////////////////////////

module adder(
	term_a,
	term_b,
	sum,
	carry_in,
    carry_out
	);
	
	parameter N = 8;
	
	input		[N-1:0]		term_a;
	input		[N-1:0]		term_b;
    input                   carry_in;
	output reg	[N-1:0]		sum;
	output reg				carry_out;
	
	always @ *
	begin
		{carry_out, sum} = term_a + term_b + carry_in;
	end
	
endmodule
