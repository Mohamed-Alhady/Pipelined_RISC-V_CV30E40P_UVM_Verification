// Passive ALU Agent
  class alu_passive_agent extends uvm_agent;
    `uvm_component_utils(alu_passive_agent)
    
    alu_monitor 	monitor	;
   alu_scoreboard 	alu_scb	;
   
    //uvm_analysis_port #(alu_transaction) ap;
    
    function new(string name, uvm_component parent);
      super.new(name, parent);
      
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      monitor = alu_monitor::type_id::create("monitor", this);
      alu_scb = alu_scoreboard::type_id::create("alu_scb", this);
      
    endfunction
    
    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      monitor.ap.connect(alu_scb.mon_imp);
      
    endfunction
	
 
	
  endclass