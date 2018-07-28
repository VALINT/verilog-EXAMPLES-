////////////////////////////////////////////////////////////////////////
// 	Jul 28 2018
//	Syncronous adder
//	by VAL
////////////////////////////////////////////////////////////////////////

module seq_adder(
	clk,
	rst,
	termA,
	termB,
	sum,
	carry);
	
	parameter N = 8;
	
	input 				clk;
	input				rst;
	input		[N-1:0]	termA;
	input		[N-1:0]	termB;
	output reg	[N-1:0]	sum;
	output reg			carry;
	
	
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			sum 	<= 0;
			carry 	<= 0;
		end
		else
		begin
			{carry, sum} <= termA + termB;
		end
	end

endmodule
