///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 16-bits multiplexer with 4-bits address input
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
module multiplexer_16_4(mux_address, 
        mux_input_0, 
        mux_input_1,
        mux_input_2,
        mux_input_3,
        mux_input_4,
        mux_input_5,
        mux_input_6,
        mux_input_7,
        mux_input_8,
        mux_input_9,
        mux_input_10,
        mux_input_11,
        mux_input_12,
        mux_output);

output reg  [31:0]  mux_output;

input   [31:0]  mux_input_0;
input   [31:0]  mux_input_1;
input   [31:0]  mux_input_2;
input   [31:0]  mux_input_3;
input   [31:0]  mux_input_4;
input   [31:0]  mux_input_5;
input   [31:0]  mux_input_6;
input   [31:0]  mux_input_7;
input   [31:0]  mux_input_8;
input   [31:0]  mux_input_9;
input   [31:0]  mux_input_10;
input   [31:0]  mux_input_11;
input   [31:0]  mux_input_12;
input   [3:0]   mux_address;

always @(*) 
begin
    case (mux_address)
        default: mux_output = mux_input_0;
        1:  mux_output = mux_input_1;
        2:  mux_output = mux_input_2;
        3:  mux_output = mux_input_3;
        4:  mux_output = mux_input_4;
        5:  mux_output = mux_input_5;
        6:  mux_output = mux_input_6;
        7:  mux_output = mux_input_7;
        8:  mux_output = mux_input_8;
        9:  mux_output = mux_input_9;
        10: mux_output = mux_input_10;
        11: mux_output = mux_input_11;
        12: mux_output = mux_input_12;
    endcase
end

endmodule