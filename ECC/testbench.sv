

`resetall
`timescale 1ns/10ps

// Code your testbench here
// or browse Examples
module testbench();
  reg [31:0]	in_data;
  reg [5:0] ecc;
  
  wire [31:0]	out_data;
  
  ecc #( 
	.DATA_WIDTH(32)
  )
  DUT(
    .in_data(in_data),
    .in_ham_gr(ecc),
    .out_data(out_data)
  );
  
  initial begin
    in_data = 10'b11000101;
    ecc = 4'b0010;
    #100;
    in_data = 10'b11000100;
    #100;
    in_data = 10'b11000111;
    #100;
    in_data = 10'b11000001;
    #100;
    in_data = 10'b11001101;
    #100;
    in_data = 10'b11010101;
    #100;
    in_data = 10'b11100101;
    #100;
    in_data = 10'b10000101;
    #100;
    in_data = 10'b01000101;
    #100;
    in_data = 10'b11000101;
    ecc = 4'b0010;
    #100;
    ecc = 4'b0011;
    #100;
    ecc = 4'b0000;
    #100;
    ecc = 4'b0110;
    #100;
    ecc = 4'b1010;
    
    in_data = 10'b11100011;
    ecc = 4'b1011;
    #100;
    in_data = 10'b11100010;
    #100;
    in_data = 10'b11100001;
    #100;
    in_data = 10'b11100111;
    #100;
    in_data = 10'b11101011;
    #100;
    in_data = 10'b11110011;
    #100;
    in_data = 10'b11000011;
    #100;
    in_data = 10'b10100011;
    #100;
    in_data = 10'b01100011;
    #100;
    in_data = 10'b11100011;
    ecc = 4'b1010;
    #100;
    ecc = 4'b1001;
    #100;
    ecc = 4'b1111;
    #100;
    ecc = 4'b0011;
    #100;
    ecc = 4'b1011;
    
    
    
    #4000;
    $stop;
  end
  
 	initial
	begin
		$shm_open("testbench.shm",1);
		$shm_probe("ASCMTF");
	end
  
endmodule




