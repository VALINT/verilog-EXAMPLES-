`timescale 1ns/1ns

module ram_16_x_8_tb;
   wire [7:0] data;
   reg clk;
   reg out_en;
   reg rd_en, wr_en;
   reg [3:0] address;
   reg [7:0] data1;
   
   reg [7:0] mem [15:0];

   ram_16_x_8 u1 (.data(data), .clk(clk), .out_en(out_en),.address(address), .rd_en(rd_en), .wr_en(wr_en));

   assign data = !out_en ? data1 : 8'bZ;
   //assign data = data1;
initial
  begin
     clk=1'b1;
     forever #50 clk=~clk;   
  end
  


initial 
   begin
   $readmemh("memory.txt", u1.memory);
   end

initial
begin
   #100;
   out_en = 1'b0;
   wr_en = 1'b1;
   rd_en=1'b0;
   address= 8'b0000;
   data1= 8'b1111;
   
   #100;
   
   address=8'b0001;
   data1 = 8'b0110;
   
   #100;
   
   address=8'b0010;
   data1 = 8'b0111;
   
   #100;
   
   out_en = 1'b1;
   address= 8'b0001;
   wr_en = 1'b0;
   rd_en=1'b1;
   
   #100
   address=8'b0010;
   
   #100;
   
   address= 8'b0011;
   
   #100;
   
   address=8'b0001;
   //data1 = 8'b0110;
   
   #100;
   
   address=8'b0010;
   //data1 = 8'b0111;
   
   #100;

    address=8'b0110;

   #100;
   out_en = 1'b1;
   address= 8'b0010;
   wr_en = 1'b0;
   rd_en=1'b1;
   #100


     $stop;
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