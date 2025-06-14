  class interr_sequencer extends uvm_sequencer #(seq_item);
         
    `uvm_component_utils(interr_sequencer)

        function  new(string name = "interr_sequencer" , uvm_component parent = null);
        	super.new(name,parent);
        endfunction : new
           
  endclass
