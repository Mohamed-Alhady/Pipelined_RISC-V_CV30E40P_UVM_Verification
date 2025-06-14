class debug_driver extends uvm_driver #(seq_item);

  // factory registration   
  `uvm_component_utils(debug_driver)
  virtual debug_intf v_intf;

  extern function new(string name = "debug_driver", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  

endclass

  // -------------------------- constructor -----------------------------
  function debug_driver::new(string name = "debug_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  // ---------------------------------------------------------------------

  // ------------------------------ build_phase -----------------------------
  function void debug_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "debug_driver CLASS", UVM_NONE);

    // --------------------------- get virtual interface from agent -----------------
    if (!uvm_config_db#(virtual debug_intf)::get(this, "", "debug_vif", v_intf))
      `uvm_fatal(get_full_name(), "couldn't get interface from agent");
    // ------------------------------------------------------------------------------
  endfunction : build_phase
  // --------------------------------------------------------------------------

  // ------------------------------ run_phase -----------------------------
  task debug_driver::run_phase(uvm_phase phase);
    seq_item sequ_item;
      begin
 
 
      v_intf.debug_req_i     <= 31'b0;
      
 
    end
  endtask : run_phase
  // --------------------------------------------------------------------------
 
