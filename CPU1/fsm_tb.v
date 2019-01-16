/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  CPU control FSM testbench
//
//  Autor:  VAL
//  Wrired: 13 Jan 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ns

module fsm_tb();
    wire            wr_e;
    wire            re_e;
    wire            o_en;
    reg             clk;
    reg             rst;
    wire    [7:0]   data;
    wire    [15:0]  address;
    reg     [7:0]   data1;
    wire            clr_acc;
    wire            en_acc;
    wire    [7:0]   operand_a;
    wire    [1:0]   operand_b;
    wire            carry_en;
    wire            carry_f_in;
    wire            carry_flag;
    wire            substrate;
    wire            zero;


    cpu_fsm FSM (
        .clk(clk),
        .rst(rst),
        .data(data),
        .address(address),
        .wr_e(wr_e),
        .re_e(re_e),
        .o_en(o_en),
        .clr_acc(clr_acc),
        .en_acc(en_acc),
        .carry_en(carry_en),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .carry_f_in(carry_f_in),
        .carry_flag(carry_flag),
        .substrate(substrate),
        .zero(zero)
    );

    

    ram_64K_x_8 MEM(
        .data(data), 
        .clk(clk), 
        .o_en(o_en),  
        .address(address), 
        .re_e(re_e), 
        .wr_e(wr_e)
    );

    wire    [7:0]   data_out;
    wire            carry_in;
    wire            carry_out;
    wire    [7:0]   sum;
    wire    [7:0]   op_a;
    reg     [7:0]   op_b;

    assign  op_a =  (substrate)? (~operand_a) : operand_a;
    //assign  op_b =  (operand_b == 2'b00) ? data_out : (operand_b == 2'b01) ? (8'h00) : (operand_b == 2'b01) ? (8'hff) : 8'hZZ;
    assign  zero = (!data_out);
    
    always @ (*)
    begin
        case(operand_b)
            2'b00   :  op_b = data_out;
            2'b01   :  op_b = 8'b0000_0000;
            2'b10   :  op_b = 8'b1111_1111;
            default :  op_b = 8'bZZZZ_ZZZZ;
        endcase
    end

    assign carry_f_in = carry_out;
    //assign carry_in = (carry_en)? carry_flag : (substrate) ? (1'h1) : (1'h0);   
    assign carry_in = (carry_en)? ((substrate)? ~carry_flag : carry_flag) : (substrate) ? (1'h1) : (1'h0);

    adder ADD(
        .term_a(op_a),
        .term_b(op_b),
        .sum(sum),
        .carry_in(carry_in),
        .carry_out(carry_out)
    );

    accumulator ACC(
        .DataIn(sum),
        .DataOut(data_out),
        .en(en_acc),
        .clr(clr_acc),
        .clk(clk),
        .rst(rst)
    );

    assign data = (!o_en && wr_e) ? data_out : 8'bZ;

    initial 
    begin
    $readmemh("memory_64K.txt", MEM.ram);
    end

    initial
    begin
        rst = 1;
        clk = 0;
        #10;
        rst = 0;
        forever #10 clk = ~clk;
    end


    initial
    begin
        #5000;
        $stop;
    end

    initial
	begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end

endmodule