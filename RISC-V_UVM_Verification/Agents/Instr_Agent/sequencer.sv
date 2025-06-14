class instr_sequencer extends uvm_sequencer #(seq_item);

  // Factory registration     
  `uvm_component_utils(instr_sequencer)

  // Analysis ports and FIFO for exporting analysis data
  uvm_analysis_export #(seq_item) analysis_export;
  uvm_tlm_analysis_fifo #(seq_item) analysis_fifo;

  // Constructor declaration
  extern function new(string name = "instr_sequencer", uvm_component parent = null);

  // Connect phase declaration
  extern function void connect_phase(uvm_phase phase);

endclass

// -------------------------- Constructor -----------------------------
function instr_sequencer::new(string name = "instr_sequencer", uvm_component parent = null);
  super.new(name, parent);
  
  // Create analysis ports and FIFO
  analysis_export = new("analysis_export", this);
  analysis_fifo = new("analysis_fifo", this);
endfunction : new
// ---------------------------------------------------------------------

// -------------------------- Connect Phase -----------------------------
function void instr_sequencer::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  
  // Connect analysis export to FIFO
  analysis_export.connect(analysis_fifo.analysis_export);
endfunction
// ---------------------------------------------------------------------
