class v_zero_ones_min_max_auipc_seq extends uvm_sequence;
  // factory registration
  `uvm_object_utils(v_zero_ones_min_max_auipc_seq)

  //-------------------------- constructor -----------------------------
  function new(string name = "v_zero_ones_min_max_auipc_seq");
    super.new(name);
  endfunction
  //--------------------------------------------------------------------

  CV32E40P_data_mem_seq data_sequence;
  zero_ones_min_max_auipc_sequence       auipc_sequen;
 

  v_sqr vir_seqer;

  task pre_body;
    data_sequence = CV32E40P_data_mem_seq::type_id::create("data_sequence");
    auipc_sequen        = zero_ones_min_max_auipc_sequence::type_id::create("auipc_sequen");

    $cast(vir_seqer, m_sequencer);
  endtask : pre_body

  task body();
 
    fork
      begin
       auipc_sequen.start(vir_seqer.instr_sqr);  
      end

      data_sequence.start(vir_seqer.data_sqr);
    join_any
  endtask : body

endclass : v_zero_ones_min_max_auipc_seq

