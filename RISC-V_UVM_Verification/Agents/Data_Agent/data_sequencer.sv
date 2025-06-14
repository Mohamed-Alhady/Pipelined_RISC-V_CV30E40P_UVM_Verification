///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//															//															  //								
// Project Name : RISC-V_CV32E40P_UVM_Verification                                                                     	// 
// Module Name  : Load_Store_Unit & Data_Memory             \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\       //
//							    //     __      _      _       _____      _  _    _ //       //
//							    //	  /  \	  | |	 | |	 |___  |    | | \\  // //       //
//							    //	 / /\ \	  | |    | |___   ___| |  __| |  \\//  //       //
//							    //	/ /__\ \  | |__  |  _  | | _   | | _  |  / /   //       //
//	Auther :                                            // /_/----\_\ |____| |_| |_| |___ _| |____| /_/    //       //
//	    Mohamed shaaban Ahmed                           //						       //       //					  
//	  (Digital Design and Design Verification Engineer) \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\       //
//  			mohamed.shaaban240836@gmail.com                                                                 //                                                    
//                                                                                                                       // 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\\

class CV32E40P_Data_Sequencer extends uvm_sequencer #(data_seq_item);
  
  // Register the component to UVM factory
  `uvm_component_utils(CV32E40P_Data_Sequencer)
  
  
	data_seq_item req_item ; 
	Storage_Model mem          ;  // Instance from storage model
  
   uvm_analysis_export 		#(data_seq_item) 	seq_coll_export ;
   uvm_tlm_analysis_fifo	#(data_seq_item)  	seq_data_fifo	;
	
  
		//<<--- constructor ----
  extern function new(string name = "CV32E40P_Data_Sequencer", uvm_component parent)	;
  
		//<<--- build Phase -----
  extern function void build_phase(uvm_phase phase)  					;
	
		//<<--- connect phase ----
  extern function void connect_phase(uvm_phase phase)					;
  
		//<<--- Run phase     ----
  extern task run_phase(uvm_phase phase)						;
  extern function void extract_phase (uvm_phase phase);
  
endclass

//<<=============================================================================================
//============================= Function Definitions ==========================================>>

function CV32E40P_Data_Sequencer::new(string name = "CV32E40P_Data_Sequencer", uvm_component parent);
  super.new(name,parent);
  seq_coll_export = new("seq_coll_export", this);
  seq_data_fifo   = new("seq_data_fifo", this );
endfunction

//----------------------------------------------------------------------------------
function void CV32E40P_Data_Sequencer::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("CV32E40P_Data_Sequencer",$sformatf("Build Phase"), UVM_LOW);
  mem = Storage_Model::type_id::create("mem",this);
  req_item = data_seq_item::type_id::create("req_item");
endfunction 

//-----------------------------------------------------------------------------------
function void CV32E40P_Data_Sequencer::connect_phase(uvm_phase phase);
super.connect_phase(phase);
  `uvm_info("CV32E40P_Data_Sequencer",$sformatf("Connect Phase"), UVM_LOW);
  
	// connect tlm export to fifo 
  seq_coll_export.connect(seq_data_fifo.analysis_export);
endfunction

//--------------------------------------------------------------------------------------
task CV32E40P_Data_Sequencer::run_phase(uvm_phase phase);
  super.run_phase(phase);
  `uvm_info("CV32E40P_Data_Sequencer",$sformatf("Run Phase"), UVM_LOW);
endtask

//--------------------------------------------------------------------------------------
function void CV32E40P_Data_Sequencer::extract_phase (uvm_phase phase);
  super.extract_phase(phase);
  `uvm_info("CV32E40P_Data_Sequencer",$sformatf("Extract Phase"), UVM_LOW);
endfunction
