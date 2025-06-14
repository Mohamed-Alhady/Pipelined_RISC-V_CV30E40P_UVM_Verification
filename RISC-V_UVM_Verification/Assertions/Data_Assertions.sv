module Data_SVA (

input bit 	clk				,
input logic rst_n			,
input logic data_req_o      ,
input logic data_gnt_i      ,
input logic data_addr_o     ,
input logic data_we_o       ,
input logic data_be_o		,
input logic data_wdata_o    ,
input logic data_rvalid_i   ,
input logic data_rdata_i

);

// requested must retain high until granted 
property Req_high_till_Gnt;
@(posedge clk) disable iff (!rst_n) 
data_req_o |-> ##[0:2] data_gnt_i ;

endproperty


// outstanding data should be 2 at max 
property Max_Two_Outstanding;
@(posedge clk) disable iff (!rst_n)
data_rvalid_i |-> $past(data_gnt_i, 1) ;

endproperty

// check rvalid should be one cycle

property R_Valid_Check;
        @(posedge clk) disable iff (!rst_n) 
		$rose(data_rvalid_i) |=> (!data_rvalid_i);
    endproperty
 
 

property Read_Data_Check;

        @(posedge clk) disable iff (!rst_n) 
		(data_rvalid_i && !data_we_o && $past(data_gnt_i,2) ) |-> !($isunknown(data_rdata_i));
 
    endproperty


property Write_Data_Check;

        @(posedge clk) disable iff (!rst_n) 
		(data_rvalid_i && data_we_o) |-> !($isunknown(data_wdata_o));
 
    endproperty
// Byte Enable should be unknown
property Byte_Enable_Check;

        @(posedge clk) disable iff (!rst_n) 
		(data_req_o) |-> !($isunknown(data_be_o));
 
    endproperty

// Be_Contigues
    property Be_Contigous ;

        @(posedge clk) disable iff (!rst_n) 
		(data_req_o && data_rvalid_i && !data_we_o) |-> (data_be_o inside {4'b0001, 4'b0010, 4'b0100, 4'b1000, 4'b0011, 4'b1100, 4'b1111, 4'b1110, 4'b0111, 4'b0110});
 
    endproperty

// misalligned access



//<<-------------------------------------------------------

Req_till_Gnt: assert property(Req_high_till_Gnt)
	//$display("Req_high_till_Gnt: Success assertion pass");
	
	else
	$display("Req_high_till_Gnt: Failed assertion ");

Max_2_Outstanding: assert property(Max_Two_Outstanding)
	//$display("Max_Two_Outstanding: Success assertion pass");
	
	else
	$display("Max_Two_Outstanding: Failed assertion ");
	
R_Valid: assert property(R_Valid_Check)
	//$display("R_Valid: Success assertion pass");
	
	else
	$display("R_Valid: Failed assertion ");

Read_Data: assert property(Read_Data_Check)
	//$display("Read_Data: Success assertion pass");
	
	else
	$display("Read_Data: Failed assertion ");

Write_Data: assert property(Write_Data_Check)
	//$display("Write_Data: Success assertion pass");
	
	else
	$display("Write_Data: Failed assertion ");


	
Byte_Enable: assert property(Byte_Enable_Check)
	//$display("Byte_Enable: Success assertion pass");
	
	else
	$display("Byte_Enable: Failed assertion ");	
	
Contigous: assert property(Be_Contigous)
	//$display("Be_Contigous: Success assertion pass");
	
	else
	$display("Be_Contigous: Failed assertion ");





endmodule