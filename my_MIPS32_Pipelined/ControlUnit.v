/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Control unit for my MIPS32_PPL implementation
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
    ALUOp,
  	Jump
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
  	output reg				Jump;

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
                Jump		= 1'b0;
            end
          	6'b000010   :   begin
                RegDst      = 1'b0;
                ALUSrc      = 1'b0;
                MemToReg    = 1'b0;
                RegWrt      = 1'b0;
                MemRead     = 1'b0;
                MemWrite    = 1'b0;
                Branch      = 1'b0;
                ALUOp       = 2'b00;
                Jump		= 1'b1;
            end
          	6'b0001xx   :   begin
                RegDst      = 1'b0;
                ALUSrc      = 1'b0;
                MemToReg    = 1'b0;
                RegWrt      = 1'b0;
                MemRead     = 1'b0;
                MemWrite    = 1'b0;
                Branch      = 1'b1;
                ALUOp       = 2'b01;
                Jump		= 1'b0;
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
              	Jump		= 1'b0;
            end
         	6'b101xxx   :   begin
                RegDst      = 1'b0;
                ALUSrc      = 1'b1;
                MemToReg    = 1'b0;
                RegWrt      = 1'b0;
                MemRead     = 1'b0;
                MemWrite    = 1'b1;
                Branch      = 1'b0;
                ALUOp       = 2'b00;
              	Jump		= 1'b0;
            end
          	6'b100xxx   :   begin
                RegDst      = 1'b0;
                ALUSrc      = 1'b1;
                MemToReg    = 1'b1;
                RegWrt      = 1'b1;
                MemRead     = 1'b1;
                MemWrite    = 1'b0;
                Branch      = 1'b0;
                ALUOp       = 2'b00;
              	Jump		= 1'b0;
            end
        endcase
    end

endmodule