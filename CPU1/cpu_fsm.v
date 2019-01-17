/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//  CPU control FSM
//
//  Author  : VAL
//  Wrote   : 11 Jan 2019
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

//  Input signals
input       [7:0]   data;
input               clk;
input               rst;
input               carry_f_in;
input               zero;

//  Output signals
output wire [15:0]  address;
output wire         wr_e;
output wire         re_e;
output wire         o_en;
output wire         clr_acc;
output reg  [7:0]   operand_a;
output wire         en_acc;
output wire [1:0]   operand_b;
output wire         carry_flag;
output wire         carry_en;
output wire         substrate;

//  System registers and wires
reg         [2:0]   state_counter;
reg         [7:0]   instr_reg;
reg         [7:0]   address_h_reg;
reg         [7:0]   address_l_reg;
reg         [15:0]  pc;
reg         [15:0]  sp;
reg                 carry;
wire        [2:0]   state;
wire                addr_source;
wire                pc_inc;
wire                rst_state;
wire                pc_rw;

// Instruction set
parameter  [7:0]   NOP = 8'b0000_0000;          // Do nothing.
parameter  [7:0]   NAC = 8'b0000_0001;          // Nullify accumulator.
parameter  [7:0]   LME = 8'b0001_0000;          // Load from memory in accumulator.
parameter  [7:0]   SME = 8'b0001_0001;          // Save in memory from accumulator.
parameter  [7:0]   SUM = 8'b0010_0000;          // Add value from memory with value in accumulator.
parameter  [7:0]   SMC = 8'b0010_0001;          // Add value from memory with value in accumulator with carry.
parameter  [7:0]   SUB = 8'b0010_0010;          // Subtract value from memory from value in accumulator.
parameter  [7:0]   SBB = 8'b0010_0011;          // Subtract value from memory from value in accumulator with borrow.
parameter  [7:0]   VAD = 8'b0010_0100;          // Save value from memory in accumulator with decrement.
parameter  [7:0]   VAI = 8'b0010_0101;          // Save value from memory in accumulator with increment.
parameter  [7:0]   JMP = 8'b0100_0000;          // Jump, unconditional branching.
parameter  [7:0]   JMZ = 8'b0100_0010;          // Jump if zero (last accumulator value).
parameter  [7:0]   JMC = 8'b0100_0100;          // Jump if carry (at last arithmetic operation).
parameter  [7:0]   JNZ = 8'b0100_0011;          // Jump if not zero (last accumulator value).
parameter  [7:0]   JNC = 8'b0100_0111;          // Jump if not carry (at last arithmetic operation).
parameter  [7:0]   FNH = 8'b1000_0000;          // Finish set state in 0, removed.

// FSM states
parameter  [3:0]  READ_M_1  = 3'b001;
parameter  [3:0]  READ_M_2  = 3'b010;
parameter  [3:0]  READ_M_3  = 3'b011;
parameter  [3:0]  DECODE    = 3'b100;
parameter  [3:0]  CONTROL   = 3'b101;
 
    //  Sequential instruction decoder.
    assign address      = (addr_source) ? {address_h_reg, address_l_reg} : pc;          //Set address at output from PC or from 2 and 3 registers, chose by addr_source sygnal.                       
    assign carry_flag   = carry;                                                        //Need for SMC and SBB instructions.
    assign rst_state    = ((state == READ_M_1 & !data[7:1]) || state == CONTROL);       //Reset state to 1 (at NOP and NAC instructions)
    assign state        = state_counter;
    assign substrate    = ((state == CONTROL) && (instr_reg == SUB || instr_reg == SBB));
    assign operand_b[1] = ((state == DECODE || state == CONTROL) && (instr_reg == VAD));                    // Need for decrement operation
    assign operand_b[0] = ((state == DECODE || state == CONTROL) && (instr_reg == LME || instr_reg == VAI));// Need for increment and LME, 'cos need write in empty accumulator and this signal sets 0 on adder's second input.
    assign carry_en     = ((state == DECODE || state == CONTROL) && (instr_reg == SMC || instr_reg == SBB || instr_reg == VAI)); // Enable carry_in input on the adder.
    assign wr_e         = (state == DECODE && instr_reg == SME);                                            //Enable writing in the memory, read and output must be in low state.
    assign re_e         = ((state == READ_M_1 || state == READ_M_2 || state == READ_M_3 || (state == DECODE && (instr_reg == LME || instr_reg[5]))));
    assign o_en         = re_e;
    assign addr_source  = (((state == DECODE || state == CONTROL) && (instr_reg == LME || instr_reg[5])) || (state == DECODE && instr_reg == SME));
    assign en_acc       = ((state == CONTROL && (instr_reg == LME || instr_reg[5] )));                      // Enable accumulator write, need fot arithmetic and LME.
    assign clr_acc      = (state == READ_M_1 && data == NAC);                                               // Clear accumulator, (For one cycle)         |
    assign pc_inc       = (state == READ_M_1 || state == READ_M_2 || state == READ_M_3);                    // Increment program counter (first 3 states) V - PC rewrite, need for branching.
    assign pc_rw        = (state == CONTROL && ((instr_reg == JMZ && zero) || (instr_reg == JNZ && !zero) || (instr_reg == JMC && carry) || (instr_reg == JNC && !carry)||(instr_reg == JMP)));

    // State counter (one clock for one state)
    always @ (posedge clk or posedge rst)
    begin   :   state_cntr
        if(rst) state_counter   <= 3'b001;
        else
            if(!rst_state)  state_counter <= state_counter + 1; 
            else            state_counter <= 3'b001;
    end

    // Program counter
    always @ (posedge clk or posedge rst)
    begin   :   Program_counter
        if(rst) pc   <= 16'b0000_0000_0000_0000;
        else if(pc_inc)  pc <= pc + 1;                              // Increment if normal operating mode.
        else if(pc_rw)   pc <= {address_h_reg, address_l_reg};      // Rewrite value if branching.
    end

    always @ (posedge clk or posedge rst)
    begin   :   OUTPUT_LOGIC
        if(rst)
        begin
            instr_reg       <= 8'b0000_0000;
            address_h_reg   <= 8'b0000_0000;
            address_l_reg   <= 8'b0000_0000;
            operand_a       <= 8'b0000_0000;
            sp              <= 16'b0000_0000_0000_0000;
            carry           <= 1'b0;
        end
    else
        case(state)
            READ_M_1    :   instr_reg       <= data;                                    // Read instruction.
            READ_M_2    :   address_h_reg   <= data;                                    // Read address MSB.
            READ_M_3    :   address_l_reg   <= data;                                    // Read address LSM.
            DECODE      :   if(instr_reg[5] || instr_reg == LME) operand_a <= data;     // Read variable if it need.
            CONTROL     :   if(instr_reg[5]) carry <= carry_f_in;                       // Save operation result in accumulator or on memory.
        endcase
    end
endmodule