// ======================
// config_sequencer.sv
// ======================
class config_sequencer extends uvm_sequencer #(config_seq_item);
  `uvm_component_utils(config_sequencer)
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass
