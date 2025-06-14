class data_seq_item extends uvm_sequence_item;

  `uvm_object_utils(data_seq_item)

  function new(string name = "data_seq_item");
    super.new(name);
  endfunction

  // Signals output from LSU to Ram 
  rand logic         rst_n;

  rand logic         data_req_o;
  rand logic         data_we_o;
  rand logic [3:0]   data_be_o;
  rand logic [31:0]  data_addr_o;
  rand logic [31:0]  data_wdata_o;

  // Signals output from RAM to LSU Unit 
  rand logic         data_gnt_i;
  rand logic         data_rvalid_i;
  rand logic [31:0]  data_rdata_i;

endclass : data_seq_item
