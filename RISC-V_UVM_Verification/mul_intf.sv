import cv32e40p_pkg::*;
interface mul_intf
(
		input  		clk,
		input         	rst_n,
 
		input         	enable_i,//
		input 			ex_ready_i,
		input mul_opcode_e 	operator_i,
    	input 	[31:0] 	op_a_i,//
		input 	[31:0] 	op_b_i,//
		input 	[31:0] 	op_c_i,
		input 	[4:0]	imm_i,
		input  [1:0]	short_signed_i,//

		// input Signals of MUL
		input 	[31:0]	result_o,
    	input 		    ready_o
);



endinterface

