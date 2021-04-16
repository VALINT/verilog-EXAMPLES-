/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  My MIPS32 implementation
//  Pipeline
//
//  Author      : VAL
//  Written    : 28 Feb 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

//`include "param_RegFile.v"
//`include "paramALU.v"
//`include "ControlUnit.v"
//`include "ALUcontrol.v"
//`include "ForwardControl.v"

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

    wire                    MemToReg;   
  	wire					Jump;
  	wire			[31:0]	JumpAddr;
  	wire            [31:0]  BranchAddres;
  
    wire           	     	Branch;

  	reg				[70:0]	IF_to_ID;
  	reg				[156:0]	ID_to_EX;
  	reg				[7:0]	CSID_to_EX;
  	reg				[114:0]	EX_to_MEM;
  	reg				[70:0]	MEM_to_WB;
	
	wire					IFRegControl;
	wire					NOPControl;
	

//-----------------------------------------------------------------------------------------------------  
// Instruction fetch part
  
  	wire			[31:0]	inc_addr;		// Actual address + 4;
  
    assign InsAddr = PC;
  	assign JumpAddr = {4'b0000,Instruction[25:0],2'b00};

  	assign inc_addr = PC + 32'd4;
  	//assign PCNext  = Jump ? JumpAddr : (Branch & Zero  ? BranchAddres : inc_addr);
  	assign PCNext = inc_addr;
  
    always @ (posedge clk or negedge rstb)
    begin   :   Pipeline_IF
        if(!rstb)
        begin
            IF_to_ID <= 71'd0;
        end
        else
        begin
			if(IFRegControl)
				IF_to_ID <= {7'd0,inc_addr,Instruction};
        end
    end
  
    always @ (posedge clk or negedge rstb)
    begin   :   ProgramCounter
        if(!rstb)
        begin
            PC <= 32'd0;
        end
        else
        begin
			if(IFRegControl)
				PC <= PCNext;
        end
    end
//----------------------------------------------------------------------------------------------------- 
// Instruction decode part
  
  	wire            [15:0]  Immediate_ID;
  	wire            [4:0]   rsReg_ID;
  	wire            [4:0]   rtReg_ID;
  	wire            [4:0]   rdReg_ID;
  	wire            [31:0]  WData_ID;
    wire                    WrEnReg_ID;
  	wire            [31:0]  Data1_ID;
  	wire            [31:0]  Data2_ID; 
  	wire            [31:0]  SgExtImm_ID;
    wire                    ALUSrc_ID;
  	wire        	[5:0]   opcode_ID;
  	wire        	[5:0]   func_ID;
    wire                    RegDest_ID;
  	wire			[31:0]	Instruction_ID;
  	wire			[31:0]	inc_addr_ID;
  	wire        	[1:0]   ALUOp_ID;
  	wire					WrEnDat_ID;
  	wire					ReEnDat_ID;
  	reg				[4:0]	RS_to_ID;
  
  	wire			[4:0]	RegFWAddr;
  	wire			[31:0]	RegFWData;

  	assign inc_addr_ID = IF_to_ID[63:32];
  	assign Instruction_ID = IF_to_ID[31:0];
  	assign rdReg_ID = Instruction_ID[15:11];
    assign rsReg_ID = Instruction_ID[25:21];
    assign rtReg_ID = Instruction_ID[20:16];
  	assign Immediate_ID = Instruction_ID[15:0];
    assign SgExtImm_ID = Immediate_ID[15] ? {16'hffff,Immediate_ID} : {16'h0000,Immediate_ID};
    
   	// assign WData_ID = MemToReg ? DataInput : Result;		//Assigned in Instruction exeqution part;

    assign  opcode_ID  = Instruction_ID[31:26];
    assign  func_ID    = Instruction_ID[5:0];

    control_unit CU(
        .opcode(opcode_ID),
        .RegDst(RegDest_ID),
        .Branch(Branch),
        .MemRead(ReEnDat_ID),
        .MemToReg(MemToReg),
        .MemWrite(WrEnDat_ID),
        .ALUSrc(ALUSrc_ID),
        .RegWrt(WrEnReg_ID),
      	.ALUOp(ALUOp_ID),
      	.Jump(Jump)
    );

    param_RegFile RegFile(
        .clk(clk),
        .rstb(rstb),
        .RAddr1(rsReg_ID),
        .RAddr2(rtReg_ID),
        .WAddr(RegFWAddr),
        .WrEn(WrEn_ID),
        .RData1(Data1_ID),
        .RData2(Data2_ID),
        .WData(RegFWData)
    );
  
    always @ (posedge clk or negedge rstb)
    begin   :   Pipeline_ID
        if(!rstb)
        begin
          CSID_to_EX <= 8'd0;
			ID_to_EX <= 157'd0;
        end
        else
        begin
          RS_to_ID <= rsReg_ID;
          CSID_to_EX <= {Branch,ReEnDat_ID,MemToReg,WrEnReg_ID,WrEnDat_ID,ALUSrc_ID,Jump};
			if(!NOPControl)
				ID_to_EX <= {Branch,ReEnDat_ID,MemToReg,WrEnReg_ID,WrEnDat_ID,ALUSrc_ID,ALUOp_ID,Jump,RegDest_ID,func_ID,inc_addr_ID,Data1_ID,Data2_ID,SgExtImm_ID,Instruction_ID[20:16],Instruction_ID[15:11]};
			else
				ID_to_EX <= {2'b00,MemToReg,2'b00,ALUSrc_ID,ALUOp_ID,1'b0,RegDest_ID,func_ID,inc_addr_ID,Data1_ID,Data2_ID,SgExtImm_ID,Instruction_ID[20:16],Instruction_ID[15:11]};
	   end
    end
//----------------------------------------------------------------------------------------------------- 
// Instruction exequte part
  	wire            [31:0]  OperandA_EX;
  	wire            [31:0]  OperandB_EX;
  	wire            [3:0]   OperALU_EX;   
  	wire            [31:0]  Data1_EX;
  	wire            [31:0]  Data2_EX;
  	wire            [31:0]  SgExtImm_EX;
  	wire			[5:0]	func_EX;
  	wire        	[1:0]   ALUOp_EX;
    wire                    ALUSrc_EX;
    wire                    CarryIn;
    wire                    CarryOut;
  	wire					RegDest_Ex;
 	wire			[4:0]	rdReg_EX;
  	wire			[31:0]	inc_addr_EX;
  	wire			[31:0]	BranchAddres_EX;
    wire                    Zero_EX;  
  	wire            [31:0]  Result_EX;
  	wire			[31:0]  DataOut_EX;
  	wire			[31:0]	DataAddr_EX;
  	wire					MemToReg_EX;
 	wire					WrEnReg_EX;
 	wire					ReEnDat_EX;
  	wire			[1:0]	OperAFwrd;
  	wire			[1:0]	OperBFwrd;
  	wire			[31:0]	OpAAftFwrd;
  	wire			[31:0]	OpBAftFwrd;
  	wire					WrEnDat_EX;
	
  	assign ReEnDat_EX = ID_to_EX[151];
  	assign MemToReg_EX = ID_to_EX[151];
  	assign WrEnReg_EX = ID_to_EX[150];
  	assign WrEnDat_EX = ID_to_EX[149];
  	assign ALUSrc_EX = ID_to_EX[148];
  	assign ALUOp_EX = ID_to_EX[147:146];
  	assign RegDest_EX = ID_to_EX[144];
  	assign func_EX = ID_to_EX[143:138];
  	assign inc_addr_EX = ID_to_EX[137:106];
  	assign Data1_EX = ID_to_EX[105:74];
  	assign Data2_EX = ID_to_EX[73:42];
  	assign SgExtImm_EX = ID_to_EX[41:10];
  	assign rdReg_EX = RegDest_EX ? ID_to_EX[4:0] : ID_to_EX[9:5];
	assign OperandA_EX = Data1_EX;
    assign OperandB_EX = ALUSrc_EX ? SgExtImm_EX : OpBAftFwrd;
    assign BranchAddres_EX = inc_addr_EX + {SgExtImm_EX[29:0],2'b00};
      
  	//Maybe del//assign WData_ID = MemToReg_EX ? DataInput : Result_EX;					// Assign special for Instruction Detect part;
  
    ALU_control_unit ALU_CU(
        .func(func_EX),   
        .ALUOp(ALUOp_EX),
        .operALU(OperALU_EX)     
    );
  
 	param_ALU ALU(
        .operandA(OpAAftFwrd),
      	.operandB(OperandB_EX),
        .operALU(OperALU_EX),
        .result(Result_EX),
        .zero(Zero_EX),
        .carry_in(1'b0),
      	.carry_out(CarryOut),
      	.overflow(overflow)
    );  
  
  	assign overflow = CarryOut;
    assign DataAddr_EX = Result_EX;
  
    always @ (posedge clk or negedge rstb)
    begin   :   Pipeline_EX
        if(!rstb)
        begin
			EX_to_MEM <= 115'd0;
        end
        else
        begin
          EX_to_MEM <= {ID_to_EX[4:0],ID_to_EX[9:5],WrEnDat_EX,ID_to_EX[155],ID_to_EX[152],MemToReg_EX,WrEnReg_EX,Zero_EX,BranchAddres_EX,DataAddr_EX,DataOut_EX,rdReg_EX};
        end
    end
//----------------------------------------------------------------------------------------------------- 
// Work with memory part
  
  	wire			[4:0]	rdReg_MEM;
  	wire			[31:0]	wrData_MEM;
  	wire			[31:0]	readAddr_MEM;
  	wire			[31:0]	readData_MEM;
  	wire					MemToReg_MEM;
  	wire					WrEnReg_MEM;
  
  	assign	rdReg_MEM = EX_to_MEM[4:0];
  	assign  wrData_MEM = EX_to_MEM[36:5];
  	assign	readAddr_MEM = EX_to_MEM[68:37];
  	assign	MemToReg_MEM = EX_to_MEM[103];
  	assign	WrEnReg_MEM = EX_to_MEM[102];
  
  	assign	readData_MEM = DataInput;
  	assign  DatAddr = readAddr_MEM;
  	assign  ReEnDat = EX_to_MEM[105];
  	assign  WrEnDat = EX_to_MEM[106];
    assign  DataOut = wrData_MEM;
  	
    always @ (posedge clk or negedge rstb)
    begin   :   Pipeline_MEM
        if(!rstb)
        begin
			MEM_to_WB <= 71'd0;
        end
        else
        begin
          MEM_to_WB <= {MemToReg_MEM,WrEnReg_MEM,readData_MEM,readAddr_MEM,EX_to_MEM[4:0]};
        end
    end
  
//----------------------------------------------------------------------------------------------------- 
// Write back part
  	wire			[4:0]	rdReg_WB;
  	wire			[31:0]	wrData_WB;
  	wire					MemToReg_WB;
  	wire					WrEnReg_WB;
  
  	assign MemToReg_WB = MEM_to_WB[70];
  	assign WrEnReg_WB = MEM_to_WB[69];  
  	assign rdReg_WB = MEM_to_WB[4:0];
  
  	assign RegFWData = MemToReg_WB ?  MEM_to_WB[68:37] : MEM_to_WB[36:5];
  	assign RegFWAddr = rdReg_WB;
  	assign WrEn_ID = WrEnReg_WB; 
  
//-----------------------------------------------------------------------------------------------------

    ForwardControl FwrdCtrl(
      .RegRs_EX(RS_to_ID),
      .RegRt_EX(ID_to_EX[9:5]),
      .RegRd_MEM(EX_to_MEM[4:0]),
      .RegRd_WB(MEM_to_WB[4:0]),
      .RegWrEn_WB(WrEnReg_WB),
      .RegWrEn_MEM(WrEnReg_MEM),
      .OperAFwrd(OperAFwrd),
      .OperBFwrd(OperBFwrd)	
  	);
	
	HazardDetectionUnit HazDetUn(
		.MemRead(ReEnDat_EX),
		.FirstRegAddr(rsReg_ID),
		.SecondRegAddr(rtReg_ID),
		.SaveRegAddr(rdReg_EX),
		.ConvertToNOP(NOPControl),
		.IF_IDWrite(IFRegControl),
		.PCWrite(PCControl)
	);
    
  	
  assign OpAAftFwrd = (OperAFwrd == 2'b00) ? OperandA_EX : (OperAFwrd == 2'b01) ? RegFWData : readAddr_MEM;
  assign OpBAftFwrd = (OperBFwrd == 2'b00) ? Data2_EX : (OperBFwrd == 2'b01) ? RegFWData : readAddr_MEM;
  assign DataOut_EX = OpBAftFwrd; 
  assign OperandB_EX =  ALUSrc_EX ? SgExtImm_EX : OpBAftFwrd;
endmodule
