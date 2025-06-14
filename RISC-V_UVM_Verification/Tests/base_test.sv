class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  environment                env;
  env_config                 env_configer;
  v_config_seq v_conf_seq;
  v_reset_seq v_rst_seq;
  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void set_env_configration(env_config set_config);
    set_config.has_scoreboard        = 1;
    set_config.has_coverage          = 1;
    set_config.has_data_agent        = 1;
    set_config.has_instruction_agent = 1;
    set_config.has_interrupt_agent   = 1;
    set_config.has_debug_agent       = 1;
    set_config.has_config_agent      = 1;
    set_config.has_passive_agent     = 1;
  endfunction : set_env_configration

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env_configer = env_config::type_id::create("env_configer");

    // Set config in UVM and agent
    set_env_configration(env_configer);
    v_rst_seq     = v_reset_seq::type_id::create("v_rst_seq");
    env           = environment::type_id::create("env", this);
    v_conf_seq      = v_config_seq::type_id::create("v_conf_seq");

    uvm_config_db#(env_config)::set(this, "env", "my_config", env_configer);
  endfunction

  // Print Testbench structure and factory contents
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    if (uvm_report_enabled(UVM_MEDIUM)) begin
      this.print();
      //factory.print();
    end
  endfunction : start_of_simulation_phase

  virtual task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
    phase.raise_objection(this);
      v_rst_seq.start(env.sqr);
    phase.drop_objection(this);
  endtask : reset_phase

  virtual task configure_phase(uvm_phase phase);
    super.configure_phase(phase);
    phase.raise_objection(this);
      v_conf_seq.start(env.sqr);
    phase.drop_objection(this);
  endtask : configure_phase


endclass
