////////////////////////////////////////////////////////////////////////
//	Jul 28 2018
//	full adder
// 	by VAL
////////////////////////////////////////////////////////////////////////

module adder(
	operandA,
	operandB,
	sum,
	carry_in,
	carry_out
	);
	
	parameter OperandWidth = 8;
	
	input		[OperandWidth-1:0]		operandA;
	input		[OperandWidth-1:0]		operandB;
	input								carry_in;
	output reg	[OperandWidth-1:0]		sum;
	output reg							carry_out;
	
	always @ *
	begin
		{carry_out, sum} = operandA + operandB + carry_in;
	end
	
endmodule