class seq_item extends uvm_sequence_item;

    `uvm_object_utils(seq_item)
    
    function new(string name = "seq_item");
        super.new(name);
    endfunction

    logic [31:0]    instr_addr_o;       // Address
    logic           instr_req_o;        // Request valid
    logic           instr_gnt_i;        
    rand logic      instr_rvalid_i;     // valid
    rand logic      rst;
    rand logic [31:0] instr_rdata_i;    // Data read from memory
	rand logic [2:0] choice;	
    constraint opcode {
        instr_rdata_i[6:0] inside { 
            7'b0110011, 7'b1100011, 7'b0010011, 
            7'b0100011, 7'b0000011, 7'b1101111,  
            7'b1100111, 7'b0110111, 7'b0010111 
        };
    }



constraint rd {
    ( instr_rdata_i[6:0] != 7'b1100011 ||  instr_rdata_i[6:0]!= 7'b0100011  ) -> (instr_rdata_i[11:7] >3'b000);
  }
    constraint funct { 
        // R-Type
        (instr_rdata_i[6:0] == 7'b0110011) -> 
            (instr_rdata_i[31:25] inside {7'b0000000, 7'b010_0000, 7'b000_0001});  
			
		
        // R-Type specific funct3 with funct7 = 0100000
        (instr_rdata_i[6:0] == 7'b0110011 && instr_rdata_i[31:25] == 7'h20) -> 
            (instr_rdata_i[14:12] inside {3'b101, 3'b000}); 
						
		
        // I-Type
		(instr_rdata_i[6:0] == 7'b0010011) ->
            (instr_rdata_i[14:12] inside {3'b000, 3'b100, 3'b110, 3'b111, 3'b010, 3'b011, 3'b101, 3'b001 }); 
		
		
        // SRAI
        (instr_rdata_i[6:0] == 7'b0010011 && instr_rdata_i[31:25] == 7'b0100000) -> 
            (instr_rdata_i[14:12] inside {3'b101});  

        // SRLI, SLLI
        (instr_rdata_i[6:0] == 7'b0010011 && instr_rdata_i[31:25] == 7'b0000000) -> 
            (instr_rdata_i[14:12] inside {3'b101, 3'b001});  

        // Loads (I-Type)
        (instr_rdata_i[6:0] == 7'b0000011) -> 
            (instr_rdata_i[14:12] inside {3'b000, 3'b001, 3'b010, 3'b100, 3'b101});  

        // Stores (S-Type)
        (instr_rdata_i[6:0] == 7'b0100011) -> 
            (instr_rdata_i[14:12] inside {3'b000, 3'b001, 3'b010});  

        // Branches (B-Type)
        (instr_rdata_i[6:0] == 7'b1100011) ->  
            (instr_rdata_i[14:12] inside {3'b000, 3'b001, 3'b100, 3'b101, 3'b110, 3'b111});  

        // JALR (I-Type)
        (instr_rdata_i[6:0] == 7'b1100111) -> 
            (instr_rdata_i[14:12] inside {3'b000});  
    }

endclass
