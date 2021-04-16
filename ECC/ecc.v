// Code your design here
module ecc(
	in_data,
  	in_ham_gr,
  	out_data,
);
  
  parameter DATA_WIDTH = 8;
  
  parameter DATA_W_LOG = $clog2(DATA_WIDTH);
  parameter HAMMING_GROUP = DATA_W_LOG+(DATA_WIDTH+DATA_W_LOG)/(2**DATA_W_LOG);
  
  
  
  output reg	[DATA_WIDTH-1: 0]					out_data;
	
  input			[DATA_WIDTH-1 : 0] 					in_data;
  input			[HAMMING_GROUP-1 : 0]				in_ham_gr;
  
  reg			[DATA_WIDTH+HAMMING_GROUP-1:0]		conv_in_data;
  reg			[DATA_WIDTH+HAMMING_GROUP-1:0]		corrected_data;
  reg			[HAMMING_GROUP-1 : 0]				c_hamm_gr;
  wire												single_error;
  
  reg			[DATA_WIDTH+HAMMING_GROUP-1:0]		hamm_arr 			[HAMMING_GROUP-1 : 0];

  assign single_error = |c_hamm_gr;

  task build_mask;
  integer i;
  integer j;
  begin
		hamm_arr[0] = 32'd0;
		
		 for(i = 0; i < HAMMING_GROUP; i = i+1)
		 begin
			hamm_arr[i] = 0;
			for(j = 1; j < DATA_WIDTH+HAMMING_GROUP+1; j = j + 1)
			  if(j[i])
				hamm_arr[i] = hamm_arr[i]|(1 << (j-1)); 
		 end
  end	 
  endtask

  integer a;
  integer h = 0;
  integer d = 0;
  integer number_d = 0;
  integer curr_d = 0;
  
  initial begin
	build_mask();
  end
  
  always @ *
    begin	: build_convinient_data_form
      for(a = 1; a <= DATA_WIDTH+HAMMING_GROUP; a = a + 1)
        begin
          if(!h)
            begin
            	conv_in_data[a-1] <= in_ham_gr[h];
              	h = h + 1;
            end
          else if(!curr_d)
            begin
              conv_in_data[a-1] <= in_ham_gr[h];
              h = h+1;
              number_d = number_d*2+1;
              curr_d = number_d;
            end
          else
            begin
              conv_in_data[a-1] <= in_data[d];
			  out_data[d] = corrected_data[a-1];
              curr_d = curr_d -1;
              d = d + 1;
            end
        end
      	h = 0;
   		d = 0;
  		number_d = 0;
 		curr_d = 0;
    end 
	
	integer h_g;
	
	always@ *
	begin
		for(h_g = 0; h_g < HAMMING_GROUP; h_g = h_g + 1)
		begin
			c_hamm_gr[h_g] =  ^(conv_in_data&hamm_arr[h_g][DATA_WIDTH+HAMMING_GROUP-1:0]);
		end
	end

integer t;

  always @ *
    begin	: correct_data
      for(t = 1; t < DATA_WIDTH+HAMMING_GROUP+1; t = t + 1)
      begin
		if(t == c_hamm_gr)
			corrected_data[t-1] = !conv_in_data[t-1];
		else
			corrected_data[t-1] = conv_in_data[t-1];
      end
    end 
	
endmodule
