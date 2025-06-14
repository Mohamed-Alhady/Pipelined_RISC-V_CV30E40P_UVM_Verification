import cv32e40p_pkg::*;

class output_mul extends uvm_monitor;

  // Factory registration
  `uvm_component_utils(output_mul)

  // Analysis port and virtual interface
  uvm_analysis_port#(mult_transaction) analysis_port;
  virtual mul_intf v_intf;

  // Constructor and UVM phase methods
  extern function new(string name = "output_mul", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : output_mul

// -------------------------- Constructor -----------------------------
function output_mul::new(string name = "output_mul", uvm_component parent = null);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new
// -------------------------------------------------------------------

// -------------------------- Build Phase -----------------------------
function void output_mul::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_full_name(), "output_mul CLASS", UVM_NONE);

  // Get virtual interface from configuration database
  if (!uvm_config_db#(virtual mul_intf)::get(this, "", "mul_vif", v_intf))
    `uvm_fatal(get_full_name(), "couldn't get interface from agent");
endfunction : build_phase
// -------------------------------------------------------------------

 
// -------------------------- Run Phase -------------------------------
task output_mul::run_phase(uvm_phase phase);
  forever begin
    mult_transaction seq_itm;
    seq_itm = new();

    @(posedge v_intf.clk);
    #1;

    if (v_intf.enable_i && v_intf.ready_o) begin
      seq_itm.result_o = v_intf.result_o;
      analysis_port.write(seq_itm);
    end
  end
endtask : run_phase
// -------------------------------------------------------------------
