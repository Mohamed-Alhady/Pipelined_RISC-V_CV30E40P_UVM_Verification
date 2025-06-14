class zero_ones_l_test extends base_test;
  `uvm_component_utils(zero_ones_l_test)

  function new(string name = "zero_ones_l_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
 
  v_zero_ones_l_seq v_seq;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
   v_seq    = v_zero_ones_l_seq::type_id::create("v_seq");
    
  endfunction

  // Print Testbench structure and factory contents
  virtual function void start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
  endfunction : start_of_simulation_phase

  virtual task reset_phase(uvm_phase phase);
    super.reset_phase(phase);
  endtask : reset_phase

  virtual task configure_phase(uvm_phase phase);
    super.configure_phase(phase);
  endtask : configure_phase

  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    phase.raise_objection(this);

    v_seq.start(env.sqr);

    phase.phase_done.set_drain_time(this, 500);

    phase.drop_objection(this);
  endtask : main_phase

endclass
