/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Control unit for my MIPS32 SC implementation
//  
//
//  Author     : VAL
//  Written    : 05 Mar 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module control_unit(
    Instruction,
    RegDst,
    Branch,
    MemRead,
    MemToReg,
    MemWrite,
    ALUSrc,
    RegWrt,
    ALUOp
);

    input       [5:0]   Instruction;

    output              RegDst;
    output              Branch;
    output              MemRead;
    output              MemToReg;
    output              MemWrite;
    output              ALUSrc;
    output              RegWrt;
    output      [2:0]   ALUOp;

endmodule