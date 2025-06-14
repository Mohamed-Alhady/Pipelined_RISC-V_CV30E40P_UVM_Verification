// ======================
// config_monitor.sv
// ======================
class config_monitor extends uvm_monitor;
  virtual config_intf vif;

  `uvm_component_utils(config_monitor)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual config_intf)::get(this, "", "config_vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for config_monitor")
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);
      if (vif.fetch_enable) begin
        `uvm_info("CONFIG_MON", $sformatf("fetch_enable detected. boot_addr = 0x%0h", vif.boot_addr), UVM_LOW)
      end
    end
  endtask
endclass
