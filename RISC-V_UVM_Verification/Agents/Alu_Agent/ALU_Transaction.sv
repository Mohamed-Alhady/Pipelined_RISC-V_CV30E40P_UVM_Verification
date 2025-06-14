  import cv32e40p_pkg::*;
  // ALU Transaction Item
  class alu_transaction extends uvm_sequence_item;
   `uvm_object_utils(alu_transaction)

   logic [6:0] operator;
  
    logic [31:0] operand_a;
    logic [31:0] operand_b;
    logic [31:0] operand_c;
    logic [31:0] result   ;
  
    logic     alu_en    ;
    
    
   
    //   `uvm_field_enum(alu_opcode_e,operator)
    // `uvm_field_int(operand_a, UVM_ALL_ON)
    //   `uvm_field_int(operand_b, UVM_ALL_ON)
    //   `uvm_field_int(operand_c, UVM_ALL_ON)
    // `uvm_field_int(alu_en, UVM_ALL_ON)
    //   `uvm_field_int(result, UVM_ALL_ON)
 
    // `uvm_object_utils_end
    
    function new(string name = "alu_transaction");
      super.new(name);
    endfunction
    
   
  endclass
  
 
  
  
  
  
  