/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  CPU tb
//
//  Author  : VAL
//  Wrote   : 17 Jan 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ns

module cpu_tb();
    wire            wr_e;
    wire            re_e;
    wire            o_en;
    reg             clk;
    reg             rst;
    wire            res_o;
    wire    [7:0]   data;
    wire    [15:0]  address;

    cpu_top CPU(
        .clk(clk),
        .reset(rst),
        .res_o(res_o),
        .data(data),
        .address(address),
        .wr_e(wr_e),
        .re_e(re_e),
        .o_en(o_en)
    );

    ram_64K_x_8 MEM(
        .data(data), 
        .clk(clk), 
        .rst(res_o),
        .o_en(o_en),  
        .address(address), 
        .re_e(re_e), 
        .wr_e(wr_e)
    );

    initial 
    begin
    #20;
    $readmemh("memory_64K.txt", MEM.ram);
    end

    initial
    begin
        rst = 1;
        clk = 0;
        #10;
        rst = 0;
        #50;
        forever #10 clk = ~clk;
    end


    initial
    begin
        #5000;
        $stop;
    end

    initial
	begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end

endmodule
