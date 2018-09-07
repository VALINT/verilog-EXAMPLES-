///////////////////////////////////////////////////////////////////
//	Jul 30 2018
//	ALU
//	by VAL
////////////////////////////////////////////////////////////////////////

module alu(
    OperandA,
    OperandB,
    Operation,
    CarryIn,
    CarryOut,
    Answer);

    parameter width = 4;

    input       [width-1:0] OperandA;
    input       [width-1:0] OperandB;
    input       [2:0]       Operation;
    input                   CarryIn;
    output reg              CarryOut;
    output reg  [width-1:0] Answer;

    always @ *
    begin
        case(Operation)
            3'b001  :   {CarryOut,Answer} = OperandA + OperandB + CarryIn;
            3'b010  :   {CarryOut,Answer} = OperandA - OperandB - CarryIn;
            3'b101  :   Answer = OperandA & OperandB;
            3'b110  :   Answer = OperandA | OperandB;
            3'b111  :   Answer = OperandA ^ OperandB;
            default :   {CarryOut,Answer} = 5'h00;
        endcase
    end


endmodule