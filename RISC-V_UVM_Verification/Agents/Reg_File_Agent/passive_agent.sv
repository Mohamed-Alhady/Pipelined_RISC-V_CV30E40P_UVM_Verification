class Passive_agent extends uvm_agent;

  // Factory registration
  `uvm_component_utils(Passive_agent)

  // Monitors and scoreboard
  input_mul   input_monitor;
  output_mul  output_monitor;
  mul_sb      sb;
  output_alu_monitor out_mon;
  input_alu_monitor   in_monitor ;
  alu_scoreboard   alu_scb ;
  
   input_reg_monitor   in_reg_monitor ;
   reg_scoreboard   reg_scb ;

  // Constructor and UVM phase methods
  extern function new(string name = "Passive_agent", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);

endclass : Passive_agent

// -------------------------- Constructor -----------------------------
function Passive_agent::new(string name = "Passive_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction : new
// -------------------------------------------------------------------

// -------------------------- Build Phase -----------------------------
function void Passive_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
      out_mon = output_alu_monitor::type_id::create("out_mon", this);
      in_monitor = input_alu_monitor::type_id::create("in_monitor", this);
      alu_scb = alu_scoreboard::type_id::create("alu_scb", this);
      
  sb             = mul_sb::type_id::create("sb", this);
  input_monitor  = input_mul::type_id::create("input_monitor", this);
  output_monitor = output_mul::type_id::create("output_monitor", this);

    reg_scb             = reg_scoreboard::type_id::create("reg_scb", this);
  in_reg_monitor  = input_reg_monitor::type_id::create("in_reg_monitor", this);
  
endfunction : build_phase
// -------------------------------------------------------------------

// -------------------------- Connect Phase ---------------------------
function void Passive_agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
   
  // Connect monitors to scoreboard
out_mon.ap.connect(alu_scb.analysis_sb_output);
  in_monitor.ap.connect(alu_scb.analysis_sb_input);
  input_monitor.analysis_port.connect(sb.analysis_sb_input);
  output_monitor.analysis_port.connect(sb.analysis_sb_output);

  in_reg_monitor.analysis_port.connect(reg_scb.analysis_sb_input);
  
endfunction : connect_phase
// -------------------------------------------------------------------
