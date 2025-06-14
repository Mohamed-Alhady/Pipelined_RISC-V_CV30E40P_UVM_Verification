class reg_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(reg_scoreboard)

  function new(string name = "reg_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  uvm_analysis_export #(reg_transaction) analysis_sb_input;
  uvm_tlm_analysis_fifo #(reg_transaction) data_from_input;

  reg_transaction in_data, out_data;

  bit [31:0] ref_mem [31:0];
  bit [31:0] rs1,rs2;
  int NO_pass, NO_fail;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_sb_input = new("analysis_sb_input", this);
    data_from_input = new("data_from_input", this);

    in_data = reg_transaction::type_id::create("in_data");
    out_data = reg_transaction::type_id::create("out_data");
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    analysis_sb_input.connect(data_from_input.analysis_export);
   
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      data_from_input.get(in_data);
   
      rs1 = ref_mem[in_data.raddr_a_i];
      rs2 = ref_mem[in_data.raddr_b_i];
      if(in_data.we_b_i )begin
        ref_mem[in_data.waddr_b_i] = in_data.wdata_b_i ;
        
      end

      
      if(in_data.we_a_i)begin
        

        ref_mem[in_data.waddr_a_i] = in_data.wdata_a_i ;
        
      end
ref_mem[0] = 32'b0;
      if ((rs1 == in_data.rdata_a_o ) && (rs2 == in_data.rdata_b_o ) ) begin
        NO_pass++;

        `uvm_info(get_type_name(), $sformatf("PASS: reg_scoreboard"), UVM_NONE)
      end else begin
        NO_fail++;

      `uvm_info(get_type_name(), $sformatf("FAIL: reg_scoreboard"), UVM_NONE)
      end
    end
  endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("=================================================================================================================");
    `uvm_info(get_full_name(), $sformatf("No Of Pass_transaction in reg Block = %d", NO_pass), UVM_NONE)
    `uvm_info(get_full_name(), $sformatf("No Of Fail_transaction in reg Block = %d", NO_fail), UVM_NONE)
    $display("=================================================================================================================");
  endfunction : report_phase

endclass : reg_scoreboard
