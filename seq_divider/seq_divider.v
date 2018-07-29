////////////////////////////////////////////////////////////////////////
//	Jul 29 2018
//	Sequential divider
//	by VAL
////////////////////////////////////////////////////////////////////////

module seq_divider(
	clk,
	rst,
	div_start,
	div_ready,
	divident,
	divisor,
	fraction,
	remainder
	);
	
	parameter N = 8;
	
	input					clk;
	input					rst;
	input					div_start;
	input		[14:0]		divident;
	input		[7:0]		divisor;
	output		[9:0]		fraction;
	output		[7:0]		remainder;
	output reg				div_ready;
	wire		[9:0]		subs;
	wire		[9:0]		fraction;
	wire		[7:0]		remainder;
	reg			[16:0]		answer;
	reg			[3:0]		counter;
	
	assign subs = answer[16:9] - divisor;
	assign fraction = answer[9:0];
	assign remainder = answer[15:8];
	
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			answer 		<= 0;
			counter 	<= 0;
			div_ready 	<= 0;
		end
		else
		begin
			if(div_start)
			begin
				counter 		<= 0;
				answer[2*N-1:N]	<= divident;
				answer[N-1:0]	<= 8'b0;
				div_ready 		<= 0;
			end else if(!div_ready)
			begin
				if(subs[16])
				begin
					answer 			<= (answer << 1);
				end
				else
				begin
					answer 			<= (answer << 1) + 1;
					answer[16:9]	<= subs[7:0];					
				end
				counter = counter + 1;
				if(counter == 11)
				begin
					div_ready <= 1;
				end
			end
		end
	end
	
endmodule
