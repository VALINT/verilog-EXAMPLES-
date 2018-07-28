////////////////////////////////////////////////////////////////////////
//	Jul 28 2018
//	Transaction fot seq_adder_tb
//	by VAL
////////////////////////////////////////////////////////////////////////

class transaction;
	
	parameter N = 8;
	
	rand bit [N-1:0]	termA;
	rand bit [N-1:0]	termB;
		 bit [N-1:0]	sum;
		 bit			carry;
	function void display(string name);
		$display("----------------------------------------");
		$display("- %s ", name);
		$display("----------------------------------------");
		$display("- a = %0d, b = %0d",a ,b);
		$display("- sum = %0d", (carry*512)+sum);
		$display("----------------------------------------");
	endfunction
endclass
