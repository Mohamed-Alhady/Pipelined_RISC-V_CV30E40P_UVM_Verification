class interrupt_config extends uvm_object ;
	
	 //factory registeration
		`uvm_object_utils(interrupt_config)

	//-------------------------- constructor -----------------------------
	function  new( string name = "interrupt_config");
		super.new(name);
	endfunction : new
	//---------------------------------------------------------------------


	//----------------------- virtual Interface --------------
		virtual interrupt_intf vif;
	//--------------------------------------------------------

	//----------------------- set type of agent --------------
		uvm_active_passive_enum agent_active;
	//--------------------------------------------------------

endclass : interrupt_config

