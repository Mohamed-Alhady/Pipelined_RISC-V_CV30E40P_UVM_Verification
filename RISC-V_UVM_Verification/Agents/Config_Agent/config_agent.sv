// ======================
// config_agent.sv
// ======================

class config_agent extends uvm_agent;
  
  config_sequencer sequencer;
  config_driver    driver;
  config_monitor   monitor;
  configuration_config configur;
  virtual config_intf vif;

  `uvm_component_utils(config_agent)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(configuration_config)::get(this, "", "config_agt", configur))
      `uvm_fatal(get_full_name(), "configur agent");

    if (configur.agent_active == UVM_ACTIVE) begin
      sequencer = config_sequencer::type_id::create("sequencer", this);
      driver    = config_driver::type_id::create("driver", this);
    end
    monitor = config_monitor::type_id::create("monitor", this);

    uvm_config_db#(virtual config_intf)::set(this, "driver", "vif", vif);
    uvm_config_db#(virtual config_intf)::set(this, "monitor", "vif", vif);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (configur.agent_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass
