class interr_driver extends uvm_driver #(seq_item);

  // factory registration   
  `uvm_component_utils(interr_driver)
  
  virtual interrupt_intf v_intf;

  extern function new(string name = "interr_driver", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass

// -------------------------- constructor -----------------------------
function interr_driver::new(string name = "interr_driver", uvm_component parent = null);
  super.new(name, parent);
endfunction : new
// ---------------------------------------------------------------------

// ------------------------------ build_phase -----------------------------
function void interr_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_full_name(), "interr_driver CLASS", UVM_NONE);

  // --------------------------- get virtual interface from agent -----------------
  if (!uvm_config_db#(virtual interrupt_intf)::get(this, "", "interr_vif", v_intf))
    `uvm_fatal(get_full_name(), "couldn't get interface from agent");
  // ------------------------------------------------------------------------------
endfunction : build_phase
// --------------------------------------------------------------------------

// ------------------------------ run_phase -----------------------------
task interr_driver::run_phase(uvm_phase phase);
  seq_item sequ_item;
  begin
    v_intf.irq_i <= 31'b0;
  end
endtask : run_phase
