class environment extends uvm_env;
  `uvm_component_utils(environment)

   CV32E40P_Predictor score;
  Coverage_Collector sub;

  instr_agent             agnt;
  CV32E40P_Data_Agent     data_agt;
  debug_agent             debug_agt;
  config_agent            config_agt;
  interr_agent            interr_agt;

  env_config              my_agt_config;
  Passive_agent           Passive_agt;
  instruction_config      instr_config;
  interrupt_config        intr_config;
  debug_config            debug_confg;
  data_Config             data_config;
  configuration_config    config_config;

  v_sqr                   sqr;
 

  function new(string name = "environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void set_agent_configuration(instruction_config set_agt_config);
    set_agt_config.agent_active = UVM_ACTIVE;
  endfunction

  function void set_data_agent_configuration(data_Config set_agt_config);
    set_agt_config.agent_active = UVM_ACTIVE;
  endfunction

  function void set_interr_agent_configuration(interrupt_config set_agt_config);
    set_agt_config.agent_active = UVM_ACTIVE;
  endfunction

  function void set_debug_agent_configuration(debug_config set_agt_config);
    set_agt_config.agent_active = UVM_ACTIVE;
  endfunction

  function void set_configuration_agent_configuration(configuration_config set_agt_config);
    set_agt_config.agent_active = UVM_ACTIVE;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get virtual interface configuration from test
    if (!uvm_config_db#(env_config)::get(this, "", "my_config", my_agt_config))
      `uvm_info(get_full_name(), "in env", UVM_NONE);

    sqr = v_sqr::type_id::create("sqr", this);

    // Instantiate components conditionally
    if (my_agt_config.has_scoreboard) begin
       score = CV32E40P_Predictor::type_id::create("score", this);
       `uvm_info(get_type_name(), "CREATE CV32E40P_Predictor", UVM_NONE);
    end
    if(my_agt_config.has_passive_agent)
    Passive_agt = Passive_agent::type_id::create("Passive_agt", this); 

    if (my_agt_config.has_instruction_agent)
      agnt = instr_agent::type_id::create("agnt", this);

    if (my_agt_config.has_data_agent)
      data_agt = CV32E40P_Data_Agent::type_id::create("data_agt", this);

    if (my_agt_config.has_config_agent)
      config_agt = config_agent::type_id::create("config_agt", this);

    if (my_agt_config.has_interrupt_agent)
      interr_agt = interr_agent::type_id::create("interr_agt", this);

    if (my_agt_config.has_debug_agent)
      debug_agt = debug_agent::type_id::create("debug_agt", this);

    if (my_agt_config.has_coverage)
     sub = Coverage_Collector::type_id::create("sub", this);

    // Create config objects
    data_config      = data_Config::type_id::create("data_config");
    instr_config     = instruction_config::type_id::create("instr_config");
    intr_config      = interrupt_config::type_id::create("intr_config");
    debug_confg      = debug_config::type_id::create("debug_confg");
    config_config    = configuration_config::type_id::create("config_config");

    // Set config values
    set_agent_configuration(instr_config);
    set_data_agent_configuration(data_config);
    set_interr_agent_configuration(intr_config);
    set_debug_agent_configuration(debug_confg);
    set_configuration_agent_configuration(config_config);

    // Set UVM config DB
    uvm_config_db#(instruction_config)::set(this, "agnt", "my_agt", instr_config);
    uvm_config_db#(data_Config)::set(this, "data_agt", "data_agt", data_config);
    uvm_config_db#(interrupt_config)::set(this, "interr_agt", "interr_agt", intr_config);
    uvm_config_db#(debug_config)::set(this, "debug_agt", "debug_agt", debug_confg);
    uvm_config_db#(configuration_config)::set(this, "config_agt", "config_agt", config_config);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
	
    if (my_agt_config.has_instruction_agent)
      sqr.instr_sqr   = agnt.instr_seqr;

    if (my_agt_config.has_data_agent)
      sqr.data_sqr    = data_agt.d_sequencer;

    if (my_agt_config.has_config_agent)
      sqr.config_sqr  = config_agt.sequencer;

    if (my_agt_config.has_interrupt_agent)
      sqr.interr_sqr  = interr_agt.sequr;

    if (my_agt_config.has_debug_agent)
      sqr.debug_sqr   = debug_agt.sequr;
 
     if (my_agt_config.has_scoreboard) begin
       agnt.instr_analysis_input_mon.connect(score.instr_in_analysis_imp);
	   agnt.instr_analysis_output_mon.connect(score.instr_out_analysis_imp);

end
    if (my_agt_config.has_coverage) begin
      agnt.instr_analysis_input_mon.connect(sub.inst_port);
	  data_agt.ag_in_analysis_port.connect(sub.data_port);
	  
	  end
  endfunction

endclass
