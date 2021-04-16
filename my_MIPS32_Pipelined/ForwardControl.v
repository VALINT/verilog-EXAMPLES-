/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  Forwarding Unit
//  Forwarding unit for My MIPS32_PPL realization
//
//  Author      : VAL
//  Written     : 24 May 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module ForwardControl(
	RegRs_EX,
  	RegRt_EX,
  	RegRd_MEM,
 	RegRd_WB,
  	RegWrEn_WB,
  	RegWrEn_MEM,
  	clk,
  	rstb,
  	OperAFwrd,
  	OperBFwrd
);
  
  input					clk;
  input					rstb;
  input					RegWrEn_WB;
  input					RegWrEn_MEM;
  input			[4:0]	RegRs_EX;
  input			[4:0]	RegRt_EX;
  input			[4:0]	RegRd_MEM;
  input			[4:0]	RegRd_WB;
  
  output wire	[1:0]	OperAFwrd;
  output wire	[1:0]	OperBFwrd;
  
  wire					MEM_Fwrd_A;
  wire					MEM_Fwrd_B;
  wire					WB_Fwrd_A;
  wire					WB_Fwrd_B;
  
  assign MEM_Fwrd_A = (RegWrEn_MEM & RegRd_MEM != 5'd0 & RegRd_MEM == RegRs_EX)? 1'b1 : 1'b0;
  assign MEM_Fwrd_B = (RegWrEn_MEM & RegRd_MEM != 5'd0 & RegRd_MEM == RegRt_EX)? 1'b1 : 1'b0;
  
  assign WB_Fwrd_A = (RegWrEn_WB & RegRd_WB != 5'd0 & RegRd_WB == RegRs_EX)? 1'b1 : 1'b0;
  assign WB_Fwrd_B = (RegWrEn_WB & RegRd_WB != 5'd0 & RegRd_WB == RegRt_EX)? 1'b1 : 1'b0;
  
  assign OperAFwrd = (MEM_Fwrd_A) ? 2'b10 : (WB_Fwrd_A) ? 2'b01 : 2'b00;
  assign OperBFwrd = (MEM_Fwrd_B) ? 2'b10 : (WB_Fwrd_B) ? 2'b01 : 2'b00;
endmodule