class c_3040_1;
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

program p_3040_1;
    c_3040_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "1xzz101x0zxxzx1z1011z1x1010001zzzzzxxxxxzzxzxxxzxxzzzxxxzxxxzzxz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
