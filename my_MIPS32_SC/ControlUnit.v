/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Control unit for my MIPS32 SC implementation
//  
//
//  Author     : VAL
//  Written    : 05 Mar 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module control_unit(
    opcode,
    RegDst,
    Branch,
    MemRead,
    MemToReg,
    MemWrite,
    ALUSrc,
    RegWrt,
    ALUOp
);

    input           [5:0]   opcode;

    output reg              RegDst;
    output reg              Branch;
    output reg              MemRead;
    output reg              MemToReg;
    output reg              MemWrite;
    output reg              ALUSrc;
    output reg              RegWrt;
    output reg      [1:0]   ALUOp;

    always @ *
    begin
        casex(opcode)
            6'b000000   :   begin
                RegDst      = 1'b1;
                ALUSrc      = 1'b0;
                MemToReg    = 1'b0;
                RegWrt      = 1'b1;
                MemRead     = 1'b0;
                MemWrite    = 1'b0;
                Branch      = 1'b0;
                ALUOp       = 2'b10;
            end
            6'b001xxx   :   begin
                RegDst      = 1'b0;
                ALUSrc      = 1'b1;
                MemToReg    = 1'b0;
                RegWrt      = 1'b1;
                MemRead     = 1'b0;
                MemWrite    = 1'b0;
                Branch      = 1'b0;
                ALUOp       = 2'b00;
            end
        endcase
    end

endmodule