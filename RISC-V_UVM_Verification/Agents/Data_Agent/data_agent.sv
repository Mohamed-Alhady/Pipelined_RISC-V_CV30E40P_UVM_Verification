////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                        //
//  Project Name : RISC-V_CV32E40P_UVM_Verification                                                                       // 
//  Module Name  : Load_Store_Unit & Data_Memory             \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//      //
//                                                           //     	                                         //       //
// 															 //     __       _      _       _____      _  _    _ //       //                                                            
// 															 //    /  \     | |    | |     |___  |    | | \\  // //       //                                                            
// 															 //   / /\ \    | |    | |___   ___| |  __| |  \\//  //       //                                                            
// 															 //  / /__\ \   | |__  |  _  | | _   | | _  |  / /   //       //                                                            
// 															 // /_/----\_\  |____| |_| |_| |___ _| |____| /_/    //       //                                                                                                                   //                                                  //       //
//  Author :                                                 //                                                  //       //
//      Mohamed Shaaban Ahmed                                \\///////////////////////////////////////////////////\\      //                                                    
//      (Digital Design and Design Verification Engineer)                                                                 //
//      mohamed.shaaban240836@gmail.com                                                                                   //
//                                                                                                                        //
//  * This class represents the UVM agent for the CV32E40P data interface.                                                // 
//  * wrapping and coordinates the driver, sequencer, and input/output monitors to                                        //
//    manage data memory transactions in the UVM testbench.                                                               // 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class CV32E40P_Data_Agent extends uvm_agent;

  `uvm_component_utils(CV32E40P_Data_Agent)

  //---- components -----
  CV32E40P_Data_Driver        d_driver;
  CV32E40P_Monitor_InOut      d_monitor;
  CV32E40P_Data_Sequencer     d_sequencer;
  Storage_Model               memory;

  //--- configuration handle -----
  data_Config  d_agent_config;



  // analysis ports to broadcast input and output transactions to analysis components 
  uvm_analysis_port#(data_seq_item) ag_in_analysis_port;
  // uvm_analysis_port#(data_seq_item) ag_out_analysis_port;

  //<<----- constructor ------->>//
  extern function new(string name = "CV32E40P_Data_Agent", uvm_component parent);

  //<<----- build phase -------->>//
  extern function void build_phase(uvm_phase phase);

  //<<----- connect phase ------>>//
  extern function void connect_phase(uvm_phase phase); 

  //<<----- Run phase -------->>//
  extern task run_phase(uvm_phase phase); 

  extern function void extract_phase(uvm_phase phase);

endclass


//<< ================================================================================================
//============================== Function Definitions ==============================================>>

function CV32E40P_Data_Agent::new(string name = "CV32E40P_Data_Agent", uvm_component parent);
  super.new(name, parent);
  ag_in_analysis_port = new("ag_in_analysis_port", this);
  // ag_out_analysis_port = new("ag_out_analysis_port", this);
  $display("new function agent");
endfunction


function void CV32E40P_Data_Agent::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("CV32E40P_Data_Agent", $sformatf("Build Phase"), UVM_LOW);

  if(!uvm_config_db#(data_Config)::get(this, "", "data_agt", d_agent_config))
    `uvm_fatal(get_full_name(), "data agent");

  // Create component only if the agent is active
  if (d_agent_config.agent_active == UVM_ACTIVE) begin
    d_sequencer = CV32E40P_Data_Sequencer::type_id::create("d_sequencer", this);
    d_driver    = CV32E40P_Data_Driver::type_id::create("d_driver", this);
  end
  uvm_config_db#(Storage_Model)::set(this, "*", "memory", memory);
  d_monitor = CV32E40P_Monitor_InOut::type_id::create("d_monitor", this);
endfunction


function void CV32E40P_Data_Agent::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info("CV32E40P_Data_Agent", $sformatf("Connect Phase"), UVM_LOW);

  // connect sequencer to driver
  if (d_agent_config.agent_active) begin
    d_driver.seq_item_port.connect(d_sequencer.seq_item_export);
    d_monitor.resp_analysis_port.connect(d_sequencer.seq_coll_export);
	//d_monitor.req_analysis_port.connect(.seq_coll_export);
  end

  d_monitor.resp_analysis_port.connect(ag_in_analysis_port);
endfunction


task CV32E40P_Data_Agent::run_phase(uvm_phase phase);
  super.run_phase(phase);
  `uvm_info("CV32E40P_Data_Agent", $sformatf("Run Phase"), UVM_LOW);
endtask


function void CV32E40P_Data_Agent::extract_phase(uvm_phase phase);
  super.extract_phase(phase);
  `uvm_info("CV32E40P_Data_Agent", $sformatf("Extraction Phase"), UVM_LOW);
endfunction
