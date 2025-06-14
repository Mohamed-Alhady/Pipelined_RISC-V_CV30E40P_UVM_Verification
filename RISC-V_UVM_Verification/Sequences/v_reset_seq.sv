class v_reset_seq extends uvm_sequence;
    `uvm_object_utils( v_reset_seq)

    //initiating the sequences that will be used 
		v_sqr virt_sequencer ;
    // third for the configuration is optional 

    function new(string name = "v_reset_seq");
        super.new();
    endfunction //new()

 
	rst_sequence seq;

task pre_body;
		seq = rst_sequence::type_id::create("seq");
		$cast(virt_sequencer,m_sequencer);
	endtask : pre_body

	task body();
		seq.start(virt_sequencer.config_sqr);
	endtask : body

endclass // v_base_seq extends uvm_sequence