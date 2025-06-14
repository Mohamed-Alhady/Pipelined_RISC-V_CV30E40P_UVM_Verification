import cv32e40p_pkg::*;
interface alu_intf
(
    input                 clk,
    input                 rst_n,
    input                 enable_i,
    input alu_opcode_e        operator_i,
    input          [31:0] operand_a_i,
    input          [31:0] operand_b_i,
    input          [31:0] operand_c_i,

    input   [1:0] vector_mode_i,
    input   [4:0] bmask_a_i,
    input   [4:0] bmask_b_i,
    input   [1:0] imm_vec_ext_i,

    input         is_clpx_i,
    input         is_subrot_i,
    input   [1:0] clpx_shift_i,

    input    [31:0] result_o,
    input           comparison_result_o,

    input    ready_o,
    input    ex_ready_i
);



endinterface


