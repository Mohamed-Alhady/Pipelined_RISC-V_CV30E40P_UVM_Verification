  class debug_mon extends uvm_monitor;
    //factory registeration
    `uvm_component_utils(debug_mon)
    
    uvm_analysis_port#(seq_item) analysis_port;

    //-------------------------- constructor -----------------------------
    function  new(string name = "debug_mon" , uvm_component parent = null);
     	super.new(name,parent);
         analysis_port = new ("analysis_port",this);
    endfunction : new
    //---------------------------------------------------------------------   

    driver_config drv_config;
    virtual debug_intf v_intf;
    
    bit   flag;
    
    //------------------------------ build_phase -----------------------------   
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
        `uvm_info(get_full_name(),"debug_MON CLASS",UVM_NONE);
      //--------------------------- get vir interface from agent -----------------  
       if(!uvm_config_db#(virtual debug_intf)::get(this, "", "debug_vif", v_intf))
      `uvm_fatal(get_full_name(),"in agent");
    
      //--------------------------------------------------------------------------    
  
    endfunction : build_phase
    //--------------------------------------------------------------------------

 
  endclass



 
