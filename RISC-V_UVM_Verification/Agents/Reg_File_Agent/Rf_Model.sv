class Rf_Model extends uvm_component;

	`uvm_component_utils( Rf_Model )

	reg_transaction actual_item;
	reg_transaction resp_item;


	
	uvm_analysis_export   #(reg_transaction) rf_ae; 		
	uvm_tlm_analysis_fifo #(reg_transaction) rf_fifo; 		
	uvm_analysis_port     #(reg_transaction) rf_ap;
	

	logic [31:0] Ref_Mem [bit [4:0]]; 		

	
	function new(string name = "Rf_Model", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		resp_item	= reg_transaction::type_id::create("resp_item");

		rf_ae 	= new("rf_ae	", this);
		rf_fifo	= new("rf_fifo	", this);
		rf_ap	= new("rf_ap	", this);
		
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		rf_ae.connect(rf_fifo.analysis_export);
	endfunction

	function void rf_reset; 					//reset RF
		for (int i = 0; i < 32; i++) begin
			Ref_Mem[i] = 'h0;
		end
	endfunction 




 function logic[31:0] read_reg(int regnum);

    return Ref_Mem[regnum];

  endfunction:read_reg




  function void write_reg(int regnum, logic [31:0] data);
             

        Ref_Mem[regnum] = data ; 

  endfunction:write_reg




	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
			rf_fifo.get(actual_item);
			actual_item = reg_transaction::type_id::create("actual_item");
			resp_item.we_a_i    = actual_item.we_a_i;
			resp_item.waddr_a_i = actual_item.waddr_a_i;
			resp_item.wdata_a_i = actual_item.wdata_a_i;
			
			resp_item.we_b_i 	    = actual_item.we_b_i;
			resp_item.waddr_b_i 	= actual_item.waddr_b_i;
			resp_item.wdata_b_i 	= actual_item.wdata_b_i;
			
			
			resp_item.raddr_a_i = actual_item.raddr_a_i;
			resp_item.raddr_b_i = actual_item.raddr_b_i;
			resp_item.raddr_c_i = actual_item.raddr_c_i;
			
			
			resp_item.rdata_a_o = read_reg(resp_item.raddr_a_i);
			resp_item.rdata_b_o = read_reg(resp_item.raddr_b_i);
			resp_item.rdata_c_o = read_reg(resp_item.raddr_c_i);
			
			if (resp_item.we_b_i && resp_item.waddr_b_i != 5'h0)
			write_reg(resp_item.waddr_b_i , resp_item.wdata_b_i);
			
			else if (resp_item.we_a_i && resp_item.waddr_a_i != 5'h0)
			write_reg(resp_item.waddr_a_i , resp_item.wdata_a_i);
						
			//rf_ap.write(ref_item);
		end

	endtask : run_phase

	

	
	
	
	
	

endclass : Rf_Model