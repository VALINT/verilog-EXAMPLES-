/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  ALU tb
//  One writing port and two reading ports.
//
//  Author      : VAL
//  Written    : 28 Feb 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module alu_tb();

parameter WordWidth = 32;

parameter AND       = 3'b000;
parameter OR        = 3'b001;
parameter ADD       = 3'b010;
parameter SUB       = 3'b110;

    reg     [WordWidth-1:0]     operandA;
    reg     [WordWidth-1:0]     operandB;
    reg     [2:0]               operALU;
    wire                        zero;
    reg                         carry_in;
    wire                        carry_out;
    wire    [WordWidth-1:0]     result;

    param_ALU #(
        .OperandWidth(WordWidth)
    )
    ALU(
        .operandA(operandA),
        .operandB(operandB),
        .operALU(operALU),
        .zero(zero),
        .carry_in(carry_in),
        .carry_out(carry_out),
        .result(result)
    );

    initial begin
        operandA = 0;
        operandB = 0;
        operALU  = 0;
        carry_in = 0;

        #1000;

        operandA = 50;
        operandB = 4;
        operALU  = 0;

        #1000;

        operandA = 6;
        operandB = 40;
        operALU  = 1;

        #1000;

        operandA = 10;
        operandB = 20;
        operALU  = 6;

        #1000;

        operandA = 0;
        operandB = 0;
        operALU  = 0;

        #1000;

        operandA = 0;
        operandB = 0;
        operALU  = 0;

        #1000;

        operandA = 0;
        operandB = 0;
        operALU  = 0;

        #1000;

        operandA = 0;
        operandB = 0;
        operALU  = 0;

        #1000;

        operandA = 0;
        operandB = 0;
        operALU  = 0;

        #1000;

        operandA = 0;
        operandB = 0;
        operALU  = 0;

        #1000;

        operandA = 0;
        operandB = 0;
        operALU  = 0;

        #1000;

        operandA = 0;
        operandB = 0;
        operALU  = 0;

        #1000;

        operandA = 0;
        operandB = 0;
        operALU  = 0;

        #1000;

        operandA = 0;
        operandB = 0;
        operALU  = 0;

        #1000;

        operandA = 0;
        operandB = 0;
        operALU  = 0;

        $stop;
    end



endmodule