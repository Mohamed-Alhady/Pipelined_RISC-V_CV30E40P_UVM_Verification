class instr_driver extends uvm_driver #(seq_item);

  // factory registration   
  `uvm_component_utils(instr_driver)
  virtual instruction_intf v_intf;

  extern function new(string name = "instr_driver", uvm_component parent = null);
  extern function void build_phase(uvm_phase phase);
  extern task reset_phase(uvm_phase phase);
  extern task main_phase(uvm_phase phase);

endclass

  // -------------------------- constructor -----------------------------
  function instr_driver::new(string name = "instr_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new
  // ---------------------------------------------------------------------

  // ------------------------------ build_phase -----------------------------
  function void instr_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "instr_DRIVER CLASS", UVM_NONE);

    // --------------------------- get virtual interface from agent -----------------
    if (!uvm_config_db#(virtual instruction_intf)::get(this, "", "instr_vif", v_intf))
      `uvm_fatal(get_full_name(), "couldn't get interface from agent");
    // ------------------------------------------------------------------------------
  endfunction : build_phase
  // --------------------------------------------------------------------------

  // ------------------------------ reset_phase -----------------------------
  task instr_driver::reset_phase(uvm_phase phase);
    
      begin
 
	  v_intf.instr_gnt_i     <= 1'b1;
		#3;
	  v_intf.instr_gnt_i     <= 1'b0;
		#3;
      v_intf.instr_gnt_i     <= 1'b1;
      v_intf.instr_rdata_i   <= 0;
      v_intf.instr_rvalid_i  <= 1'b0;
      //v_intf.fetch_enable_i  <= 1'b0;
 
    end
  endtask : reset_phase
  // --------------------------------------------------------------------------

  // ------------------------------ main_phase -----------------------------
  task instr_driver::main_phase(uvm_phase phase);
  
	seq_item sequ_item;
    forever begin
      seq_item_port.get_next_item(sequ_item);
		
    



      @(posedge v_intf.clk);
      if (sequ_item.instr_rvalid_i) begin
        v_intf.instr_rdata_i  <= sequ_item.instr_rdata_i; 
        v_intf.instr_rvalid_i <= 1'b1;
		 
      end else begin
        v_intf.instr_rvalid_i <= 1'b0;
      end
 `uvm_info("\n-------------\n Driver ",$sformatf("seq is drived instr : %0d\n-------\n",sequ_item.instr_rdata_i),UVM_FULL) 	
      seq_item_port.item_done();
	  end
  //  end
  endtask : main_phase
  // --------------------------------------------------------------------------
