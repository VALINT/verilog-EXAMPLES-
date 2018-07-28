////////////////////////////////////////////////////////////////////////
//	Jul 28 2018
//	Driver fot seq_adder_tb
//	by VAL
////////////////////////////////////////////////////////////////////////

class driver
	
	int no_transactions;
	
	virtual intf vintf;
	
	mailbox gen2driv;
	
	function new(virtual intf vintf, maolbox gen2driv);
		
		this.vintf = vintf;

		this.gen2driv = gen2driv;
	endfunction
	
	task reset;
		wait(vintf.reset);
		$display("[DRIVER] ---- Reset Started ----");
		vintf.termA <= 0;
		vintf.termB <= 0;
		wait(!vintf.reset);
		$display("[DRIVER] ---- Reset Ended ----");	
	endtask
	
	task main;
		forever begin
			transaction trans;
			gen2driv.get(trans);
			@(posedge vintf.clk);
			vintf.termA	<= trans.termA;
			vintf.termB <= trans.termB;
			@(posedge vintf.clk);
			trans.sum	 = vintf.sum;
			trans.carry	 = vintf.carry;
			@(posedge vintf.clk);
			trans.display("[ DRIVER ]");
			no_transactions++;
		end
	endtask
endclass
