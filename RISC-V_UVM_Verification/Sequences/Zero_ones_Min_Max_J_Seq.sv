class zero_ones_min_max_j_Sequence extends uvm_sequence;

   
  `uvm_object_utils(zero_ones_min_max_j_Sequence)
 
  parameter DATA_DEPTH = 4 * 10000;

  // Constructor
  function new(string name = "zero_ones_min_max_j_Sequence");
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
      assert(sequ_item.randomize() with{instr_rdata_i[6:0] == 7'b1101111 ;
									
										instr_rdata_i[31:12] inside {20'b0000_0000_0000_0000_0000, 20'b1111_1111_1111_1111_1111,20'b1000_0000_0000_0000_0000, 20'b0111_1111_1111_1111_1111 };
										instr_rdata_i[31:12] dist {20'b0000_0000_0000_0000_0000 :=15 , 20'b1111_1111_1111_1111_1111 := 30, 20'b1000_0000_0000_0000_0000 := 25, 20'b0111_1111_1111_1111_1111 :=25 };
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
    repeat(1500) begin
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
         
          assert(transmitted.randomize() with{sequ_item.instr_rdata_i[6:0]== 7'b1100011;
										 
										 	  sequ_item.instr_rdata_i[31:12] inside {20'b0000_0000_0000_0000_0000, 20'b1111_1111_1111_1111_1111,20'b1000_0000_0000_0000_0000, 20'b0111_1111_1111_1111_1111 };
										 	
										 	} );
		  
         
          transmitted.instr_rvalid_i = 1'b1;
          finish_item(transmitted);
        end
      end else begin
        start_item(transmitted);

        transmitted.instr_rvalid_i = 1'b0;
        finish_item(transmitted);
      end
	  `uvm_info("\n===============\nzero_ones_min_max_j_sequence",$sformatf("seq is randomized the values opcode : %0d and instr: %0d \n=============\n ",transmitted.instr_rdata_i[6:0],transmitted.instr_rdata_i), UVM_FULL)		
    end
  endtask : body
  // ----------------------------------------------------------------------

    
endclass

