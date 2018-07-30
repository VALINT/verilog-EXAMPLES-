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
	quiontent,
	remainder
	);
	
	parameter N = 8;
	
	input					clk;
	input					rst;
	input					div_start;
	input		[7:0]		divident;
	input		[7:0]		divisor;
	output		[7:0]		quiontent;
	output		[7:0]		remainder;
	output wire				div_ready;
	wire		[8:0]		difference;
	wire					borrov;
	reg			[15:0]		buffer;
	reg			[3:0]		counter;
	
	assign {borrov,difference} = buffer[15:7] - divisor;
	assign div_ready = (counter == 4'b1000);	
	assign remainder = buffer[15:8];
	assign quiontent = buffer[7:0];
	
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			buffer 		<= 16'h0000;
		end	
		else 
		begin
			if(div_start) 
			begin
				buffer <= {8'h00,divident};
			end 
			else 
			if(!div_ready)
			begin
				if(!borrov)
				begin
					buffer <= {difference[7:0],buffer[6:0],~borrov};
				end
				else
				begin
					buffer <= {buffer[14:0],~borrov};				
				end
			end
		end
	end
	
	always @ (posedge clk or posedge rst)
	begin
		if(rst)
		begin
			counter	<= 4'b0000;
		end	
		else 
		begin
			if(div_start) 
			begin
				counter <= 4'b0000;
			end 
			else 
			if(!div_ready)
			begin
				counter <= counter + 1;
			end
		end
	end
endmodule
