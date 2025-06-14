///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                      //
//  //Project Name : RISC-V_CV32E40P_UVM_Verification                                                                   //
//  Module Name  : Load_Store_Unit & Data_Memory          \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\	        //
//                               					      //     __      _      _       _____      _  _    _ //         //
//                               					      //    /  \	| |	   | |	   |___  |    | | \\  // //         //
//                               					      //   / /\ \	| |    | |___   ___| |  __| |  \\//  //         //
//                               					      //  / /__\ \  | |__  |  _  | | _   | | _  |  / /   //         //
//  Author :                                              // /_/----\_\ |____| |_| |_| |___ _| |____| /_/    //         //
//      Mohamed Shaaban Ahmed                             //						         				 //	        //
//      (Digital Design and Design Verification Engineer) //\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\         //
//      mohamed.shaaban240836@gmail.com                                                                                 //
//                                                                                                                      //
//  * This class represents the UVM driver for the CV32E40P data interface.                                             //
//  * It receives response transactions (resp_item) and drives them to the DUT via a virtual interface.                 //
//                                                                                                                      //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\\

class CV32E40P_Data_Driver extends uvm_driver #(data_seq_item);
  // Register the component with the UVM factory.
  `uvm_component_utils(CV32E40P_Data_Driver)

  virtual data_intf my_vif; 
  
  data_seq_item resp_item; // Response Item received from the sequencer.

  //<<--- Storage Model handle ---
//  Storage_Model R_mem;

  //<<--- constructor declaration ---  
  extern function new(string name = "CV32E40P_Data_Driver", uvm_component parent = null);

  //<<--- Standard UVM Phases ----  
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task main_phase(uvm_phase phase);
  extern function void extract_phase(uvm_phase phase);

  task reset_phase(uvm_phase phase);
    data_seq_item sequ_item;
    begin
	my_vif.data_gnt_i <= 1'b1;
	#3;
	my_vif.data_gnt_i <= 1'b0;
	#3;
      my_vif.data_gnt_i <= 1'b1;
      my_vif.data_rvalid_i <= 0;
      my_vif.data_rdata_i <= 1'b0;
    end
  endtask : reset_phase
  
endclass 

//<<=====================================================================================================
//========================================== Function Definitions =====================================>>

//<<--- Constructor Function Implementation ---  
function CV32E40P_Data_Driver::new(string name = "CV32E40P_Data_Driver", uvm_component parent = null);
  super.new(name, parent);
endfunction

//<<--- Build phase ---  
function void CV32E40P_Data_Driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("CV32E40P_Data_Driver", $sformatf("Build Phase"), UVM_LOW);

  // Retrives the virtual interface from the config DB
  if (!uvm_config_db#(virtual data_intf)::get(this, "", "data_vif", my_vif))
    `uvm_fatal(get_full_name(), "couldn't get interface from agent");
endfunction

//<<--- Connect Phase ---  
function void CV32E40P_Data_Driver::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info("CV32E40P_Data_Driver", $sformatf("Connect Phase"), UVM_LOW);
endfunction

//<<--- Main Phase ----  
task CV32E40P_Data_Driver::main_phase(uvm_phase phase);
  super.run_phase(phase);
  `uvm_info("CV32E40P_Data_Driver", $sformatf("Run Phase"), UVM_LOW);

  forever begin
    seq_item_port.get_next_item(resp_item);

    @(posedge my_vif.clk);

    if (resp_item.data_rvalid_i && !resp_item.data_we_o) begin
      my_vif.data_rvalid_i <= resp_item.data_rvalid_i;
      my_vif.data_rdata_i <= resp_item.data_rdata_i;
    end
    else if (resp_item.data_rvalid_i && resp_item.data_we_o) begin
      my_vif.data_rvalid_i <= resp_item.data_rvalid_i;
    end
    
    if (!resp_item.data_rvalid_i) begin
      my_vif.data_rvalid_i <= 0;
    end

    #1
    seq_item_port.item_done();
  end
endtask

//<<--- Extract Phase ---  
function void CV32E40P_Data_Driver::extract_phase(uvm_phase phase);
  super.extract_phase(phase);
  `uvm_info("My_Sequencer", $sformatf("Extract Phase"), UVM_LOW);
endfunction
