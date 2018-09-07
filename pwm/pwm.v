///////////////////////////////////////////////////////////////////
//	Sep 07 2018
//	PWM
//	by VAL
///////////////////////////////////////////////////////////////////

module pwm(
    clk,
    rst,
    w_en,
    w_duty,
    pwm_o
    );

    input               clk;
    input               rst;
    input               w_en;
    input       [7:0]   w_duty;

    output wire          pwm_o;

    reg         [7:0]   duty;
    reg         [7:0]   counter;

    assign pwm_o = (counter >= duty);

    always @ (posedge clk or posedge rst)
    begin
        if(rst)
        begin
            counter <= 8'd0;
            duty    <= 8'd0;
        end
        else
        begin
            if(w_en)
            begin
                duty <= w_duty;
            end

            counter = counter + 1;
        end
    end

endmodule