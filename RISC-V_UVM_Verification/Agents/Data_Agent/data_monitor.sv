//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//															    												     //	
// Project Name : RISC-V_CV32E40P_UVM_Verification                                                                   // 
// Module Name  : Load_Store_Unit & Data_Memory         \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\	     //
//							    						//     __      _      _       _____      _  _    _ //        //
//							    						//	  /  \	  | |	 | |	 |___  |    | | \\  // //        //
//							    						//	 / /\ \	  | |    | |___   ___| |  __| |  \\//  //        //
//							    						//	/ /__\ \  | |__  |  _  | | _   | | _  |  / /   //        //
//	Auther :                                            // /_/----\_\ |____| |_| |_| |___ _| |____| /_/    //        //
//	    Mohamed shaaban Ahmed                           //						       					   //	     //			  	
//	  (Digital Design and Design Verification Engineer) \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\        //
//  			mohamed.shaaban240836@gmail.com                                                                      //    
//                                                                                                                   //
//                                                                                                                   // 
//    * this class represents monitor input of CV32E40P data interface.                                              //
//    * to monitor and capture response of read or write transactions                                                //
//      and sends to analysis components as scoreboardand ..etc        							 					 // 
//                                                                                                                   // 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\\

class CV32E40P_Monitor_InOut extends uvm_monitor ;
	// register the component in UVM factory
`uvm_component_utils (CV32E40P_Monitor_InOut)
  
  // analysis port to broadcast observed input transactions
   uvm_analysis_port#(data_seq_item) req_analysis_port	;
   uvm_analysis_port#(data_seq_item) resp_analysis_port	;
  
   virtual data_intf my_vif;
  
  data_seq_item req_item, resp_item ;
  
	//<<--- Constructor ----
  extern function new(string name = "CV32E40P_Monitor_InOut", uvm_component parent = null);
  
	//<<--- build phase ---
  extern function void build_phase(uvm_phase phase) ;
  
	//<<--- connect phase ---
  extern function void connect_phase(uvm_phase phase)	;
  
	//<<--- run phase ----
  extern task run_phase(uvm_phase phase);

endclass

//<<=============================================================================================================
//========================================= Function Definitions ==============================================>>

		// Constructor implementation
function CV32E40P_Monitor_InOut::new(string name = "CV32E40P_Monitor_InOut", uvm_component parent = null);
  super.new(name, parent);
  
   req_analysis_port = new("req_analysis_port", this);   // request analysis port creation
   resp_analysis_port = new("resp_analysis_port", this); // response analysis port creation
   
endfunction

//-----------------------------------------------------------------------------------------
function void CV32E40P_Monitor_InOut::build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("CV32E40P_Monitor_InOut",$sformatf("Build Phase"), UVM_FULL);
  
  if(!uvm_config_db#(virtual data_intf )::get(this, "", "data_vif", my_vif ))
    `uvm_fatal(get_full_name(), "Error")
   
    
	req_item = data_seq_item::type_id::create("req_item");
  
endfunction

//------------------------------------------------------------------------------------------
function void CV32E40P_Monitor_InOut::connect_phase(uvm_phase phase);
super.connect_phase(phase);
  `uvm_info("CV32E40P_Monitor_InOut",$sformatf("Connect Phase"), UVM_FULL);
endfunction

//------------------------------------------------------------------------------------------
task CV32E40P_Monitor_InOut::run_phase(uvm_phase phase);
  super.run_phase(phase);
  `uvm_info("CV32E40P_Monitor_InOut",$sformatf("Run Phase"), UVM_FULL);
  
  forever begin
	
		 @(posedge my_vif.clk)
	 
		 #1
		   if(my_vif.rst_n)
	begin
		 // capture the observed request signals 
		    req_item.data_gnt_i 		= 	my_vif.data_gnt_i;
		    req_item.data_rvalid_i 		= 	my_vif.data_rvalid_i;
			  req_item.data_rdata_i	   	=	my_vif.data_rdata_i;
		    req_item.data_req_o			=	my_vif.data_req_o;
		    req_item.data_we_o 			= 	my_vif.data_we_o;	
		    req_item.data_be_o   		=	my_vif.data_be_o;
	    	req_item.data_addr_o     	=	my_vif.data_addr_o;
	    	req_item.data_wdata_o    	=	my_vif.data_wdata_o;	
	    
		resp_analysis_port.write(req_item);
		req_analysis_port.write(req_item);
	end
		 
		
		/*
   @(posedge my_vif.clk)
   #1
    if (my_vif.data_rvalid_i && my_vif.data_gnt_i ); // wait for valid 
   begin
   	// capture the observed read response signals
			
			req_item.data_rvalid_i 		= 	my_vif.data_rvalid_i;
			req_item.data_rdata_i	   	=	my_vif.data_rdata_i   ;
		
	
			//write to anaysis port for scoreboard or coverage collector
    	
    	req_analysis_port.write(req_item);
   end
*/
 
    
  end
  
endtask
/*
//----------------------------------------------------------------------------------------------
function void CV32E40P_Monitor_InOut::extract_phase (uvm_phase phase);
  super.extract_phase(phase);
 `uvm_info("My_Monitor_Input",$sformatf("Extract Phase"), UVM_FULL);
endfunction
*/