import cv32e40p_pkg::*;

class input_mul extends uvm_monitor;

  // Factory registration
  `uvm_component_utils(input_mul)

  uvm_analysis_port#(mult_transaction) analysis_port;
  virtual mul_intf v_intf;

  extern function new(string name = "input_mul", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : input_mul

// -------------------------- Constructor -----------------------------
function input_mul::new(string name = "input_mul", uvm_component parent = null);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new
// -------------------------------------------------------------------

// ---------------------------- build_phase --------------------------
function void input_mul::build_phase(uvm_phase phase);
  super.build_phase(phase);

  // Get virtual interface from agent
  if (!uvm_config_db#(virtual mul_intf)::get(this, "", "mul_vif", v_intf))
    `uvm_fatal(get_full_name(), "couldn't get interface from agent");
endfunction : build_phase
// -------------------------------------------------------------------

// ----------------------------- run_phase ---------------------------
task input_mul::run_phase(uvm_phase phase);
  forever begin
    mult_transaction seq_itm;
    seq_itm = new();

    @(posedge v_intf.clk);
    #1;

    if (v_intf.enable_i && v_intf.ready_o) begin
      seq_itm.op_a_i         = v_intf.op_a_i;
      seq_itm.op_b_i         = v_intf.op_b_i;
      seq_itm.short_signed_i = v_intf.short_signed_i;
      seq_itm.operator_i     = v_intf.operator_i;

      analysis_port.write(seq_itm);
    end
  end
endtask : run_phase
// -------------------------------------------------------------------
