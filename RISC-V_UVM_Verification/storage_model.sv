///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//															  //														  //
// Project Name : RISC-V_CV32E40P_UVM_Verification                                                                        //
// Module Name  : Load_Store_Unit & Data_Memory         \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\	          //
//														//     __      _      _       _____      _  _    _ //             //
//														//    /  \    | |    | |     |___  |    | | \\  // //             //
//														//   / /\ \   | |    | |___   ___| |  __| |  \\//  //             //
//														//  / /__\ \  | |__  |  _  | | _   | | _  |  / /   //             //
//  Author :   										    // /_/----\_\ |____| |_| |_| |___ _| |____| /_/    //             //
//	Mohamed shaaban Ahmed                               //						                           //	          //
//      (Digital Design and Design Verification Engineer) \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\           //
//  			mohamed.shaaban240836@gmail.com                                                                           //
//                                                                                                                        //
//    * This class represents storage model of CV32E40P data agent.                                                       //
//    * Memory model using associative arrays to store and retrieve 32-bit data                                           //
//      based on 32-bit address, mimicking Data Memory behavior.                                                          //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

typedef bit [31:0] addr_t;
typedef bit [31:0] data_t;
typedef bit [3:0] data_enable;

class Storage_Model extends uvm_component;

  `uvm_component_utils(Storage_Model)

  // Declare an associative array to act as the memory (address -> data)
  logic [7:0] mem [2**16-1:0];
  
  // Constructor declaration
  extern function new(string name = "Storage_Model", uvm_component parent = null);

  // Function to write data to a specific address in memory
  extern function void write(addr_t addr, data_t data, data_enable enable);

  // Function to read data from a specific address in memory
  extern function data_t read(addr_t addr);

  // Reset phase task
  extern task reset_phase(uvm_phase phase);

endclass

//===========================================================================================
//========================= Function Definitions ============================================

function Storage_Model::new(string name = "Storage_Model", uvm_component parent = null);
  super.new(name, parent);
endfunction

// Write function definition
function void Storage_Model::write(addr_t addr, data_t data, data_enable enable);
  logic [31:0] add0, add1, add2, add3;
  
  add0 = (addr & 32'h0000fffc) + 32'h00000000;
  add1 = (addr & 32'h0000fffc) + 32'h00000001;
  add2 = (addr & 32'h0000fffc) + 32'h00000002;
  add3 = (addr & 32'h0000fffc) + 32'h00000003;

  if (enable[0] == 1)
    mem[add0] = data[7:0];

  if (enable[1] == 1)
    mem[add1] = data[15:8];

  if (enable[2] == 1)
    mem[add2] = data[23:16];

  if (enable[3] == 1)
    mem[add3] = data[31:24];

  //`uvm_info("MEM_MODEL", $sformatf("WRITE @ 0x%08x = 0x%08x", addr, data), UVM_LOW);
endfunction

// Read function definition
function data_t Storage_Model::read(addr_t addr);
  data_t data;
  logic [31:0] add0, add1, add2, add3;

  add0 = (addr & 32'h0000fffc) + 32'h00000000;
  add1 = (addr & 32'h0000fffc) + 32'h00000001;
  add2 = (addr & 32'h0000fffc) + 32'h00000002;
  add3 = (addr & 32'h0000fffc) + 32'h00000003;

  data = {mem[add3], mem[add2], mem[add1], mem[add0]};

  //`uvm_info("MEM_MODEL", $sformatf("READ @ 0x%08x = 0x%08x", addr, data), UVM_LOW);

  return data;
endfunction

// Reset phase task
task Storage_Model::reset_phase(uvm_phase phase);
//rand logic [31:0] rand_data;
  super.reset_phase(phase);
  for (integer j = 0; j < 2**16; j = j + 1)
    mem[j] = $random;
  // Start to randomize the data memory, and you can constrain it with a certain value
endtask
