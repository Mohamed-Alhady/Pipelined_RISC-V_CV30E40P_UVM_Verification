class mul_sb extends uvm_scoreboard;

  `uvm_component_utils(mul_sb)

  function new(string name = "mul_sb", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  uvm_analysis_export #(mult_transaction) analysis_sb_input;
  uvm_tlm_analysis_fifo #(mult_transaction) data_from_input;

  uvm_analysis_export #(mult_transaction) analysis_sb_output;
  uvm_tlm_analysis_fifo #(mult_transaction) data_from_output;

  mult_transaction in_data, out_data;

  logic [31:0] expected_result;
  int NO_pass, NO_fail;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_sb_input = new("analysis_sb_input", this);
    data_from_input = new("data_from_input", this);

    analysis_sb_output = new("analysis_sb_output", this);
    data_from_output = new("data_from_output", this);

    in_data = mult_transaction::type_id::create("in_data");
    out_data = mult_transaction::type_id::create("out_data");
  endfunction : build_phase

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    analysis_sb_input.connect(data_from_input.analysis_export);
    analysis_sb_output.connect(data_from_output.analysis_export);
  endfunction

  function logic [31:0] golden_model();
    logic [31:0] expected_result, op_a, op_b;
    logic [63:0] result;

    op_a = in_data.op_b_i;
    op_b = in_data.op_a_i;

    case (in_data.operator_i)
      3'b000: begin
        expected_result = ($signed(op_a)) * ($signed(op_b)); //MUL
      end

      3'b110: begin 
        case (in_data.short_signed_i)
          2'b11: begin
            result = ($signed(op_a)) * ($signed(op_b));  // check multiplication result for mulh
            expected_result = result[63:32];
          end
          2'b01: begin
            
             result =$signed(op_a) * op_b ;  // check multiplication result for mulhsu
             expected_result = result[63:32];

          end
          2'b00: begin
            result = op_a * op_b; // check multiplication result for mulhu
            expected_result = result[63:32];
          end
        endcase
      end
    endcase

    return expected_result;
  endfunction : golden_model

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      data_from_input.get(in_data);
      data_from_output.get(out_data);
      expected_result = golden_model();

      if (expected_result == out_data.result_o) begin
        NO_pass++;

        `uvm_info(get_type_name(), $sformatf("PASS: actual = %0d, expected = %0d", out_data.result_o, expected_result), UVM_NONE)
      end else begin
        NO_fail++;
        
        $display("sign",in_data.short_signed_i);
        $display("oper",in_data.operator_i);
        `uvm_info(get_type_name(), $sformatf("FAIL: actual = %0d, expected = %0d", out_data.result_o, expected_result), UVM_NONE)
      end
    end
  endtask

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("=================================================================================================================");
    `uvm_info(get_full_name(), $sformatf("No Of Pass_transaction in MUL Block = %d", NO_pass), UVM_NONE)
    `uvm_info(get_full_name(), $sformatf("No Of Fail_transaction in MUL Block = %d", NO_fail), UVM_NONE)
    $display("=================================================================================================================");
  endfunction : report_phase

endclass : mul_sb
