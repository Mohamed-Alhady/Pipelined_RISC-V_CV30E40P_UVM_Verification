class c_1222_1;
    rand bit[31:0] instr_rdata_i; // rand_mode = ON 

    constraint funct_this    // (constraint_mode = ON) (Seq_Items/seq_item.sv:29)
    {
       ((instr_rdata_i[6:0]) == 7'h13) -> ((instr_rdata_i[14:12]) inside {3'h0, 3'h4, 3'h6, 3'h7, 3'h2, 3'h3});
    }
    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (Sequences/SLLI_SRAI_SRLI_Sequence.sv:29)
    {
       ((instr_rdata_i[6:0]) == 7'h13);
       ((instr_rdata_i[14:12]) inside {3'h1, 3'h5});
    }
endclass

program p_1222_1;
    c_1222_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "01zz0z10z1010x1x10x1x0xzx0xxzzx0xzxxxzxzzzzxxxxxxxzzzxxxzxxzzzzx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
