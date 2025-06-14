
class reg_transaction extends uvm_sequence_item;

 `uvm_object_utils(reg_transaction)
  function new(string name = "reg_transaction");
    super.new(name);
  endfunction



     logic          clk;
     logic          rst_n;
     logic          scan_cg_en_i;
     logic [5:0]    raddr_a_i;
     logic [32-1:0] rdata_a_o;
     logic [5:0]    raddr_b_i;
     logic [32-1:0] rdata_b_o;
     logic [5:0]    raddr_c_i;
     logic [32-1:0] rdata_c_o;
     logic [5:0]    waddr_a_i;
     logic [32-1:0] wdata_a_i;
     logic          we_a_i;
     logic [5:0]    waddr_b_i;
     logic [32-1:0] wdata_b_i;
     logic          we_b_i;

endclass