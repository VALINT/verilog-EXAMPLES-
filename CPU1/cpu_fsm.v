/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  CPU control FSM
//
//  Autor:  VAL
//  Wrired: 11 Jan 2019
//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

module cpu_fsm(
    wr_e,
    re_e,
    o_en,
    clk,
    rst,
    data,
    address,
    clr_acc,
    en_acc,
    operand_a,
    operand_b,
    carry_flag,
    carry_f_in,
    carry_en,
    substrate,
    zero
);

input       [7:0]   data;

input               clk;
input               rst;
input               carry_f_in;
input               zero;

output wire [15:0]  address;
output reg          wr_e;
output reg          re_e;
output reg          o_en;
output reg          clr_acc;
output reg  [7:0]   operand_a;
output reg          en_acc;
output reg  [1:0]   operand_b;
output wire         carry_flag;
output reg          carry_en;
output reg          substrate;

reg         [2:0]   state_counter;
reg         [7:0]   instr_reg;
reg         [7:0]   address_h_reg;
reg         [7:0]   address_l_reg;
reg         [15:0]  pc;
reg         [15:0]  sp;
reg                 carry;
reg         [2:0]   state;
reg         [2:0]   next_state;
reg                 addr_source;

// Instruction set
parameter  [7:0]   NOP = 8'b0000_0000;
parameter  [7:0]   NAC = 8'b0000_0001;
parameter  [7:0]   LME = 8'b0001_0000;
parameter  [7:0]   SME = 8'b0001_0001;
parameter  [7:0]   SUM = 8'b0010_0000;
parameter  [7:0]   SMC = 8'b0010_0001;
parameter  [7:0]   SUB = 8'b0010_0010;
parameter  [7:0]   SBB = 8'b0010_0011;
parameter  [7:0]   VAD = 8'b0010_0100;
parameter  [7:0]   VAI = 8'b0010_0101;
parameter  [7:0]   JMP = 8'b0100_0000;
parameter  [7:0]   JMZ = 8'b0100_0010;
parameter  [7:0]   JMC = 8'b0100_0100;
parameter  [7:0]   JNZ = 8'b0100_0011;
parameter  [7:0]   JNC = 8'b0100_0111;
parameter  [7:0]   FNH = 8'b1000_0000;

// FSM states
parameter  [3:0]  READ_M_1  = 3'b001;
parameter  [3:0]  READ_M_2  = 3'b010;
parameter  [3:0]  READ_M_3  = 3'b011;
parameter  [3:0]  DECODE    = 3'b100;
parameter  [3:0]  CONTROL   = 3'b101;

wire              rst_state;

assign  address = (addr_source) ? {address_h_reg, address_l_reg} : pc;
assign  carry_flag = carry;
assign  rst_state = ((state == READ_M_1 & !data[7:1]) || state == CONTROL);

always @ (posedge clk or posedge rst)
begin   :   state_cntr
    if(rst)
    begin
        state_counter   <= 3'b001;
    end
    else
    begin
        if(!rst_state)  state_counter <= state_counter + 1; 
        else            state_counter <= 3'b001;
    end
end

always @ (posedge clk or posedge rst)
begin   :   OUTPUT_LOGIC
    if(rst)
    begin
        instr_reg       <= 8'b0000_0000;
        address_h_reg   <= 8'b0000_0000;
        address_l_reg   <= 8'b0000_0000;
        operand_a       <= 8'b0000_0000;
        pc              <= 16'b0000_0000_0000_0000;
        sp              <= 16'b0000_0000_0000_0000;
        carry           <= 1'b0;
        en_acc          <= 1'b0;
        addr_source     <= 1'b0;
        state           <= 4'b0001;
        next_state      <= 4'b0010;
    end
    else
    begin
        case(state)
            READ_M_1    :   begin
                                if(data == NOP)      //NOP command
                                begin
                                   // state_counter    <= 3'b001;
                                end
                                else if(data == NAC)
                                begin
                                    //state_counter    <= 3'b001;
                                end
                                else
                                begin
                                    instr_reg       <= data;
                                    //state_counter   <= state_counter + 1;
                                end
                                pc <= pc + 1;                                
                            end
            READ_M_2    :   begin
                                address_h_reg       <= data;
                                pc <= pc + 1;
                                //state_counter       <= state_counter + 1;
                            end
            READ_M_3    :   begin
                                address_l_reg       <= data;
                                pc <= pc + 1;
                                //state_counter       <= state_counter + 1;
                            end
            DECODE      :   begin
                                if(instr_reg == LME)
                                begin
                                    operand_a <= data;
                                    en_acc  <= 1'b1;
                                end
                                else if(instr_reg == SUM || instr_reg == SMC || instr_reg == SUB || instr_reg == SBB || instr_reg == VAD || instr_reg == VAI)
                                begin
                                    operand_a <= data;
                                    en_acc  <= 1'b1;
                                end
                                //state_counter <= state_counter + 1;
                            end
            CONTROL     :   begin
                                if(instr_reg == SUM || instr_reg == SMC || instr_reg == SUB || instr_reg == SBB)
                                begin
                                    carry <= carry_f_in;
                                end
                                else if(instr_reg[6])
                                begin
                                    if(instr_reg == JMZ && zero)
                                        pc <= {address_h_reg, address_l_reg};
                                    else if(instr_reg == JNZ && !zero)
                                        pc <= {address_h_reg, address_l_reg};
                                    else if(instr_reg == JMC && carry)
                                        pc <= {address_h_reg, address_l_reg};
                                    else if(instr_reg == JNC && !carry)
                                        pc <= {address_h_reg, address_l_reg};
                                    else if(instr_reg == JMP)
                                        pc <= {address_h_reg, address_l_reg};
                                end

                                state_counter <= state_counter + 1;
                                state_counter   <= 3'b001;
                                en_acc  <= 1'b0;
                            end
        endcase
    end
