class input_reg_monitor extends uvm_monitor;

  // Factory registration
  `uvm_component_utils(input_reg_monitor)

  uvm_analysis_port#(reg_transaction) analysis_port;
  virtual reg_intf v_intf;

  extern function new(string name = "input_reg_monitor", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

endclass : input_reg_monitor

// -------------------------- Constructor -----------------------------
function input_reg_monitor::new(string name = "input_reg_monitor", uvm_component parent = null);
  super.new(name, parent);
  analysis_port = new("analysis_port", this);
endfunction : new
// -------------------------------------------------------------------

// ---------------------------- build_phase --------------------------
function void input_reg_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);

  // Get virtual interface from agent
  if (!uvm_config_db#(virtual reg_intf)::get(this, "", "reg_inf", v_intf))
    `uvm_fatal(get_full_name(), "couldn't get interface from agent");
endfunction : build_phase
// -------------------------------------------------------------------

// ----------------------------- run_phase ---------------------------
task input_reg_monitor::run_phase(uvm_phase phase);
  forever begin
    reg_transaction seq_itm;
    seq_itm = new();

    @(posedge v_intf.clk);
    #1;

    begin
       seq_itm.raddr_a_i = v_intf.raddr_a_i;
       seq_itm.rdata_a_o = v_intf.rdata_a_o;
       seq_itm.raddr_b_i = v_intf.raddr_b_i;
       seq_itm.rdata_b_o = v_intf.rdata_b_o;
       seq_itm.raddr_c_i = v_intf.raddr_c_i;
       seq_itm.rdata_c_o = v_intf.rdata_c_o;
       seq_itm.waddr_a_i = v_intf.waddr_a_i;
       seq_itm.wdata_a_i = v_intf.wdata_a_i;
       seq_itm.we_a_i    = v_intf.we_a_i;  
       seq_itm.waddr_b_i = v_intf.waddr_b_i;
       seq_itm.wdata_b_i = v_intf.wdata_b_i;
       seq_itm.we_b_i    = v_intf.we_b_i; 
      analysis_port.write(seq_itm);
    end
  end
endtask : run_phase
// -------------------------------------------------------------------
