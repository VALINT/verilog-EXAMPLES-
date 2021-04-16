/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  ALU
//  One writing port and two reading ports.
//
//  Author      : VAL
//  Written    : 28 Feb 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module param_ALU(
    operandA,
    operandB,
    operALU,
    result,
    zero,
    carry_in,
    carry_out
);

parameter   OperandWidth = 32;

    input       [OperandWidth-1:0]  operandA;
    input       [OperandWidth-1:0]  operandB;
    input       [2:0]               operALU;
    input                           carry_in;

    output wire [OperandWidth-1:0]  result;
    output wire                     zero;
    output wire                     carry_out;

    wire        [OperandWidth-1:0]  opA;
    wire        [OperandWidth-1:0]  opB;
    wire        [OperandWidth-1:0]  sum;
    wire                            carry;
    

    adder #(
        .OperandWidth(OperandWidth)
    )
    ALU_Adder(
        .operandA(opA),
        .operandB(opB),
        .sum(sum),
        .carry_in(carry),
        .carry_out(carry_out)
    );

    assign zero = !sum ? 1'b1 : 1'b0;
    assign result = (operALU == 3'b001) ? opA | opB : (operALU == 3'b010) ? sum : (operALU == 3'b110) ? sum : (operALU == 3'b111) ? opB : opA & opB;
    assign opA = operandA;
    assign opB = operALU[2] ? ~operandB : operandB;
    assign carry = operALU[2] ? !carry_in : carry_in;

endmodule