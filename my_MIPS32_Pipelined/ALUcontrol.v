/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  ALU control unit for my MIPS32 implementation
//  
//
//  Author     : VAL
//  Written    : 11 Mar 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ALU_control_unit(
    func,
    ALUOp,
    operALU
);

    input           [5:0]   func;
    input           [1:0]   ALUOp;

  	output reg      [3:0]   operALU;
    
    always @ *
    begin
        casex(ALUOp)
            2'b00   :   operALU = 4'b0010;
            2'b01   :   operALU = 4'b0110;
            2'b1x   :   begin
                casex(func)
                    6'bxx0000   :   operALU = 4'b0010;
                    6'bxx0010   :   operALU = 4'b0110;
                    6'bxx0100   :   operALU = 4'b0000;
                    6'bxx0101   :   operALU = 4'b0001;
                    6'bxx1010   :   operALU = 4'b0111;
                endcase end
        endcase
    end

endmodule