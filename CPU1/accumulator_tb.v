/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Accumulator testbench
//
//  Autor:  VAL
//  Wrired: 07 Jan 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale  1ns/1ns

module accumulator_tb();

    reg     [7:0]   DataIn;
    reg             clk;
    reg             clr;
    reg             en;
    reg             rst;

    wire    [7:0]   DataOut;

    accumulator DUT(
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
        DataIn = 0;
       // DataOut = 0;

        #100;
        rst = 1;
        #100;
        rst = 0;
        forever clk = #5 ~clk;
    end

    initial begin
        #300;
        DataIn = 8'ha4;
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