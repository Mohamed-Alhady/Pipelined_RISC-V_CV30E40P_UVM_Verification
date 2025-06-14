////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//															      //												      //
// Project Name : RISC-V_CV32E40P_UVM_Verification                                                                        //
// Module Name  : Load_Store_Unit & Data_Memory         \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\	      	  //
//							   							//     __      _      _       _____      _  _    _ //             //
//							   							//	  /  \	  | |	 | |	 |___  |    | | \\  // //             //
//							   							//	 / /\ \	  | |    | |___   ___| |  __| |  \\//  //             //
//							   							//	/ /__\ \  | |__  |  _  | | _   | | _  |  / /   //             //
//	Auther :                                            // /_/----\_\ |____| |_| |_| |___ _| |____| /_/    //             //
//   Mohamed shaaban Ahmed                              //						         				   //	          //
// (Digital Design and Design Verification Engineer)     //\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\            //
//  			mohamed.shaaban240836@gmail.com                                                                       	  //
//                                                                                                                        //                                                                                                                    //
//    * CV32E40P_Data_Mem_intf interface facilitates synchronized and efficient comm between 				      		  //
//      UVM component(driver and monitors) and DUT(LSU and Data Memory)using clocking block.                        	  //
//                                                                                                                        //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

interface data_intf(input bit clk, rst_n );

		 
//Signals output from LSU to Ram 
logic 			data_req_o			;
logic 			data_we_o           ;
logic [3:0 ]	data_be_o           ;
logic [31:0]	data_addr_o         ;
logic [31:0]    data_wdata_o		;
	
// signals output from RAM to LSU Unit 	
logic 			data_gnt_i			;
logic 			data_rvalid_i       ;
logic [31:0]	data_rdata_i        ;



endinterface 
