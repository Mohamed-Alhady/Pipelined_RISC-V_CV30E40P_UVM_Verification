class env_config extends uvm_object;

  `uvm_object_utils(env_config)

  function new(string name = "env_config");
    super.new(name);
  endfunction : new

 

  bit has_scoreboard;
  bit has_coverage;
  bit has_data_agent;
  bit has_instruction_agent;
  bit has_interrupt_agent;
  bit has_debug_agent;
  bit has_config_agent;
  bit has_passive_agent;
endclass : env_config
