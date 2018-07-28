////////////////////////////////////////////////////////////////////////
//	Jul 28 2018
//	Generator fot seq_adder_tb
//	by VAL
////////////////////////////////////////////////////////////////////////

class generator;
	rand transaction trans;
	
	int repeat_count;
	
	mailbox gen2griv;
	
	event ended;
	
	function new(mailbox gen2driv);
		this.gen2driv = gen2driv;
	endfunction
	
	task main();
		repeat(repeat_count)begin
			if(!trans.randomize())
			begin
				$fatal("Gen:: trans randomization failed");
				trans.display("[Generator]");
				gen2driv.put(trans);
			end
		end
		->ended;
	endtask
endclass
