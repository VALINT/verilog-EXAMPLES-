////////////////////////////////////////////////////////////////////////
//	Jul 28 2018
//	Environment fot seq_adder_tb
//	by VAL
////////////////////////////////////////////////////////////////////////

`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"

class environment;
	
	generator 	gen;
	driver		driv;
	
	mailbox	gen2driv;
	
	virtual	intf vintf;
	
	function new(virtual intf vintf);
		this.vintf = vintf;
		
		gen2driv = new();
		
		gen  = new(gen2driv);
		driv = new(vintf,gen2driv);
	endfunction
	
	task pre_test();
		driv.reset();
	endtask
	
	task test();
		fork
		gen.main();
		driv.main();
		join_any
	endtask
	
	task post_test();
		wait(gen.ended.triggered);
		wait(gen.repeat_count == driv.no_transactions);
	endtask
	
	task run;
		pre_test();
		test();
		post_test();
		$finish;
	endtask
endclass
