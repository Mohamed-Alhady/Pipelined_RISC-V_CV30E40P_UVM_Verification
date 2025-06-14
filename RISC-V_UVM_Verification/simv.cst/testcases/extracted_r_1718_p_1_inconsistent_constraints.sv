class c_1718_1;
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

program p_1718_1;
    c_1718_1 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "0z1xx1x0zzzxx0z1zxzz1x0zx1x011x0zxxzzxxxzzzzxxzxzzzzxxxzzzzxxxzz";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
