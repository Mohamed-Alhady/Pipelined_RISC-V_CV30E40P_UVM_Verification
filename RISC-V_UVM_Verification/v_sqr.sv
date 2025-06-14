class v_sqr extends uvm_sequencer;
`uvm_component_utils(v_sqr)
// making handle for the sequncers  

instr_sequencer  		instr_sqr	;
CV32E40P_Data_Sequencer data_sqr	; 
debug_sequencer			debug_sqr	;
config_sequencer		config_sqr  ;
interr_sequencer		interr_sqr  ;

function new (string name = "v_sqr",uvm_component parent = null);
    super.new(name);
endfunction

endclass