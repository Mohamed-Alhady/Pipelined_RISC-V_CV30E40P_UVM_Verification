//import cv32e40p_pkg::*;

class alu_scoreboard extends uvm_component;

  `uvm_component_utils(alu_scoreboard)

  // Analysis ports and FIFOs
  uvm_analysis_export #(alu_transaction) analysis_sb_input;
  uvm_tlm_analysis_fifo #(alu_transaction) data_from_input;

  uvm_analysis_export #(alu_transaction) analysis_sb_output;
  uvm_tlm_analysis_fifo #(alu_transaction) data_from_output;

  // Transaction handles
  alu_transaction in_data, out_data;

  // Internal variables
  bit [31:0] expected_result;
  int NO_pass, NO_fail;

  // Constructor
  function new(string name = "alu_scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    analysis_sb_input  = new("analysis_sb_input", this);
    data_from_input    = new("data_from_input", this);

    analysis_sb_output = new("analysis_sb_output", this);
    data_from_output   = new("data_from_output", this);

    in_data  = alu_transaction::type_id::create("in_data");
    out_data = alu_transaction::type_id::create("out_data");
  endfunction : build_phase

  // Connect phase
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    analysis_sb_input.connect(data_from_input.analysis_export);
    analysis_sb_output.connect(data_from_output.analysis_export);
  endfunction : connect_phase

  // Golden model
  function logic [31:0] golden_model();
    logic [31:0] op_a, op_b;
    bit [31:0] expect_result;
    op_a = in_data.operand_a;
    op_b = in_data.operand_b;

    case (in_data.operator)
      // Arithmetic
      ALU_ADD : expect_result = op_a + op_b;
      ALU_SUB : expect_result = op_a - op_b;

      // Logical
      ALU_XOR : expect_result = op_a ^ op_b;
      ALU_OR  : expect_result = op_a | op_b;
      ALU_AND : expect_result = op_a & op_b;

      // Shifts
      ALU_SLL : expect_result = op_a << op_b[4:0];
      ALU_SRL : expect_result = op_a >> op_b[4:0];
      ALU_SRA : expect_result = $signed(op_a) >>> op_b[4:0];

      // Set-less-than
      ALU_SLTS: expect_result = ($signed(op_a) < $signed(op_b)) ? 32'd1 : 32'd0;
      ALU_SLTU: expect_result = (op_a < op_b) ? 32'd1 : 32'd0;

      // Division
      ALU_DIV : begin
        if (op_a == 0)
          expect_result = 32'hFFFF_FFFF;
        else if (op_b == 32'h80000000 && op_a == 32'hFFFF_FFFF)
          expect_result = op_b;
        else
          expect_result = $signed(op_b) / $signed(op_a);
      end

      ALU_DIVU : begin
        if (op_a == 0)
          expect_result = 32'hFFFF_FFFF;
        else
          expect_result = op_b / op_a;
      end

      // Remainder
      ALU_REM : begin
        if (op_a == 0)
          expect_result = op_b;
        else if (op_b == 32'h80000000 && op_a == 32'hFFFF_FFFF)
          expect_result = 0;
        else
          expect_result = $signed(op_b) % $signed(op_a);
      end

      ALU_REMU : begin
        if (op_a == 0)
          expect_result = op_b;
        else
          expect_result = op_b % op_a;
      end
      ALU_EQ: begin
        if (op_a == op_b)
          expect_result = 0;
          end
      ALU_NE: begin
        if (op_a != op_b)
           expect_result = 0;
          
      end
      ALU_LTS: begin
        if ($signed(op_a) < $signed(op_b))
          expect_result = 0;
           
      end
      ALU_GES: begin
        if ($signed(op_a) >= $signed(op_b))
          expect_result = 0;
           
      end
      ALU_LTU: begin
        if (op_a < op_b)
          expect_result = 0;
           
      end
      ALU_GEU: begin
        if (op_a >= op_b)
          expect_result = 0;
            
      end
     
    endcase

    return expect_result;
  endfunction : golden_model

  // Run phase
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      data_from_input.get(in_data);
      data_from_output.get(out_data);
      
      expected_result = golden_model();
      if((in_data.operator != ALU_EQ) &&(in_data.operator != ALU_NE) &&(in_data.operator != ALU_LTS) && (in_data.operator !=ALU_GES) &&(in_data.operator != ALU_LTU) && (in_data.operator !=ALU_GEU))begin
      if (expected_result == out_data.result) begin
        NO_pass++;
        `uvm_info(get_type_name(),
                  $sformatf("PASS: actual = %0d, expected = %0d", out_data.result, expected_result),
                  UVM_NONE)
      end else begin
        NO_fail++;
        `uvm_info(get_type_name(),
                  $sformatf("FAIL: actual = %0d, expected = %0d ", out_data.result, expected_result),
                  UVM_NONE)
      end
    end
    end
  endtask : run_phase

  // Report phase
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    $display("=================================================================================================================");
    `uvm_info(get_full_name(), $sformatf("No Of Pass_transaction in ALU Block = %d", NO_pass), UVM_NONE)
    `uvm_info(get_full_name(), $sformatf("No Of Fail_transaction in ALU Block = %d", NO_fail), UVM_NONE)
    $display("=================================================================================================================");
  endfunction : report_phase

endclass : alu_scoreboard



