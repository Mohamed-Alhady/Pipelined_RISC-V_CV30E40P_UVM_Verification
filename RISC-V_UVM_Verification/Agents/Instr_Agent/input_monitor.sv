class instr_in_mon extends uvm_monitor;
 
  // factory registration
  `uvm_component_utils(instr_in_mon)

  uvm_analysis_port#(seq_item) analysis_port;
  virtual instruction_intf v_intf;

  extern function new(string name = "instr_in_mon", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
 
endclass


// -------------------------- constructor -----------------------------
function instr_in_mon::new(string name = "instr_in_mon", uvm_component parent = null);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new
// ---------------------------------------------------------------------

// ------------------------------ build_phase -----------------------------
function void instr_in_mon::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_full_name(), "instr_in_mon CLASS", UVM_NONE);

  // ------------------------ Get virtual interface from agent ----------------
  if (!uvm_config_db#(virtual instruction_intf)::get(this, "", "instr_vif", v_intf))
    `uvm_fatal(get_full_name(), "couldn't get interface from agent");
  // --------------------------------------------------------------------------
endfunction : build_phase
// --------------------------------------------------------------------------

// ------------------------------ run_phase -----------------------------
task instr_in_mon::run_phase(uvm_phase phase);
  forever begin
    seq_item seq_itm;
    seq_itm = new();
    @(posedge v_intf.clk);
    #2;
    if (v_intf.instr_rvalid_i) begin
      seq_itm.instr_rdata_i = v_intf.instr_rdata_i;  // Stores data only when instr_rvalid_i indicates validity
      analysis_port.write(seq_itm);   
    end
  end  
endtask : run_phase
// --------------------------------------------------------------------------
