/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Register file
//  One writing port and two reading ports.
//           
//           __________
//   RAddr1 | register | RData1
//    ----->|   file   |------>
//   RAddr2 |          |
//    ----->|          | RData2
//   WAddr  |          |------>
//    ----->|          |
//   WData  |          |
//    ----->|          |
//          |__________|
//          
//
//  Author      : VAL
//  Written    : 27 Feb 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module param_RegFile(
    RAddr1,
    RAddr2,
    WAddr,
    WrEn,
    RData1,
    RData2,
    WData,
    rstb,
    clk
);

parameter   WordWidth       = 32;
parameter   WordsAmount    = 32;
parameter   ZeroSellIsZero  = 1;

parameter   AddrWidth       = $clog2(WordsAmount);

input           [AddrWidth-1:0]     RAddr1;
input           [AddrWidth-1:0]     RAddr2;
input           [AddrWidth-1:0]     WAddr;
input           [WordWidth-1:0]     WData;
input                               WrEn;
input                               rstb;
input                               clk;

output wire     [WordWidth-1:0]     RData1;
output wire     [WordWidth-1:0]     RData2;

reg [WordWidth-1:0] RegFile [WordsAmount-1:0];

integer i = 0;

assign  RData1 = (ZeroSellIsZero && !RAddr1) ?  0 : RegFile[RAddr1];
assign  RData2 = (ZeroSellIsZero && !RAddr2) ?  0 : RegFile[RAddr2];

always @ (posedge clk or negedge rstb)
begin
    if(!rstb)
    begin
        for(i = (1<<AddrWidth); i > 0; i = i-1)
            RegFile[i] <= 0;
    end
    else
    begin
        if(WrEn)
        begin
            RegFile[WAddr] <= WData;
        end
    end
end

endmodule