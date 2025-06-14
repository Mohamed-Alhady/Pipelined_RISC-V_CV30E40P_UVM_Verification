// ======================
// config_driver.sv
// ======================
class config_driver extends uvm_driver #(config_seq_item);
  virtual config_intf vif;

  `uvm_component_utils(config_driver)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual config_intf)::get(this, "", "config_vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set for config_driver")
  endfunction

  task reset_phase(uvm_phase phase);
    config_seq_item sequ_item;
    forever begin
      seq_item_port.get_next_item(sequ_item);

      vif.rst_n             <= sequ_item.rst;
      vif.pulp_clock_en     <= 1'b0;
      vif.scan_cg_en        <= 1'b0;
      vif.boot_addr         <= 32'h0000_0000;
      vif.mtvec_addr        <= 32'h0000_0100;
      vif.dm_halt_addr      <= 32'h1A11_1000;
      vif.dm_exception_addr <= 32'h1A11_1010;
      vif.hart_id           <= 32'h0000_0000;
      vif.fetch_enable      <= 1'b0;

      @(negedge vif.clk);
      seq_item_port.item_done();
    end
  endtask : reset_phase

  virtual task configure_phase(uvm_phase phase);
    config_seq_item tr;
    forever begin
      seq_item_port.get_next_item(tr);

      @(posedge vif.clk);

      vif.rst_n <= 1'b1;

      vif.fetch_enable <= 1'b0;
      @(posedge vif.clk);
      vif.fetch_enable <= 1'b1;
      @(posedge vif.clk);
      vif.fetch_enable <= 1'b0;
      `uvm_info("CONFIG_DRV", "Applied configuration transaction", UVM_MEDIUM)

      seq_item_port.item_done();
    end
  endtask
endclass
