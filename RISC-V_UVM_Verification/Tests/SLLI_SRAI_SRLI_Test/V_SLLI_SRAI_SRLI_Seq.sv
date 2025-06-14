class v_slli_srai_srli_i_seq extends uvm_sequence;

 

  // factory registration
  `uvm_object_utils(v_slli_srai_srli_i_seq)

  //-------------------------- constructor -----------------------------
  function new(string name = "v_slli_srai_srli_i_seq");
    super.new(name);
  endfunction
  //--------------------------------------------------------------------

  CV32E40P_data_mem_seq data_sequence;
  SLLI_SRAI_SRAI_Sequence       sss_sequen;
 

  v_sqr vir_seqer;

  task pre_body;
    data_sequence = CV32E40P_data_mem_seq::type_id::create("data_sequence");
    sss_sequen        = SLLI_SRAI_SRAI_Sequence ::type_id::create("sss_sequen");

    $cast(vir_seqer, m_sequencer);
  endtask : pre_body

  task body();
 
    fork
      begin
        sss_sequen.start(vir_seqer.instr_sqr);  
      end

      data_sequence.start(vir_seqer.data_sqr);
    join_any
  endtask : body

endclass : v_slli_srai_srli_i_seq
