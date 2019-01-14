/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Add and Accumalate testbench
//
//  Autor:  VAL
//  Wrired: 07 Jan 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale  1ns/1ns

module AAA_tb();

    
    reg             clk;
    reg             clr;
    reg             en;
    reg             rst;
    reg             carry_in;

    reg     [7:0]   termA;
    
    wire            carry_out;
    wire    [7:0]   DataIn;
    wire    [7:0]   DataOut;

    adder DUT_adder(
        .termA(termA),
        .termB(DataOut),
        .carry_in(carry_in),
        .carry_out(carry_out),
        .sum(DataIn)
    );

    accumulator DUT_acc(
        .DataIn(DataIn),
        .DataOut(DataOut),
        .en(en),
        .clk(clk),
        .clr(clr),
        .rst(rst)
    );

    initial begin
        rst = 0;
        clk = 0;
        clr = 0;
        en = 0;
        carry_in = 0;
      // DataIn = 0;
       // DataOut = 0;

        #100;
        rst = 1;
        #100;
        rst = 0;
        forever clk = #5 ~clk;
    end

    initial begin
        #300;
        termA = 8'h03;
        #50 en = 1;
        #50 en = 0;
        #50 clr = 1;
        #50 clr = 0;
        #500;
        $finish;
    end

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end

endmodule