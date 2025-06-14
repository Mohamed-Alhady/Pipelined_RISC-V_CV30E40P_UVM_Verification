
package pack;
	
import cv32e40p_pkg::*;
    import uvm_pkg::*;
    
	
    // UVM macros and common models
    `include "uvm_macros.svh"
    `include "storage_model.sv"
	

    // Instruction Agent files

    `include "Agents/Instr_Agent/agent_config.sv"
    `include "env_config.sv"
    `include "Agents/Instr_Agent/driver_config.sv"
    `include "Seq_Items/seq_item.sv"
    `include "Agents/Alu_Agent/seq_item_alu.sv"
    `include "Agents/Instr_Agent/driver.sv"
    `include "Agents/Instr_Agent/input_monitor.sv"
    `include "Agents/Instr_Agent/output_monitor.sv"
    `include "Agents/Instr_Agent/sequencer.sv"
    `include "Agents/Instr_Agent/agent.sv"
	
	
	`include "Agents/Reg_File_Agent/reg_transaction.sv"
	`include "Agents/Reg_File_Agent/input_reg.sv"
	`include "Agents/Reg_File_Agent/reg_sb.sv"
	//`include "Agents/Reg_File_Agent/passive_agent.sv"
	
	
    // Register Reference Model
    //`include "reg_ref_model.sv"

    // Configuration Agent files
    `include "Agents/Config_Agent/config_seq_item.sv"
    `include "Agents/Config_Agent/configration_config.sv"
    `include "Agents/Config_Agent/config_monitor.sv"
    `include "Agents/Config_Agent/config_driver.sv"
    `include "Agents/Config_Agent/config_sequencer.sv"
    `include "Agents/Config_Agent/config_agent.sv"

    // Interrupt Agent files
    `include "Agents/Interr_Agent/interr_config.sv"
    `include "Agents/Interr_Agent/interr_mon.sv"
    `include "Agents/Interr_Agent/interr_driver.sv"
    `include "Agents/Interr_Agent/interr_sequencer.sv"
    `include "Agents/Interr_Agent/interr_agent.sv"

    // ALU Agent files
    `include "Agents/Alu_Agent/ALU_Transaction.sv"
    `include "Agents/Alu_Agent/Alu_Scoreboard.sv"
    `include "Agents/Alu_Agent/Alu_Monitor.sv"
    `include "Agents/Alu_Agent/Alu_output_monitor.sv"
	

    // Multiplier Agent files
    `include "Agents/Mul_Agent/mul_transaction.sv"
	`include "Agents/Reg_File_Agent/Rf_Model.sv"
    `include "Agents/Mul_Agent/mul_sb.sv"
    `include "Agents/Mul_Agent/output_mul.sv"
    `include "Agents/Mul_Agent/input_mul.sv"
    `include "Agents/Mul_Agent/passive_agent.sv"
	
    // Debug Agent files
    `include "Agents/Debug_Agent/debug_config.sv"
    `include "Agents/Debug_Agent/debug_mon.sv"
    `include "Agents/Debug_Agent/debug_driver.sv"
    `include "Agents/Debug_Agent/debug_sequencer.sv"
    `include "Agents/Debug_Agent/debug_agent.sv"

    // Data Agent files
    `include "Agents/Data_Agent/data_seq_item.sv"
    `include "Agents/Data_Agent/data_agent_config.sv"
    `include "Agents/Data_Agent/data_driver.sv"
    `include "Agents/Data_Agent/data_monitor.sv"
    `include "Agents/Data_Agent/data_sequencer.sv"
    `include "Sequences/data_sequence.sv"
    `include "Agents/Data_Agent/data_agent.sv"
    // `include "scoreboard.sv" 

    // Sequences for various instruction types
    `include "Sequences/rst_sequence.sv"
    `include "Sequences/R_Type_seq.sv"
    `include "Sequences/I_Type_seq.sv"
    `include "Sequences/J_Type_seq.sv"
    `include "Sequences/B_Type_seq.sv"
    `include "Sequences/S_Type_seq.sv"
    `include "Sequences/U_Type_seq.sv"
    `include "Sequences/M_Ext_seq.sv"
    `include "Sequences/L_Type_seq.sv"
    `include "Sequences/rand_seq.sv"
    `include "Sequences/configure_sequence.sv"
	`include "Sequences/Zero_Ones_L_Seq.sv"
	`include "Sequences/Zero_Ones_I_Seq.sv"
	`include "Sequences/Zero_Ones_JALR_Seq.sv"
	`include "Sequences/Zero_Ones_Min_Max_LUI_Seq.sv"
	`include "Sequences/Zero_ones_Min_Max_J_Seq.sv"
	`include "Sequences/Zero_Ones_Min_Max_AUIPC.sv"
	`include "Sequences/SUB_SRA_Sequence.sv"
	`include "Sequences/SLLI_SRAI_SRLI_Sequence.sv"
    	`include "v_sqr.sv"
	`include "Sequences/V_Zero_Ones_Min_Max_LUI_Seq.sv"
	`include "Sequences/V_Zero_Ones_Min_Max_J_Seq.sv"
	`include "Sequences/V_Zero_Ones_Min_Max_AUIPC_Seq.sv"
	
	
    `include "Sequences/v_config_seq.sv"
    `include "Sequences/v_reset_seq.sv"
     `include "CV32E40P_Coverage_collector.sv" 
	 `include "CV32E40P_Predictor.sv" 

    // Environment and base test
    `include "env.sv"
    `include "Tests/base_test.sv"

    // Tests for R-type instructions
    `include "Tests/R_test/v_R_seq.sv"
    `include "Tests/R_test/R_instruction_test.sv"

    // Tests for B-type instructions
    `include "Tests/B_test/v_B_seq.sv"
    `include "Tests/B_test/B_instruction_test.sv"

    // Tests for J-type instructions
    `include "Tests/J_test/v_J_seq.sv"
    `include "Tests/J_test/J_instruction_test.sv"

    // Tests for MUL instructions
    `include "Tests/MUL_test/v_MUL_seq.sv"
    `include "Tests/MUL_test/MUL_instruction_test.sv"

    // Tests for S-type instructions
    `include "Tests/S_test/v_S_seq.sv"
    `include "Tests/S_test/S_instruction_test.sv"

    // Tests for L-type instructions
    `include "Tests/L_test/v_L_seq.sv"
    `include "Tests/L_test/L_instruction_test.sv"

    // Tests for random sequences
    `include "Tests/rand_test/v_rand_seq.sv"
    `include "Tests/rand_test/rand_instruction_test.sv"

    // Tests for U-type instructions
    `include "Tests/U_test/v_U_seq.sv"
    `include "Tests/U_test/U_instruction_test.sv"
	
	
	`include "Tests/zero_ones_min_max_auipc_test.sv"
	`include "Tests/zero_ones_min_max_j_test.sv"
	`include "Tests/zero_ones_min_max_lui_test.sv"
	
	
	
	`include "Tests/Zero_Ones_I_Test/V_Zero_Ones_I_Seq.sv"
	`include "Tests/Zero_Ones_I_Test/Zero_Ones_I_Test.sv"
	
    `include "Tests/Zero_Ones_L_Test/V_Zero_Ones_L_Seq.sv"	
    `include "Tests/Zero_Ones_L_Test/Zero_Ones_L_Test.sv"
	
	`include "Tests/Zero_Ones_JALR_Test/V_Zero_Ones_JALR_Seq.sv"	
    `include "Tests/Zero_Ones_JALR_Test/Zero_Ones_JALR_Test.sv"
	
	`include "Tests/SUB_SRA_Test/V_SUB_SRA_Sequence.sv"
	`include "Tests/SUB_SRA_Test/SUB_SRA_Test.sv"
	
	`include "Tests/SLLI_SRAI_SRLI_Test/V_SLLI_SRAI_SRLI_Seq.sv"
	`include "Tests/SLLI_SRAI_SRLI_Test/SLLI_SRAI_SRLI_Test.sv"
	
	

endpackage : pack
