
`include "Assertions/Data_Assertions.sv"
module top ();
  import uvm_pkg::*;
  import pack::*;

  bit clk;

  instruction_intf instr_inf(clk, config_inf.rst_n);
  interrupt_intf   interr_intf(clk, config_inf.rst_n);
  data_intf        data_inf(clk, config_inf.rst_n);
  debug_intf       debug_inf(clk, config_inf.rst_n);
  config_intf      config_inf(clk);

  always #5 clk = ~clk;

  cv32e40p_top DUT (
    // Clock and Reset
    .rst_ni              (config_inf.rst_n),
    .clk_i               (clk),

    .pulp_clock_en_i     (config_inf.pulp_clock_en),   // PULP clock enable (only used if COREV_CLUSTER = 1)
    .scan_cg_en_i        (config_inf.scan_cg_en),      // Enable all clock gates for testing

    // Core ID, Cluster ID, debug mode halt address and boot address
    .boot_addr_i         (config_inf.boot_addr),
    .mtvec_addr_i        (config_inf.mtvec_addr),
    .dm_halt_addr_i      (config_inf.dm_halt_addr),
    .hart_id_i           (config_inf.hart_id),
    .dm_exception_addr_i (config_inf.dm_exception_addr),

    // CPU Control Signals
    .fetch_enable_i      (config_inf.fetch_enable),
    .core_sleep_o        (config_inf.core_sleep_o),

    // Debug interface
    .debug_req_i         (debug_inf.debug_req_i),
    .debug_havereset_o   (debug_inf.debug_havereset_o),
    .debug_running_o     (debug_inf.debug_running_o),
    .debug_halted_o      (debug_inf.debug_halted_o),

    // Interrupt interface
    .irq_i               (interr_intf.irq_i),
    .irq_ack_o           (interr_intf.irq_ack_o),
    .irq_id_o            (interr_intf.irq_id_o),

    // Instruction memory interface
    .instr_rdata_i       (instr_inf.instr_rdata_i),
    .instr_req_o         (instr_inf.instr_req_o),
    .instr_gnt_i         (instr_inf.instr_gnt_i),
    .instr_rvalid_i      (instr_inf.instr_rvalid_i),
    .instr_addr_o        (instr_inf.instr_addr_o),

    // Data memory interface
    .data_req_o          (data_inf.data_req_o),
    .data_gnt_i          (data_inf.data_gnt_i),
    .data_rvalid_i       (data_inf.data_rvalid_i),
    .data_we_o           (data_inf.data_we_o),
    .data_be_o           (data_inf.data_be_o),
    .data_addr_o         (data_inf.data_addr_o),
    .data_wdata_o        (data_inf.data_wdata_o),
    .data_rdata_i        (data_inf.data_rdata_i)
  );

 
 bind DUT.core_i.ex_stage_i.mult_i mul_intf mul_inf(
                                                    .clk           (clk),
                                                    .rst_n         (rst_n),
                                                    .enable_i      (enable_i),
                                                    .ex_ready_i    (ex_ready_i),
                                                    .operator_i    (operator_i),
                                                    .op_a_i        (op_a_i),
                                                    .op_b_i        (op_b_i),
                                                    .op_c_i        (op_c_i),
                                                    .imm_i         (imm_i),
                                                    .short_signed_i(short_signed_i),
                                                    .result_o      (result_o), 
                                                    .ready_o       (ready_o)   );

  bind DUT.core_i.ex_stage_i.alu_i alu_intf alu_inf(
                                                    .clk                (clk),
                                                    .rst_n              (rst_n),
                                                    .ready_o            (ready_o),
                                                    .enable_i           (enable_i),
                                                    .result_o           (result_o),
                                                    .ex_ready_i         (ex_ready_i),
                                                    .operator_i         (operator_i),
                                                    .operand_a_i        (operand_a_i),
                                                    .operand_b_i        (operand_b_i),
                                                    .operand_c_i        (operand_c_i),
                                                    .vector_mode_i      (vector_mode_i),
                                                    .bmask_a_i          (bmask_a_i),
                                                    .bmask_b_i          (bmask_b_i),
                                                    .imm_vec_ext_i      (imm_vec_ext_i),
                                                    .is_clpx_i          (is_clpx_i),
                                                    .is_subrot_i        (is_subrot_i),
                                                    .clpx_shift_i       (clpx_shift_i),
                                                    .comparison_result_o(comparison_result_o)   );
													

bind DUT.core_i.id_stage_i.register_file_i reg_intf reg_inf(
                                                    .clk         (clk),
                                                    .rst_n       (rst_n),
                                                    .scan_cg_en_i(scan_cg_en_i),
                                                    .raddr_a_i   (raddr_a_i),
                                                    .rdata_a_o   (rdata_a_o),
                                                    .raddr_b_i   (raddr_b_i),
                                                    .rdata_b_o   (rdata_b_o),
                                                    .raddr_c_i   (raddr_c_i),
                                                    .rdata_c_o   (rdata_c_o),
                                                    .waddr_a_i   (waddr_a_i),
                                                    .wdata_a_i   (wdata_a_i),
                                                    .we_a_i      (we_a_i),
                                                    .waddr_b_i   (waddr_b_i),
                                                    .wdata_b_i   (wdata_b_i),
                                                    .we_b_i      (we_b_i));																				
													
													
	bind DUT Data_SVA D_SVA(
	
	.clk			(clk_i			)	,
	.rst_n		    (rst_ni			)   ,
	.data_req_o     (data_req_o   	)   ,
	.data_gnt_i     (data_gnt_i   	)   ,
	.data_addr_o    (data_addr_o  	)   ,
	.data_we_o      (data_we_o    	)   ,
	.data_be_o	    (data_be_o		)   ,
	.data_wdata_o   (data_wdata_o 	)   ,
	.data_rvalid_i  (data_rvalid_i	)   ,
	.data_rdata_i   (data_rdata_i	)
	
	
	
	
	);

  initial begin 
    // Set virtual interfaces in UVM test
    uvm_config_db#(virtual instruction_intf)::set(null, "*", "instr_vif",  instr_inf);
    uvm_config_db#(virtual data_intf)::set      (null, "*", "data_vif", data_inf);    
    uvm_config_db#(virtual config_intf)::set    (null, "*", "config_vif", config_inf); 
    uvm_config_db#(virtual interrupt_intf)::set (null, "*", "interr_vif", interr_intf); 
    uvm_config_db#(virtual debug_intf)::set     (null, "*", "debug_vif", debug_inf);  
    uvm_config_db#(virtual mul_intf)::set       (null, "*", "mul_vif", DUT.core_i.ex_stage_i.mult_i.mul_inf);
    uvm_config_db#(virtual alu_intf)::set       (null, "*", "alu_vif", DUT.core_i.ex_stage_i.alu_i.alu_inf);   
	uvm_config_db#(virtual reg_intf)::set       (null, "*", "reg_inf", DUT.core_i.id_stage_i.register_file_i.reg_inf);   
	
    run_test();
  end
initial begin

$dumpfile("top.fsdb");//.vcd
    $vcdpluson;
    //$dumpvars;

 $dumpfile("wave.vpd") ; // for dumping and save output signals  $dumpvars(0,top);

end

endmodule : top

 
