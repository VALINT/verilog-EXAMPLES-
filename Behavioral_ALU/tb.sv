// Code your testbench here
// or browse Examples
`timescale 1ns/1ns

//`include "design.sv"

`define NOP 	opcode = 0
`define DONE 	opcode = 0
`define RESET 	opcode = 1
`define PRESET 	opcode = 2
`define SUB		opcode = 4
`define SUB_B	opcode = 5
`define ADD		opcode = 6
`define ADD_C	opcode = 7
`define DIV		opcode = 3
`define MUL		opcode = 8
`define AND		opcode = 9
`define OR		opcode = 10
`define NOT		opcode = 11
`define XOR		opcode = 12


module testbench();

  string commands[0:12] = {
  	"  NOP  ",
    " RESET ",
    "PRESET ",
    "  DIV  ",
    "  SUB  ",
    " SUB_B ",
    "  ADD  ",
    " ADD_C ",
    "  MUL  ",
    "  AND  ",
    "   OR  ",
    "  NOT  ",
    "  XOR  "
  };
    
  reg			clk;
  reg			rstb;
  reg	[15:0]	x;
  reg	[3:0]	opcode;
  
  wire	[31:0]	out;
  wire			status_c;

  
  task print_status();
    #1;$display("|%d|%2d|",clk,opcode,commands[opcode],"|%8h|%10d|%8h|%10d|%8h|%10d|%6d|",x,x,out,out,DUT.mux_out,DUT.mux_out,status_c);
endtask
  
  task wait_next();
    
    print_status();
    @(posedge clk);
    print_status();
    
  endtask
  
  
  b_ALU DUT(
    .clk(clk),
    .rstb(rstb),
    .opcode(opcode),
    .dp_input(x),
    .dp_output(out),
    .status_out(status_c)
  );
  
  initial
  begin
    #1000;
    $stop;
  end
  
  initial
  begin
    #20;
    @(negedge clk);
    //Subtract test
    `OR;
    x = 200;
    $display("|C|");
    $display("|L|          |Input              |Accumulator        |Next               |");
    $display("|K|# |Op-code|Hex     |Dec       |Hex     |Dec       |Hex     |Dec       |Status|");
    $display("|_|__|_______|________|__________|________|__________|________|__________|______|");
    $display("|                              Subtractor test                                  |");
    wait_next();
    @(negedge clk);
    `SUB;
    x = 50;
    wait_next();
    @(negedge clk);
    `SUB;
    x = 200;
   	wait_next();
    @(negedge clk);
   	wait_next();
    $display("|                                   Adder test                                  |");
    @(negedge clk);
    `RESET;
    x=0;
    wait_next();
    @(negedge clk);
    `OR;
    x=128;
    wait_next();
    @(negedge clk);
    `ADD;
    x=1024;
    wait_next();
    @(negedge clk);
    `ADD;
    x=65000;
    wait_next();
    @(negedge clk);
    wait_next();
    @(negedge clk);
    $display("|                                   Divider test                                |");
    `RESET;
    x=0;
    wait_next();
    @(negedge clk);
    `OR;
    x = 245;
    wait_next();
    @(negedge clk);
    `DIV;
    x = 5;
    wait_next();
    @(negedge clk);
    `DIV;
    x = 8;
    wait_next();
    @(negedge clk);
    $display("|                                   Multiplier test                             |");
    `RESET;
    x = 0;
    wait_next();
    @(negedge clk);
    `OR;
    x = 100;
    wait_next();
    @(negedge clk);
    `MUL;
    x = 23;
    wait_next();
    @(negedge clk);
    `OR;
    x = 'hffff;
    wait_next();
    @(negedge clk);
    `MUL;
    x = 'hffff;
    wait_next();
    @(negedge clk);
    $display("|                                     Logic test                                |");
    `AND;
    x=0;
    wait_next();
    @(negedge clk);
    `OR;
    x = 'hFFFF;
    wait_next();
    @(negedge clk);
    `AND;
    x = 'h00ff;
    wait_next();
    @(negedge clk);
    `XOR;
    x = 'hFFFF;
    wait_next();
    @(negedge clk);
    `NOT;
    x = 'hAAAA;
    wait_next();
    @(negedge clk);
    `RESET;
    x = 2345;
    wait_next();
    @(negedge clk);
    `PRESET;
    x = 8765;
    wait_next();
    @(negedge clk);
    `AND;
    x = 12345;
    wait_next();
    @(negedge clk);
    `NOP;
    x = 7868;
    wait_next();
    @(negedge clk);
    $display("|                                     Test END                                  |");
    $display("|_______________________________________________________________________________|");
  end
  
  initial
    begin
      clk = 0;
      rstb = 0;
      opcode = 0;
      x = 0;
      #10;
      rstb = 1;
      forever #10 clk = ~clk;
    end
  
  	initial
  	begin
      $dumpfile("dump.vcd");
		$dumpvars;
	end
endmodule