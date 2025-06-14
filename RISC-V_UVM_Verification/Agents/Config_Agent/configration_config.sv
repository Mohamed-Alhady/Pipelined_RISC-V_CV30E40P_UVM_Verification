class configuration_config extends uvm_object ;
	
	`uvm_object_utils(configuration_config)
	
	function  new(string name = "configuration_config");
		super.new(name);
	endfunction : new

	//----------------------- virtual Interface --------------
		virtual instruction_intf vif;
	//--------------------------------------------------------

	//----------------------- set type of agent --------------
		uvm_active_passive_enum agent_active;
	//--------------------------------------------------------

endclass : configuration_config

