class SLLI_SRAI_SRAI_Sequence extends uvm_sequence;

   
  `uvm_object_utils(SLLI_SRAI_SRAI_Sequence)
 
  parameter DATA_DEPTH = 4 * 10000;

  // Constructor
  function new(string name = "SLLI_SRAI_SRAI_Sequence");
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
      assert(sequ_item.randomize() with{instr_rdata_i[6:0] == 7'b0010011;  
													instr_rdata_i[14:12] inside {3'b001, 3'b101} ;
													instr_rdata_i[31:25] inside {7'b000_0000, 7'b010_0000} ;
													
													} );
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
    repeat(6000) begin
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
         
          assert(transmitted.randomize() with{instr_rdata_i[6:0] == 7'b0010011;  
													instr_rdata_i[14:12] inside {3'b001, 3'b101} ;
													instr_rdata_i[31:25] inside {7'b000_0000, 7'b010_0000} ;
													
													} );
			  
		  
          transmitted.instr_rvalid_i = 1'b1;
          finish_item(transmitted);
        end
      end else begin
        start_item(transmitted);

        transmitted.instr_rvalid_i = 1'b0;
        finish_item(transmitted);
      end
	  `uvm_info("\n===============\nSLLI_SRAI_SRLI_Sequence",$sformatf("seq is randomized the values opcode : %0b and instr: %0b \n=============\n ",transmitted.instr_rdata_i[6:0],transmitted.instr_rdata_i), UVM_FULL)		
    end
  endtask : body
  // ----------------------------------------------------------------------

    
endclass
