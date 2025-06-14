class rand_seq extends uvm_sequence#(seq_item);

  `uvm_object_utils(rand_seq)
  parameter DATA_DEPTH = 4 * 10000;

  // Constructor
  function new(string name = "rand_seq");
    super.new(name);
  endfunction

  // Data members
  seq_item sequ_item, response, transmitted;
  instr_sequencer instr_seqer;
  bit [31:0] mem[DATA_DEPTH-1:0];

  // Function to read data from memory
  function bit [31:0] read(int addr);
    return(mem[addr]);
  endfunction

  // -------------------------- pre_body task -----------------------------
  task pre_body;
    sequ_item = seq_item::type_id::create("sequ_item");

    // Initialize memory with random data
    for (int i = 0; i < DATA_DEPTH; i++) begin
      assert(sequ_item.randomize() with{instr_rdata_i[24:20] != instr_rdata_i[19:15]; } );
      // sequ_item.make_instr(); // Uncomment if additional setup for instruction needed
      mem[i] = sequ_item.instr_rdata_i;
    end

    // Initialize transmitted and response items
    transmitted = seq_item::type_id::create("transmitted");
    response = seq_item::type_id::create("response");

    // Get sequencer
    $cast(instr_seqer, get_sequencer());
  endtask : pre_body
  // ----------------------------------------------------------------------

  // -------------------------- body task -----------------------------
   task body;
    repeat(700) begin
      instr_seqer.analysis_fifo.get(response);

      if (response.instr_req_o) begin  // Check if req_o is high; if so, send instruction and set valid high.
        if (response.instr_addr_o < DATA_DEPTH) begin
          start_item(transmitted);
         
          transmitted.instr_rdata_i = read({2'b00, response.instr_addr_o[31:2]});
          transmitted.instr_rvalid_i = 1'b1;
          finish_item(transmitted);
        end
        else begin
          start_item(transmitted);
         
          assert(transmitted.randomize());
          // transmitted.instr_rdata_i = read({2'b00,response.instr_addr_o[31:2]});
          transmitted.instr_rvalid_i = 1'b1;
          finish_item(transmitted);
        end
      end
      else begin
        start_item(transmitted);
        transmitted.instr_rvalid_i = 1'b0;
        finish_item(transmitted);
      end
    end
  endtask : body
  // ----------------------------------------------------------------------

    
endclass
