///////////////////////////////////////////////////////////////////
//	Sep 07 2018
//	PWM
//	by VAL
///////////////////////////////////////////////////////////////////
`timescale  1ns/100ps

module pwm_tb;

    reg           clk;
    reg           rst;
    reg           w_en;
    reg   [7:0]   w_duty;

    wire          pwm_o;

    integer       a = 0;

    pwm DUT(
        .clk(clk),
        .rst(rst),
        .w_en(w_en),
        .w_duty(w_duty),
        .pwm_o(pwm_o)
    );

    initial begin
        rst     = 0;
        clk     = 0;
        w_en    = 0;
        w_duty  = 0;
        #10 rst = 1;
        #10 rst = 0;
        forever clk = #5 ~clk;
    end

    initial begin
        #100;
        for(a = 0;a < 256;a = a + 1)
        begin
            w_duty = a;
            w_en = 1;
            #20;
            w_en = 0; 
            #6000;
        end
       
        #100000;
        $finish;
    end

	initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
	end

endmodule