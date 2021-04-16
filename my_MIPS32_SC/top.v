/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Top layout for My_MIPS32_SC Implementation
//  
//
//  Author      : VAL
//  Written     : 02 Mar 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ns

module top();

    reg         clk;
    reg         rstb;

    wire   [31:0]       Instruction;
    wire   [31:0]       DataInput;
    wire   [31:0]       InsAddr;
    wire   [31:0]       DatAddr;
    wire                ReEnIns;
    wire                ReEnDat;
    wire                WrEnDat;
    wire   [31:0]       DataOut;

    wire   [7:0]        InstrAddrWrapper;
    wire   [7:0]        DataAddrWrapper;

    assign  InstrAddrWrapper =  InsAddr[7:0];
    assign  DataAddrWrapper =  DataInput[7:0];

    MIPS32_SC MIPS(
        .Instruction(Instruction),
        .DataInput(DataInput),
        .InsAddr(InsAddr),
        .DatAddr(DatAddr),
        .ReEnIns(ReEnIns),
        .ReEnDat(ReEnDat),
        .WrEnDat(WrEnDat),
        .DataOut(DataOut),
        .rstb(rstb),
        .clk(clk)
    );

    InstructionMemory #(
        .DataWidth(32),
        .AmountOfWords(256)
    ) 
    IMEM(
        .Address(InstrAddrWrapper),
        .RData(Instruction),
        .ReEn(1'b1)
    );

    DataMemory #(
        .DataWidth(32),
        .AmountOfWords(256)
    )  
    DMEM(
        .Address(DataAddrWrapper),
        .WData(DataOut),
        .WrEn(WrEnDat),
        .ReEn(1'b1),
        .clk(clk),
        .rstb(rstb),
        .RData(DataInput)
);

initial begin
    $readmemh("program.txt", IMEM.ROM);
    rstb = 0;
    #100;
    force MIPS.PCControl = 1'b0;
    //force MIPS.RegFile.RegFile[10] = 32'd10;
    //force MIPS.RegFile.RegFile[11] = 32'd20;
    //force MIPS.RegDest = 1'b1;
    //force MIPS.MemToReg = 1'b0;
    //force MIPS.ALUSrc = 1'b0;
    rstb = 1;
    clk =  0;

    forever #10 clk = ~clk; 
end

initial begin
    #10000;
    $stop;
end

endmodule