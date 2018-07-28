////////////////////////////////////////////////////////////////////////
//	Jul 28 2018
//	Random test fot seq_adder_tb
//	by VAL
////////////////////////////////////////////////////////////////////////

`include "environment.sv"
program test(intf tintf);
	
	environment env;
	
	initial begin
		env = new(tintf);
		
		env.gen.repeat_count = 4;
		
		env.run();
	end
endprogram
