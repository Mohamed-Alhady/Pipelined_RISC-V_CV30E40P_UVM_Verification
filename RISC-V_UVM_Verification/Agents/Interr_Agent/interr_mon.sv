class interr_mon extends uvm_monitor;
    //factory registration
    `uvm_component_utils(interr_mon)

    uvm_analysis_port#(seq_item) analysis_port;

    //-------------------------- constructor -----------------------------
    function new(string name = "interr_mon", uvm_component parent = null);
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction : new
    //---------------------------------------------------------------------

    driver_config drv_config;
    virtual interrupt_intf v_intf;
    
 

    //------------------------------ build_phase -----------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(), "interr_MON CLASS", UVM_NONE);

        //--------------------------- get virtual interface from agent -----------------
        if (!uvm_config_db#(virtual interrupt_intf)::get(this, "", "interr_vif", v_intf))
            `uvm_fatal(get_full_name(), "in agent");
        //--------------------------------------------------------------------------

    endfunction : build_phase
    //--------------------------------------------------------------------------

 
endclass
