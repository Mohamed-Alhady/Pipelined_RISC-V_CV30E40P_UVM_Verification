class v_L_instr_seq extends uvm_sequence;

 

  // factory registration
  `uvm_object_utils(v_L_instr_seq)

  //-------------------------- constructor -----------------------------
  function new(string name = "v_L_instr_seq");
    super.new(name);
  endfunction
  //--------------------------------------------------------------------

  CV32E40P_data_mem_seq data_sequence;
  L_Type_Sequence       L_sequen;
  I_Type_Sequence       I_sequen;

  v_sqr vir_seqer;

  task pre_body;
    data_sequence = CV32E40P_data_mem_seq::type_id::create("data_sequence");
    L_sequen        = L_Type_Sequence::type_id::create("L_sequen");
    I_sequen      = I_Type_Sequence::type_id::create("I_sequen");

    $cast(vir_seqer, m_sequencer);
  endtask : pre_body

  task body();
 
    fork
      begin
        I_sequen.start(vir_seqer.instr_sqr);  
        L_sequen.start(vir_seqer.instr_sqr);  
      end

      data_sequence.start(vir_seqer.data_sqr);
    join_any
  endtask : body

endclass : v_L_instr_seq
