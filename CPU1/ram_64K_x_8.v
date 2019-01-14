/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  RAM 64K x 8 bits
//
//  Autor:  VAL
//  Wrired: 08 Jan 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ram_64K_x_8(
    address,
    data,
    clk,
    wr_e,
    re_e,
    o_en
);

    input   [15:0]  address;
    input           clk;
    input           wr_e;
    input           re_e;
    input           o_en;

    inout   [7:0]   data;

    reg     [7:0] ram [65535:0];
    reg     [7:0] data_out;

    assign data = o_en ? data_out : 8'bZ;

    always @ (posedge clk)
    begin : mem
    if(clk)
        if (wr_e)
            ram[address] = data;
    end

    always @ (*)
    begin 
        if(re_e)
            data_out = ram[address];
        else data_out = 8'bZ;
    end

endmodule
