///////////////////////////////////////////////////////////////////
//	Jul 30 2018
//	Testbench fot ALU
//	by VAL
////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module alu_tb ();

    integer a;
    integer b;
    integer c;

    reg     [3:0]   OperandA;
    reg     [3:0]   OperandB;
    reg     [2:0]   Operation;
    reg             CarryIn;

    alu DUT(
        .OperandA(OperandA),
        .OperandB(OperandB),
        .Operation(Operation),
        .CarryIn(0)
    );

    initial begin
        for(a = 0; a < 8; a= a + 1) 
            for(b = 0; b < 16; b= b + 1)
                for(c = 0; c < 16; c= c + 1)
                begin
                    #10;
                    OperandA = b;
                    OperandB = c;
                    Operation = a;
                end
    end

    initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end

endmodule