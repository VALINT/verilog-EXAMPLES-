/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Instruction memory (ROM) for my MIPS32 implementation
//  Parametrized word width 
//
//  Author      : VAL
//  Written    : 28 Feb 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module InstructionMemory(
    Address,
    RData,
    ReEn
);

parameter DataWidth     = 32;
parameter AmountOfWords = 1;
parameter AddrBusWidth  = $clog2(AmountOfWords);

    input           [AddrBusWidth-1:0]  Address;
    input                               ReEn;

    output wire     [DataWidth-1:0]     RData;

    reg             [7:0]               ROM [AmountOfWords-1:0];

    assign RData = ReEn ? {ROM[Address+0],ROM[Address+1],ROM[Address+2],ROM[Address+3]} : 0;

endmodule