end

always @ (posedge clk)
begin   :   STATE_LOGIC
    case(state)
        READ_M_1    :   if(state_counter == 4'b0000)
                            next_state = READ_M_3;
        READ_M_2    :   if(state_counter == 4'b0001)
                            next_state = READ_M_3;
        READ_M_3    :   if(state_counter == 4'b0110)
                            next_state = DECODE;
        DECODE      :   if(state_counter == 4'b1000)
                            next_state = CONTROL;
        CONTROL     :   if(state_counter == 4'b1010)
                            next_state = READ_M_1;
    endcase
end

always @ (*)
begin
    state = state_counter;

    if(state == READ_M_1)
    begin
        substrate   = 1'b0;
        operand_b   = 2'b00;
        carry_en    = 1'b0;
        addr_source = 1'b0;
        if(data == NAC)
            clr_acc = 1'b1;
        else
            clr_acc = 1'b0;

        wr_e        = 1'b0;
        re_e        = 1'b1;
        o_en        = 1'b1;
    end
    else if(state == READ_M_2)
    begin
        addr_source = 1'b0;
        operand_b   = 2'b00;
    end
    else if(state == READ_M_3)
    begin
        addr_source = 1'b0;
        operand_b   = 2'b00;
    end
    else if(state == DECODE)
    begin
        if(instr_reg == LME)
        begin
            addr_source = 1'b1;
            operand_b   = 2'b01;
            wr_e        = 1'b0;
            re_e        = 1'b1;
            o_en        = 1'b1;
            
        end
        else if(instr_reg == SUM || instr_reg == SMC || instr_reg == SUB || instr_reg == SBB || instr_reg == VAD || instr_reg == VAI )
        begin
            if( instr_reg == SMC || instr_reg == SBB)
                carry_en = 1'b1;

            addr_source = 1'b1;
            operand_b   = 2'b00;
            wr_e        = 1'b0;
            re_e        = 1'b1;
            o_en        = 1'b1;
        end
        else
        begin
            addr_source = 1'b0;
            wr_e        = 1'b0;
            re_e        = 1'b0;
            o_en        = 1'b0;
        end
    end
    else if(state == CONTROL)
    begin
        if(instr_reg == SME)
        begin
            substrate   = 1'b0;
            addr_source = 1'b1;
            wr_e        = 1'b1;
            re_e        = 1'b0;
            o_en        = 1'b0;
        end
        else if(instr_reg == LME)
        begin
            substrate   = 1'b0;
            addr_source = 1'b1;
            operand_b   = 2'b01;
            wr_e        = 1'b0;
            re_e        = 1'b0;
            o_en        = 1'b0;
            
        end
        else if(instr_reg == SUM || instr_reg == SMC || instr_reg == VAD || instr_reg == VAI)
        begin
            if(instr_reg == SMC )
                carry_en = 1'b1;

            if(instr_reg == VAD)
                operand_b = 2'b10;
            else
                operand_b   = 2'b00;
            
            if(instr_reg == VAI)
            begin
                carry_en = 1'b1;
                operand_b = 2'b01;
            end


            substrate   = 1'b0;
            addr_source = 1'b1;
            wr_e        = 1'b0;
            re_e        = 1'b0;
            o_en        = 1'b0;
        end
        else if(instr_reg == SUB || instr_reg == SBB)
        begin
            if(instr_reg == SBB)
                carry_en = 1'b1;
            substrate   = 1'b1;
            addr_source = 1'b1;
            operand_b   = 2'b00;
            wr_e        = 1'b0;
            re_e        = 1'b0;
            o_en        = 1'b0;
        end
        else
        begin
            addr_source = 1'b0;
            carry_en    = 1'b0;
        end
    end
    else
    begin
        addr_source = 1'b0;
    end
end

endmodule