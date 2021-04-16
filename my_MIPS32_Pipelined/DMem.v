/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Data memory (RAM) for my MIPS32 implementation
//  Parametrized word width 
//
//  Author      : VAL
//  Written    : 28 Feb 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module DataMemory(
    Address,
    WData,
    WrEn,
    ReEn,
    clk,
    rstb,
    RData
);

parameter DataWidth     = 32;
parameter AmountOfWords = 1;
parameter AddrBusWidth  = $clog2(AmountOfWords);

    input           [AddrBusWidth-1:0]  Address;
    input           [DataWidth-1:0]     WData;
    input                               WrEn;
    input                               rstb;
    input                               clk;
    input                               ReEn;

    output wire     [DataWidth-1:0]     RData;

    reg             [7:0]               RAM [AmountOfWords-1:0];

    integer i = 0;

    assign RData = ReEn ? {RAM[Address],RAM[Address+1],RAM[Address+2],RAM[Address+3]} : 0;

    always @ (posedge clk or negedge rstb)
    begin
        if(!rstb)
        begin
            for(i = AmountOfWords; i > 0; i = i - 1)
                RAM[i] <= 0;
                RAM[0] <= 0;
        end
        else
        begin
            if(WrEn)
            begin
              RAM[Address+3] <= WData[7:0];
              RAM[Address+2] <= WData[15:8];
              RAM[Address+1] <= WData[23:16];
              RAM[Address+0] <= WData[31:24];
            end
        end
    end

endmodule
