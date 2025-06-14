///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//																														                                                            //
// Project Name : RISC-V_CV32E40P_UVM_Verification                                                                        //
// Module Name  : Load_Store_Unit & Data_Memory         \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\			        //
//														                          //     __      _      _       _____      _  _    _ //             //
//														                          //	  /  \	  | |	   | |	   |___  |    | | \\  // //             //
//														                          //	 / /\ \	  | |    | |___   ___| |  __| |  \\//  //             //
//														                          //	/ /__\ \  | |__  |  _  | | _   | | _  |  / /   //             //
//	Auther :                                            // /_/----\_\ |____| |_| |_| |___ _| |____| /_/    //             //
//	    Mohamed shaaban Ahmed                           //												                         //			        //
//	  (Digital Design and Design Verification Engineer) \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\             //
//  			mohamed.shaaban240836@gmail.com                                                                                 //
//                                                                                                                        //                                                                                                            //
//    * this class represents Configuratio of CV32E40P data agent.                                                        //
//    * holds virtual interface handle and active or passive status controls the composition and behaviour                //
//     of data agent by specifying which components should be inistantiated       										                    //
//                                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


class data_Config extends uvm_object;

`uvm_object_utils(data_Config)



function new(string name="data_Config");
  super.new("name");

endfunction
//----------------------- virtual Interface --------------
    virtual instruction_intf vif;
  //--------------------------------------------------------

  //----------------------- set type of agent --------------
    uvm_active_passive_enum agent_active;
  //--------------------------------------------------------


endclass


