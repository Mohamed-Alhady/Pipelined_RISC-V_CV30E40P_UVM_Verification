
class mult_transaction extends uvm_sequence_item;

 `uvm_object_utils(mult_transaction)
  function new(string name = "mult_transaction");
    super.new(name);
  endfunction



     logic clk; 
     logic rst; 
     mul_opcode_e enable_i;
     logic [2:0] operator_i;
     logic [1:0] short_signed_i;
     logic [31:0] op_a_i;
     logic [31:0] op_b_i;
     logic [31:0] result_o;
     logic ready_o;
     logic ex_ready_i;
     logic [31:0] exp_result;

endclass
