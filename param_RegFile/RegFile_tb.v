/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Register file testbench
//  One writing port and two reading ports.
//
//  Author      : VAL
//  Written    : 27 Feb 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ns

module RegFile_tb();

    parameter  WordWidth    = 32;
    parameter  WordsAmount  = 32;
    parameter  AddrWidth    = $clog2(WordsAmount);

    reg                         clk;
    reg                         rstb;
    reg     [WordWidth-1:0]     WData;
    reg     [AddrWidth-1:0]     RAddr1;
    reg     [AddrWidth-1:0]     RAddr2;
    reg     [AddrWidth-1:0]     WAddr;
    reg                         WrEn;

    wire    [WordWidth-1:0]     RData1;
    wire    [WordWidth-1:0]     RData2;

    param_RegFile #(
        .WordWidth(32),
        .WordsAmount(32),
        .ZeroSellIsZero(1))
    RegFile(
        .clk(clk),
        .rstb(rstb),
        .WData(WData),
        .RAddr1(RAddr1),
        .RAddr2(RAddr2),
        .WAddr(WAddr),
        .WrEn(WrEn),
        .RData1(RData1),
        .RData2(RData2)
    );

    initial begin
        clk  = 0'b0;
        forever #5 clk = ~ clk;
    end

    initial begin
        rstb = 1'b0;
        #10;
        rstb = 1'b1;

        RAddr1 = 5'b00000;
        RAddr2 = 5'b00001;

        #100;

        WAddr = 5'b00001;
        WData = 32'h00001010;
        WrEn = 1'b1;

        #20;

        WAddr = 5'b00000;
        WData = 32'h00001010;

        #20;

        WrEn = 1'b0;
        #500;
        $stop;
    end

endmodule