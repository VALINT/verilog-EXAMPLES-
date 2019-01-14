/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Accumulator for CPU1
//
//  Autor:  VAL
//  Wrired: 07 Jan 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module accumulator (
    DataIn,
    DataOut,
    en,
    clr,
    clk,
    rst
    );

    input       [7:0]   DataIn;
    input               en;
    input               clk;
    input               clr;
    input               rst;

    output reg [7:0]    DataOut;

    always @ (posedge clk or posedge rst)
    begin
        if(rst)
        begin
            DataOut <= 8'h00;
        end
        else
        begin
            if(clr)
            begin
                DataOut <= 8'h00;
            end
            else if(en)
            begin
                DataOut <= DataIn;
            end
        end
    end

endmodule