/*
`define MEM_VOLUME		256		//16bit words
`define MAX_WORDS		8
`define MAX_ERR_IN_WORD 4

parameter Repeat = 1000000;

module testbench();

	reg					clk;
	reg					rstb;
	reg		[15:0]		crc_data_in;
	reg		[15:0]		per_wdata;
	reg		[2:0]		rombist_access;
	reg					enable_crc;
	reg					init;
	reg 				enable;
	reg 				clear;
	
	wire	[15:0]		crc_out;
	
	reg		[15:0]		data[`MEM_VOLUME-1:0];
	
	reg		[15:0]		TrueCRC;
	reg		[15:0]		FaultedCRC;
	reg		[15:0]		buffer;
	
	integer		 		pointer;
	
	integer				ErrorsAmount 	= 0;
	integer				WordsAmount		= 0;
	integer				RegisterNumber 	= 0;
	integer				ErrorsArray[`MAX_ERR_IN_WORD-1:0];
	integer				WordsArray[`MAX_WORDS-1:0];
	integer 			CurrentSell 	= 0;
	integer 			WordCurrentSell = 0;
	integer				GenBuffer		= 0;
	integer				WordGenBuffer	= 0;
	integer				OriginData		= 0;
	integer				TotalErrors		= 0;
	
	integer				ErrorCounter = 0;
	
	integer             log_file;
	integer				summery_file;
	reg					compoint;
	
	real percentage;
	real ErrC;
	real Rpt;
	
	
	task CountCRC();

		clear = 1;
		@(posedge clk)
		@(posedge clk)
		clear = 0;
		pointer = 0;
		crc_data_in = 0;
		//@(posedge clk)
		repeat(`MEM_VOLUME) 
		begin
			crc_data_in = data[pointer][15:0];
			enable_crc = 1;
			@(posedge clk)
			pointer = pointer + 1;
		end
		enable_crc = 0;
		@(posedge clk)
		enable_crc = 0;
	endtask


// ==================================================================================
// DUT
		CRC16 DUT(
		.clk(clk),
		.rstb(rstb),
		.data_in(crc_data_in),
		.signature(crc_out),
		.ready(enable_crc),
		.clear(clear)
	);
	
//===========================================================================================================
// Data generator
	
	function int TestOnCompares();
	integer i = 0;
		repeat(CurrentSell) begin
			if(GenBuffer == ErrorsArray[i])
			begin
				i = 0;
				return 0;
			end
			i = i + 1;
		end
		i = 0;
		return 1;
	endfunction

	function int WordsOnCompares();
	integer i = 0;
		repeat(WordCurrentSell) begin
			if(WordGenBuffer == WordsArray[i])
			begin
				i = 0;
				return 0;
			end
			i = i + 1;
		end
		i = 0;
		return 1;
	endfunction

	task DataGenerate();
		integer i = 0;
		repeat(`MEM_VOLUME)begin
			data[i] = $urandom_range(0,65535);
			i = i + 1;
		end
		i = 0;		 
	endtask
	
	task ErrorGenerate();
		TotalErrors = 0;
		WordsAmount = $urandom_range(1,`MAX_WORDS);
		repeat(WordsAmount)begin
			do
				WordGenBuffer = $urandom_range(0,`MEM_VOLUME-1);
			while(!WordsOnCompares());
			//#10;
			WordsArray[WordCurrentSell] = WordGenBuffer;
			WordCurrentSell = WordCurrentSell + 1;
			ErrorsAmount = $urandom_range(1,`MAX_ERR_IN_WORD);
			TotalErrors = TotalErrors + ErrorsAmount;
			RegisterNumber = WordGenBuffer;
				ErrorsArray[CurrentSell] = $urandom_range(1,15);
				CurrentSell = CurrentSell + 1;
			repeat(ErrorsAmount-1) begin
				do
					GenBuffer = $urandom_range(0,15);
				while(!TestOnCompares());
				ErrorsArray[CurrentSell] = GenBuffer;
				CurrentSell = CurrentSell + 1;
			end
			CurrentSell = 0;
			
			InjectError();
		end
		
		WordCurrentSell = 0;
	endtask
	
	task serror;									//Inject error in word
		input	[3:0]	rgstr;
		input 	[15:0]  buff;
			begin : bit_flip
				if(buff & (1 << rgstr))
					buffer = buff &~ (1 << rgstr);
				else
					buffer = buff | (1 << rgstr);
			end
	endtask
	
	task InjectError();
		OriginData = data[RegisterNumber];
		buffer = data[RegisterNumber];
		repeat(ErrorsAmount)
		begin
			serror(ErrorsArray[CurrentSell],buffer);
			CurrentSell = CurrentSell + 1;
		end
		CurrentSell = 0;
		data[RegisterNumber] = buffer;
	endtask

	integer a = 0;
	integer b = 0;
	initial 
	begin
		rstb = 0;
		#4;
		rstb = 1;
		crc_data_in = 0;
		log_file = $fopen("Log.txt","w");
		summery_file = $fopen("Summery.txt","w");
		$fwrite(log_file,"Hello, it is parallel CRC16 for MLX90339 test \n Log file \n");
		$fwrite(summery_file,"Hello, it is parallel CRC16 for MLX90339 test \n Summery \n");
		#4;
		$display("Gen start");
		repeat(Repeat+1) 
		begin
			#4;
			DataGenerate();
			CountCRC();
			TrueCRC = crc_out;
			#4;
			ErrorGenerate();
			
			CountCRC();
			FaultedCRC = crc_out;
			#5;
			
			if(!(a%(Repeat/10)))
				$display("Percentage - %d",a/(Repeat/100),"%%"); 
			compoint = ~compoint;
			if(OriginData != data[RegisterNumber])
				if(TrueCRC == FaultedCRC)
				begin
					
					ErrorCounter = ErrorCounter + 1;
					$display("Error!! Cycle - %d, Time - %d nS, Errors injected - %d, \n WordsAmount - %d",a,$time,TotalErrors,WordsAmount);
					for(b = 0; b < WordsAmount; b = b + 1)
					begin
						$display("Word Number - %d",WordsArray[b]);
					end
					$fwrite(log_file,"Error!! Cycle - %d, Time - %d nS, Errors injected - %d, \n WordsAmount - %d",a,$time,TotalErrors,WordsAmount);
				end
				
			else if(OriginData == data[RegisterNumber])
				$display("Error not injected");
			a=a+1;
		end
		$display("Total errors injected - ",Repeat);
		$fwrite(log_file,"\n Total errors injected - %d \n",Repeat);
		$fwrite(summery_file,"\n Total errors injected - %d \n",Repeat);
		
		$display("Errors missed - ",ErrorCounter);
		$fwrite(log_file,"Errors missed - %d \n \n",ErrorCounter);
		$fwrite(summery_file,"Errors missed - %d \n \n",ErrorCounter);
		
		$display("\n");
		
		ErrC = ErrorCounter;
		Rpt = Repeat;
		percentage = ((ErrC/Rpt)*100);
		
		$display("\n");
		$fwrite(log_file,"\n");
		$fwrite(summery_file,"\n");
		
		$display("Error injected - %d, CRC errors missed - %d \n",Repeat,ErrorCounter);
		$fwrite(log_file,"Error injected - %d, CRC errors missed - %d \n \n",Repeat,ErrorCounter);
		$fwrite(summery_file,"Faulted bits - %d, CRC errors missed - %d \n \n",Repeat,ErrorCounter);
		$display("Percentage of missed errors - %.4f  %%\n",percentage);
		$fwrite(log_file,"Percentage of missed errors - %.4f %% \n",percentage);
		$fwrite(summery_file,"Percentage of missed errors - %.4f %% \n",percentage);
		
		percentage = (((Rpt-ErrC)/Rpt)*100);
		
		$display("Detection Rate - %.4f  %%\n",percentage);
		$fwrite(log_file,"Detection Rate - %.4f %% \n",percentage);
		$fwrite(summery_file,"Detection Rate - %.4f %% \n",percentage);
		
		$fclose(log_file);
		$fclose(summery_file);
		
		$display("Total simulation time - %d nS",$time);
					
		$stop;
	end
	
	initial begin
		enable_crc = 0;
		init = 0;
		compoint = 0;
	end
	
	initial
    begin
		rstb = 0;
		#10;
		rstb = 1;
        clk = 0;
        #10;
        forever #1 clk = ~clk;
    end


	initial
	begin
		$shm_open("testbench.shm",1);
		$shm_probe("ASCMTF");
	end

//endmodule 
*/
