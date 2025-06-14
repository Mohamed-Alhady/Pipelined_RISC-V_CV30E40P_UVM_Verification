class v_sub_sra_seq extends uvm_sequence;

 

  // factory registration
  `uvm_object_utils(v_sub_sra_seq)

  //-------------------------- constructor -----------------------------
  function new(string name = "v_sub_sra_seq");
    super.new(name);
  endfunction
  //--------------------------------------------------------------------

  CV32E40P_data_mem_seq data_sequence;
  SUB_SRA_Sequence       s_sequen;
 

  v_sqr vir_seqer;

  task pre_body;
    data_sequence = CV32E40P_data_mem_seq::type_id::create("data_sequence");
    s_sequen        = SUB_SRA_Sequence::type_id::create("s_sequen");

    $cast(vir_seqer, m_sequencer);
  endtask : pre_body

  task body();
 
    fork
      begin
        s_sequen.start(vir_seqer.instr_sqr);  
      end

      data_sequence.start(vir_seqer.data_sqr);
    join_any
  endtask : body

endclass : v_sub_sra_seq
