/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  My MIPS32 implementation
//  Single clock
//
//  Author      : VAL
//  Written    : 28 Feb 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module MIPS32_SC(
    Instruction,
    DataInput,
    InsAddr,
    DatAddr,
    ReEnIns,
    ReEnDat,
    WrEnDat,
    DataOut,
    rstb,
    clk
);

    input           [31:0]  Instruction;
    input           [31:0]  DataInput;
    input                   clk;
    input                   rstb;

    output wire     [31:0]  InsAddr;
    output wire     [31:0]  DatAddr;
    output wire             ReEnIns;
    output wire             ReEnDat;
    output wire             WrEnDat;
    output wire     [31:0]  DataOut;

    reg             [31:0]  PC;
    wire            [31:0]  PCNext;
    wire                    PCControl;
    wire                    RegDest;
    wire                    MemToReg; 
    wire                    ALUSrc;   
    wire            [31:0]  SgExtImm;
    wire            [31:0]  Result;
    

    assign InsAddr = PC;
    assign PCNext  = PCControl ? PC + 32'd4 + {SgExtImm[29:0],2'b00} : PC + 32'd4;

    wire            [4:0]   rsReg;
    wire            [4:0]   rtReg;
    wire            [4:0]   rdReg;
    wire            [31:0]  WData;
    wire                    WrEn;
    wire            [31:0]  Data1;
    wire            [31:0]  Data2; 


    assign rsReg = Instruction[25:21];
    assign rtReg = Instruction[20:16];
    assign rdReg = RegDest ? Instruction[15:11] : Instruction[20:16];
    assign WData = MemToReg ? DataInput : Result;

    param_RegFile RegFile(
        .clk(clk),
        .rstb(rstb),
        .RAddr1(rsReg),
        .RAddr2(rtReg),
        .WAddr(rdReg),
        .WrEn(WrEn),
        .RData1(Data1),
        .RData2(Data2),
        .WData(WData)
    );

    wire            [31:0]  OperandA;
    wire            [31:0]  OperandB;
    wire            [2:0]   OperALU;   
    wire                    Zero;
    wire                    CarryIn;
    wire                    CarryOut;
    wire            [15:0]  Immediate;

    assign Immediate = Instruction[15:0];
    assign SgExtImm = Immediate[15] ? {16'hffff,Immediate} : {16'h0000,Immediate};
    assign OperandA = Data1;
    assign OperandB = ALUSrc ? SgExtImm : Data2;

    param_ALU ALU(
        .operandA(OperandA),
        .operandB(OperandB),
        .operALU(OperALU),
        .result(Result),
        .zero(Zero),
        .carry_in(CarryIn),
        .carry_out(CarryOut)
    );

    assign DatAddr = Result;
    assign DataOut = Data2;

    always @ (posedge clk or negedge rstb)
    begin   :   ProgramCounter
        if(!rstb)
        begin
            PC <= 32'd0;
        end
        else
        begin
            PC <= PCNext;
        end
    end

endmodule