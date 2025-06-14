
  class debug_sequencer extends uvm_sequencer #(seq_item);
         
    `uvm_component_utils(debug_sequencer)
        function  new(string name = "debug_sequencer" , uvm_component parent = null);
        	super.new(name,parent);
        endfunction : new
           
  endclass
