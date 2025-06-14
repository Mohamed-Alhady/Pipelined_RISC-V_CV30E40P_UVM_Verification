class interr_agent extends uvm_agent;
  // Factory registration
  `uvm_component_utils(interr_agent)

  // Class handles
  interr_driver drv;
  interr_mon in_mon;
  interr_sequencer sequr;
  interrupt_config agt;

  // Virtual interface
  virtual interrupt_intf vif;

  uvm_analysis_port #(seq_item) analysis_port_agent1;

  //-------------------------- Constructor -----------------------------
  function new(string name = "agent", uvm_component parent = null);
    super.new(name, parent);
    analysis_port_agent1 = new("analysis_port_agent1", this);
  endfunction
  //---------------------------------------------------------------------

  //------------------------------ build_phase -----------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "AGENT CLASS", UVM_NONE);

    //---------------------------- Get virtual interface from env ------------------
    if (!uvm_config_db#(interrupt_config)::get(this, "", "interr_agt", agt))
      `uvm_fatal(get_full_name(), "in agent");

    // Check if agent is Active or Passive
    if (agt.agent_active == UVM_ACTIVE) begin
      sequr = interr_sequencer::type_id::create("sequr", this);
      drv  = interr_driver::type_id::create("drv", this);
    end
    in_mon = interr_mon::type_id::create("in_mon", this);
  endfunction
  //----------------------------------------------------------------------
  
  //------------------------------ connect_phase -----------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (agt.agent_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(sequr.seq_item_export);    
    end
    in_mon.analysis_port.connect(analysis_port_agent1);
  endfunction : connect_phase
  //----------------------------------------------------------------------
  
endclass
