///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Behavioral ALU
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

`include "accumulator.v"
`include "adder_16.v"
`include "and_16.v"
`include "divider_16x16.v"
`include "multiplexer_16_4.v"
`include "multiplier_16x16.v"
`include "not_16.v"
`include "or_16.v"
`include "subtractor_16.v"
`include "xor_16.v"

module b_ALU(clk, rstb, opcode, dp_input, dp_output, status_out);

output wire [31:0]  dp_output;
output wire         status_out;

input       [15:0]  dp_input;
input       [3:0]   opcode;
input               clk;
input               rstb;

wire        [31:0]  acc_out;
wire                carry_in;
wire				sub_b;
wire				add_c;
wire                carry_out;
wire        [15:0]  sub_res;
wire        [15:0]  add_res;
wire        [15:0]  div_res;
wire        [31:0]  mul_res;
wire        [15:0]  and_res;
wire        [15:0]  or_res;
wire        [15:0]  not_res;
wire        [15:0]  xor_res;
wire        [31:0]  mux_out;

reg                 status_c;
wire                status_c_we;

  assign carry_out = (sub_b && (opcode[2] && !opcode[1])) | (add_c && (opcode[2] && opcode[1]));
assign dp_output = acc_out;
assign status_c_we = !opcode[3] && opcode[2];
assign carry_in = (!opcode[3] && opcode[2] && opcode[0])? status_c : 'b0;
assign status_out = status_c;

  always @(posedge clk or negedge rstb) 
begin
    if(!rstb)
        status_c <= 0;
    else if(status_c_we)
        status_c <= carry_out;
end

subtractor_16 SUBT(
    .b(dp_input),
    .a(acc_out[15:0]),
    .bin(carry_in),
    .out(sub_res),
  .bout(sub_b)
);

adder_16 SUB(
    .b(dp_input),
    .a(acc_out[15:0]),
    .cin(carry_in),
    .out(add_res),
  .cout(add_c)
);

multiplier_16x16 MUL(
    .b(dp_input), 
    .a(acc_out[15:0]), 
    .out(mul_res)
);

divider_16 DIV(
    .b(dp_input), 
    .a(acc_out[15:0]), 
    .out(div_res)
);

and_16 AND(
    .b(dp_input), 
    .a(acc_out[15:0]), 
    .out(and_res)
);

or_16 OR(
    .b(dp_input), 
    .a(acc_out[15:0]), 
    .out(or_res)
);

not_16 NOT(
    .a(dp_input),  
    .out(not_res)
);

xor_16 XOR(
    .b(dp_input), 
    .a(acc_out[15:0]), 
    .out(xor_res)
);

multiplexer_16_4 MUX(
    .mux_address(opcode),
    .mux_input_0(acc_out[31:0]),
  	.mux_input_1(32'h00000000),
  	.mux_input_2(32'hFFFFFFFF),
  	.mux_input_3({16'h0000, div_res}),
  	.mux_input_4({16'h0000, sub_res}),
  	.mux_input_5({16'h0000, sub_res}),
  	.mux_input_6({16'h0000, add_res}),
 	.mux_input_7({16'h0000, add_res}),
    .mux_input_8(mul_res),
  	.mux_input_9({16'h0000, and_res}),
  	.mux_input_10({16'h0000, or_res}),
  	.mux_input_11({16'h0000, not_res}),
  	.mux_input_12({16'h0000, xor_res}),
    .mux_output(mux_out)
);

accumulator ACC(
    .in(mux_out),
    .clk(clk),
    .rstb(rstb),
    .out(acc_out)
);

endmodule