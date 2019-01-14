`timescale 1ns/1ns

module ram_64K_x_8_tb;
   wire  [7:0] data;
   wire  [7:0] data2;
   reg   clk;
   reg   o_en;
   reg   re_e, wr_e;
   reg   [15:0] address;
   wire  [3:0]  address2;
   reg   [7:0] data1;
   
    reg [7:0] buffer;

   ram_64K_x_8 dut(.data(data), .clk(clk), .o_en(o_en),  .address(address), .re_e(re_e), .wr_e(wr_e));
   ram_16_x_8 u1  (.data(data2), .clk(clk), .out_en(o_en),.address(address2), .rd_en(re_e),.wr_en(wr_e));

   assign data = !o_en ? data1 : 8'bZ;
   assign data2 = !o_en ? data1 : 8'bZ;
   assign address2 = address[3:0];
   //assign data = data1;
initial
  begin
     clk=1'b1;
     forever #10 clk=~clk;   
  end
  


initial 
   begin
   $readmemh("memory_64K.txt", dut.ram);
   $readmemh("memory.txt", u1.memory);
   end

initial
begin
    buffer = 8'h00;
    #1000;
    
    o_en = 1'b0;
    wr_e = 1'b1;
    re_e=1'b0;
	@ (posedge clk)
    repeat(256)
    begin
        wr_e = 1'b1;
        address= buffer;
        data1= buffer;
         #35;
         // wr_e = 1'b0;
         // @ (posedge clk)
        buffer = buffer + 1;
   end

    o_en = 1'b1;
    wr_e = 1'b0;
    re_e=  1'b1;
	@ (posedge clk)
    repeat(256)
    begin
        address= buffer;
       #35;
       // @ (posedge clk)
        buffer = buffer + 1;
   end
     $stop;
   end

	initial
	begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end

endmodule

/*

`timescale 1ns/1ns

module ram_16_x_8_tb;
   wire [7:0] data;
   reg clk;
   reg out_en;
   reg rd_en, wr_en;
   reg [3:0] address;
   reg [7:0] data1;
   

   ram_16_x_8 u1 (.data(data), .clk(clk), .out_en(out_en),.address(address), .rd_en(rd_en), .wr_en(wr_en));

   assign data = !out_en ? data1 : 4'bZ;
   //assign data = data1;
initial
  begin
     clk=1'b1;
     forever #50 clk=~clk;   
  end
  
    integer addr = 0;

initial
begin
   #100;
   out_en = 1'b0;
   wr_en = 1'b1;
   rd_en=1'b0;
   repeat(16)
   begin
        @(posedge clk)
        address = addr;
        data1 = $urandom_range(0,255);
        #100;
         addr = addr + 1;       
   end

    addr = 0;

   out_en = 1'b1;
   wr_en = 1'b0;
   rd_en=1'b1;
   
    repeat(16)
   begin
        @(posedge clk)
        address = addr;
        #100;
        addr = addr + 1;        
   end

     $stop;
   end

endmodule

*/
