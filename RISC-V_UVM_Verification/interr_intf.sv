interface interrupt_intf (input clk,rst_n);

   
     logic [31:0] irq_i;  
     logic        irq_ack_o;
     logic [ 4:0] irq_id_o;

endinterface : interrupt_intf