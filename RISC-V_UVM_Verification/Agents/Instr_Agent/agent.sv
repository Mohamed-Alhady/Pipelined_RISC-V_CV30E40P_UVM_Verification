class instr_agent extends uvm_agent;
  // Factory registration
  `uvm_component_utils(instr_agent)

  // Component handles
  instr_driver instr_drv;
  instr_in_mon in_mon;
  instr_out_mon out_mon;
  instr_sequencer instr_seqr;
  instruction_config agt;

  // Virtual interface
 

  // Analysis ports
  uvm_analysis_port #(seq_item) instr_analysis_input_mon;
  uvm_analysis_port #(seq_item) instr_analysis_output_mon;

  // Constructor
  function new(string name = "instr_agent", uvm_component parent = null);
    super.new(name, parent);
    instr_analysis_input_mon  = new("instr_analysis_input_mon", this);
    instr_analysis_output_mon = new("instr_analysis_output_mon", this);
  endfunction

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "instr_agent: build_phase", UVM_LOW);

    // Get agent config
    if (!uvm_config_db#(instruction_config)::get(this, "", "my_agt", agt))
      `uvm_fatal(get_full_name(), "Failed to get instruction_config from config_db");

    // Create components
    if (agt.agent_active == UVM_ACTIVE) begin
      instr_seqr = instr_sequencer::type_id::create("instr_seqr", this);
      instr_drv  = instr_driver::type_id::create("instr_drv", this);
    end
    in_mon  = instr_in_mon::type_id::create("in_mon", this);
    out_mon = instr_out_mon::type_id::create("out_mon", this);
  endfunction

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (agt.agent_active == UVM_ACTIVE) begin
      instr_drv.seq_item_port.connect(instr_seqr.seq_item_export);
      out_mon.analysis_port_return.connect(instr_seqr.analysis_export); // Optional
    end

    // Connect monitors to analysis ports
    in_mon.analysis_port.connect(instr_analysis_input_mon);
    out_mon.analysis_port.connect(instr_analysis_output_mon);
  endfunction

endclass
