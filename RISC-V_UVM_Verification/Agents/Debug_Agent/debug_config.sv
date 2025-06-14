class debug_config extends uvm_object ;
	
	 //factory registeration
		`uvm_object_utils(debug_config)

	//-------------------------- constructor -----------------------------
	function  new( string name = "debug_config");
		super.new(name);
	endfunction : new
	//---------------------------------------------------------------------


	//----------------------- virtual Interface --------------
		virtual interrupt_intf vif;
	//--------------------------------------------------------

	//----------------------- set type of agent --------------
		uvm_active_passive_enum agent_active;
	//--------------------------------------------------------

endclass : debug_config

