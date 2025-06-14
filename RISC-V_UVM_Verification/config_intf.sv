
// ======================
// config_if.sv
// ======================
interface config_intf (
  input logic clk
);
	
  logic rst_n;
  logic pulp_clock_en;
  logic scan_cg_en;
  logic [31:0] boot_addr;
  logic [31:0] mtvec_addr;
  logic [31:0] dm_halt_addr;
  logic [31:0] dm_exception_addr;
  logic [31:0] hart_id;
  logic core_sleep_o;
  logic fetch_enable;

endinterface

