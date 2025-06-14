/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                               //  
// Project Name : RISC-V_CV32E40P_UVM_Verification                                                               //
// Module Name  : Load_Store_Unit & Data_Memory         \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\//   //
//                                                      //     __      _      _       _____      _  _    _ //    //
//                                                      //	  /  \	  | |	 | |	 |___  |    | | \\  // //    //
//                                                      //	 / /\ \	  | |    | |___   ___| |  __| |  \\//  //    //
//                                                      //	/ /__\ \  | |__  |  _  | | _   | | _  |  / /   //    //
//  Auther :                                            // /_/----\_\ |____| |_| |_| |___ _| |____| /_/    //    //
//      Mohamed shaaban Ahmed                           //                                                 //    //
//    (Digital Design and Design Verification Engineer) \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\    //
//                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class CV32E40P_data_mem_seq extends uvm_sequence#(data_seq_item);

  `uvm_object_utils(CV32E40P_data_mem_seq)

  data_seq_item req_item, resp_item;
  CV32E40P_Data_Sequencer data_Sequencer;

  task pre_body;
    $cast(data_Sequencer, get_sequencer());
    req_item = data_seq_item::type_id::create("req_item");
    resp_item = data_seq_item::type_id::create("resp_item");
  endtask : pre_body

  extern function new(string name = "CV32E40P_data_mem_seq");
  extern task body();

endclass

function CV32E40P_data_mem_seq::new(string name = "CV32E40P_data_mem_seq");
  super.new(name);
endfunction

task CV32E40P_data_mem_seq::body();
  bit [31:0] r_data;

  forever begin
    data_Sequencer.seq_data_fifo.get(req_item);

    if (req_item.data_req_o && req_item.data_gnt_i) begin
      if (req_item.data_we_o) begin // write
        data_Sequencer.mem.write(req_item.data_addr_o, req_item.data_wdata_o, req_item.data_be_o);

        start_item(resp_item);
        assert(resp_item.randomize() with {
          data_rvalid_i == 1;
          data_we_o    == 1;
        });
        finish_item(resp_item);
      end
      else begin // read
        r_data = data_Sequencer.mem.read(req_item.data_addr_o);

        start_item(resp_item);
        assert(resp_item.randomize() with {
          data_rvalid_i == 1;
          data_we_o    == 0;
          data_rdata_i == r_data;
        });
        finish_item(resp_item);
      end
    end
    else begin
      start_item(resp_item);
      assert(resp_item.randomize() with {
        data_rvalid_i == 0;
      });
      finish_item(resp_item);
    end
  end
endtask
