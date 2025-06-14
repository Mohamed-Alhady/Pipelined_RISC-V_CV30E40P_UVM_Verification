class config_seq_item extends  uvm_sequence_item;
	   `uvm_object_utils(config_seq_item)
    
    function new(string name = "config_seq_item");
    super.new(name);
    endfunction

  rand logic rst;
  rand logic pulp_clock_en;
  rand logic scan_cg_en;
  rand logic [31:0] boot_addr;
  rand logic [31:0] mtvec_addr;
  rand logic [31:0] dm_halt_addr;
  rand logic [31:0] dm_exception_addr;
  rand logic [31:0] hart_id;
  rand logic fetch_enable;
endclass : config_seq_item
