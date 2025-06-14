class instr_out_mon extends uvm_monitor;

  // factory registration    
  `uvm_component_utils(instr_out_mon)

  uvm_analysis_port#(seq_item) analysis_port;
  uvm_analysis_port#(seq_item) analysis_port_return;

  virtual instruction_intf v_intf;
  
  extern function new(string name = "instr_out_mon", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
    
endclass

  // -------------------------- constructor -----------------------------
  function instr_out_mon::new(string name = "instr_out_mon", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
    analysis_port_return = new("analysis_port_return", this);
  endfunction : new
  // ---------------------------------------------------------------------

  

  // ------------------------------ build_phase -----------------------------
  function void instr_out_mon::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "instr_out_mon CLASS", UVM_NONE);

    // ------------------------ Get virtual interface from agent ----------------
    if (!uvm_config_db#(virtual instruction_intf)::get(this, "", "instr_vif", v_intf))
      `uvm_fatal(get_full_name(), "couldn't get interface from agent");
    // --------------------------------------------------------------------------
  endfunction : build_phase
  // --------------------------------------------------------------------------

  // ------------------------------ run_phase -----------------------------
  task instr_out_mon::run_phase(uvm_phase phase);
    forever begin
      @(posedge v_intf.clk);
      #2;

      if (v_intf.rst_n) begin
        seq_item seq_itm;
        seq_itm = new();
        
        seq_itm.instr_addr_o     = v_intf.instr_addr_o;    
        seq_itm.instr_req_o      = v_intf.instr_req_o;     
        seq_itm.instr_gnt_i      = v_intf.instr_gnt_i;      
        seq_itm.instr_rvalid_i   = v_intf.instr_rvalid_i;  
        seq_itm.instr_rdata_i		     = v_intf.instr_rdata_i;   
        analysis_port.write(seq_itm); 
        analysis_port_return.write(seq_itm);  // Monitor DUT output and deliver transaction to the sequencer
      end
    end
  endtask : run_phase
  // --------------------------------------------------------------------------
