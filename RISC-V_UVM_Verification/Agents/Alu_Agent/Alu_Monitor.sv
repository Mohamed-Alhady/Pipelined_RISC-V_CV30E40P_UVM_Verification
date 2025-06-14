 // ALU Monitor
  class input_alu_monitor extends uvm_monitor;
    `uvm_component_utils(input_alu_monitor)
    
    
    uvm_analysis_port #(alu_transaction) ap;
    
	
	alu_transaction tr  ;
	virtual alu_intf v_intf;
    function new(string name, uvm_component parent);
      super.new(name, parent);
      ap = new("ap", this);
    endfunction
    
    // ------------------------------ build_phase -----------------------------
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_full_name(), "input_mul CLASS", UVM_NONE);

  // ------------------------ Get virtual interface from agent ----------------
  if (!uvm_config_db#(virtual alu_intf)::get(this, "", "alu_vif", v_intf))
    `uvm_fatal(get_full_name(), "couldn't get interface from agent");
  // --------------------------------------------------------------------------
endfunction : build_phase

    task run_phase(uvm_phase phase);
      forever begin
        
       tr = alu_transaction::type_id::create("tr");
		
	@(posedge v_intf.clk)
 #2
  if(v_intf.enable_i && v_intf.ready_o) begin
    

        tr.operator 	= v_intf.operator_i ;
        tr.operand_a 	= v_intf.operand_a_i;
        tr.operand_b 	= v_intf.operand_b_i;
        tr.operand_c 	= v_intf.operand_c_i;
		    tr.alu_en 		= v_intf.enable_i;
        tr.result 		= v_intf.result_o;
       
        
        ap.write(tr);
          end
      end
    endtask
  endclass