//import uvm_pkg::*;
//`include "uvm_macros.svh"
  `uvm_analysis_imp_decl(_instr_in)
  `uvm_analysis_imp_decl(_instr_out)
  `uvm_analysis_imp_decl(_mem)


class CV32E40P_Predictor extends uvm_component;
	`uvm_component_utils(CV32E40P_Predictor)
	
uvm_tlm_analysis_fifo #(seq_item) instr_in_fifo 	;
uvm_tlm_analysis_fifo #(seq_item) instr_out_fifo 	;
uvm_tlm_analysis_fifo #(data_seq_item) data_fifo 		;


uvm_analysis_imp_instr_in 	#(seq_item, CV32E40P_Predictor)  	instr_in_analysis_imp	;
uvm_analysis_imp_instr_out 	#(seq_item, CV32E40P_Predictor)  	instr_out_analysis_imp	;
uvm_analysis_imp_mem 	    #(data_seq_item, CV32E40P_Predictor)  	data_analysis_imp  		;

//uvm_analysis_port #(data_seq_item) predict_ap;

Rf_Model 	    reg_ins	 ;
Storage_Model 	data_mem ;


seq_item  pc_item 	,resp_instr	;
data_seq_item  data_item;


logic[31:0] IF,ID,IEXE,IMEM,IWB,temp_inst ;
logic[31:0] PC_t = 0;
logic[31:0] PC = 0,PT=0;
logic[31:0] PC_IF,PC_ID,PC_IEXE,PC_IMEM,PC_IWB;
logic[31:0] reg31_IWB;
logic[31:0] Wdata_IMEM;
logic[31:0] Wdata2reg_1,Wdata2reg_2_EXE,Wdata2reg_2_MEM,Wdata2reg_2_WB;
logic[4:0]  rd_write ;
logic[4:0]  rs_write ;

logic [31:0] expected_result;
logic [31:0] real_result;


extern function new(string name = "CV32E40P_Predictor" , uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

extern function void write_instr_in(seq_item pc_item);
extern function void write_instr_out(seq_item resp_instr);
extern function void write_mem(data_seq_item data_item);

extern function [31:0] SignExt(bit [11:0] imm);
extern function void R_Type_Decoder		(logic[31:0] IEXE, ref Rf_Model reg_ins	);
extern function void I_Type_Decoder		(logic[31:0] IEXE, ref Rf_Model reg_ins	);
extern function void ILoad_Type_Decoder	(logic[31:0] IEXE, ref Rf_Model reg_ins, ref Storage_Model data_mem	);
extern function void S_Type_Decoder		(logic[31:0] IMEM, ref Rf_Model reg_ins, ref Storage_Model data_mem   	);
extern function void B_Type_Decoder     (logic[31:0] IEXE, ref Rf_Model reg_ins    );  
extern function void J_Type_Decoder		(logic[31:0] IEXE, ref Rf_Model reg_ins	);
extern function void J_Type_Decoder_jalr(logic[31:0] IEXE, ref Rf_Model reg_ins	);
extern function void U_Type_Decoder_auipc(logic[31:0]IEXE, ref Rf_Model reg_ins	);
extern function void U_Type_Decoder_Lui	(logic[31:0] IEXE, ref Rf_Model reg_ins	);

//extern static function void MUL_Type_Decoder	(logic[31:0] instr, ref Reg_Model reg_ins, p_trans					);

extern task run_phase(uvm_phase phase);


endclass



function CV32E40P_Predictor::new(string name = "CV32E40P_Predictor" , uvm_component parent);
	super.new(name , parent);

	instr_in_analysis_imp	=	new("instr_in_analysis_imp	"	, this)	;
	instr_out_analysis_imp	=	new("instr_out_analysis_imp	"	, this)	;
    data_analysis_imp  		=	new("data_analysis_imp  	"	, this)	;


	instr_in_fifo 	= new("instr_in_fifo 	"	, 	this)	;
	instr_out_fifo 	= new("instr_out_fifo 	"	, 	this)	;
	data_fifo 		= new("data_fifo 		"	,	this)	;

endfunction



//<<---------------------- Build Phase --------------------

function void CV32E40P_Predictor::build_phase(uvm_phase phase);
    super.build_phase(phase);  
   
   `uvm_info("\n<<<<<<<<<<<<<<<<<<<\nCV32E40P_Predictor",$sformatf("Build phase\n>>>>>>>>>>>>>>>>>>>\n"), UVM_LOW);
   
//  if(!uvm_config_db#(Rf_Model)::get(this, "", "reg_model" , reg_ins))
//		`uvm_info(get_full_name(), "error_reg_ref_Model", UVM_NONE);
//		
//	 if(!uvm_config_db#(Storage_Model)::get(this, "", "mem_model" , data_mem))
//		`uvm_info(get_full_name(), "error_Storage_Model", UVM_NONE);
	
	pc_item = seq_item::type_id::create("pc_item", this);
	resp_instr = seq_item::type_id::create("resp_instr", this);
	data_item = data_seq_item::type_id::create("data_item", this);

	reg_ins		= Rf_Model::type_id::create("reg_ins	",this);
	data_mem    = Storage_Model::type_id::create("data_mem",this);
	
	uvm_config_db#(Rf_Model)::get(this, "", "reg_model", reg_ins);
  //`uvm_fatal("NORF", "Register file model not found")
  //end
  
  uvm_config_db#(Storage_Model)::get(this, "", "memory", data_mem) ;
 // `uvm_fatal("NORF", "Storage file model not found")
//end
	
	
  endfunction
 

//<<----------------------- Connect Phase -----------------

function void CV32E40P_Predictor::connect_phase(uvm_phase phase);
  super.connect_phase(phase);
    `uvm_info("\n<<<<<<<<<<<<<<<<<<<<CV32E40P_Predictor",$sformatf("Connect Phase\n>>>>>>>>>>>>>>>>>>>>>>>>>\n"), UVM_NONE);
  endfunction

//<<-------------------  Write Functions ----------------------

function void CV32E40P_Predictor::write_instr_in(seq_item pc_item);
  instr_in_fifo.write(pc_item);
  
	endfunction
	
  function void CV32E40P_Predictor::write_instr_out(seq_item resp_instr);
  instr_out_fifo.write(resp_instr);
  
	endfunction
	
	function void CV32E40P_Predictor::write_mem(data_seq_item data_item);
  data_fifo.write(data_item);
  
	endfunction



//<<------------------ Run Phase -------------------
logic [31:0] instr ;

task CV32E40P_Predictor::run_phase(uvm_phase phase);
	super.run_phase(phase);
	forever begin
	
	instr_in_fifo.get_peek_export.get(pc_item);
	instr_out_fifo.get_peek_export.get(resp_instr);
	data_fifo.get_peek_export.get(data_item);
	`uvm_info("\n<<<<<<<<<<<<<<<<<<<<<<<\n CV32E40P_scoreboard", $sformatf("RUN_PHASE and instr : %0b, ID : %0b, IEXE : %0b, IMEM : %0b, IWB : %0b  \n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n", pc_item.instr_rdata_i,ID, IEXE, IMEM, IWB), UVM_NONE)
	
	// get instruction address
	
	temp_inst = IWB ;
	IWB  = IMEM ;
	IMEM = IEXE ;
	IEXE = ID ;
	ID   = instr ;
	instr= pc_item.instr_rdata_i;
	
	//-----------------------------//
	
	
	   PC_IWB 	= PC_IMEM;
       PC_IMEM 	= PC_IEXE;
       PC_IEXE 	= PC_ID;
       PC_ID 	= PC_IF;
       PC_IF 	= resp_instr.instr_addr_o;
	
	
	
	//instr = instr_mem[pc_item.data_addr_o] ; // get instruction from instruction Model
	//instr = pc_item.instr_rdata_i;
	
	// ---------------------------------------------------------------------//
	case(IEXE[6:0])
	
	7'b0110011 : R_Type_Decoder			(IEXE , reg_ins	); 
	7'b0010011 : I_Type_Decoder			(IEXE , reg_ins	); 
	7'b0000011 : ILoad_Type_Decoder		(IEXE , reg_ins , data_mem); 
	//7'b0100011 : S_Type_Decoder			(instr , reg_ins , data_mem , p_trans   ); 
	7'b1100011 : B_Type_Decoder			(IEXE , reg_ins	); 
	7'b0110111 : U_Type_Decoder_Lui 	(IEXE , reg_ins );
	7'b0010111 : U_Type_Decoder_auipc	(IEXE , reg_ins ); //check
	7'b1101111 : J_Type_Decoder			(IEXE , reg_ins );//check
	7'b1100111 : J_Type_Decoder_jalr	(IEXE , reg_ins );//check
	
	
	
	endcase
	
	if(IMEM[6:0] == 7'b0100011) 
		S_Type_Decoder(IMEM , reg_ins , data_mem   ); 
		
	
	if(IWB[6:0] == 7'b0110011 || IWB[6:0] == 7'b0010011 || IWB[6:0] == 7'b0000011 || IWB[6:0] == 7'b0110111 || IWB[6:0] == 7'b0010111   ) begin
	
		if( Wdata2reg_2_WB == reg_ins.read_reg(rd_write))
				
			`uvm_info("\n<<<<<<<<<<<<<<<<<<<<<<<\n CV32E40P_scoreboard", $sformatf("Result match and R,I,U operations passed successfully Expected  \n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n"), UVM_NONE)
		
		else
		`uvm_error("\n\n<<<<<<<<<<<<<<<<<<<<<<<< \n CV32E40P_scoreboard", $sformatf("Result match and R,I,U operations Failed Expecte \n>>>>>>>>>>>>>>>>>>>>>>>\n"))
	
	end
	
	else if( IWB[6:0] == 7'b0100011) begin
      if(expected_result == real_result)
			`uvm_info("\n\n============ \n CV32E40P_scoreboard", $sformatf("Result match and Store operation passed successfully Expected  \n======================\n"),  UVM_NONE)
		
		else
		`uvm_error("\n\n==================== \n CV32E40P_scoreboard", $sformatf("Result match and Store operation Failed  \n======================\n"))
	
	end
		

//	else if(instr[6:0] ==7'b1101111 || instr[6:0] ==7'b1100111) begin
//	
//		if(pc_item.instr_addr_o == p_trans.pc)
//			`uvm_info("\n\n============================== \n CV32E40P_scoreboard", $sformatf("Result match and J, Jr operations passed successfully Expected  \n====================\n",pc_item.instr_addr_o , p_trans.pc), UVM_LOW)
//		
//		else
//		`uvm_error("\n\n========================== \n CV32E40P_scoreboard", $sformatf("Result match and J,Jr operations Failed Expected = %1d , actual = %1d \n========================\n",pc_item.instr_addr_o , p_trans.pc))
//	
//	end
//	else if(instr[6:0] ==7'b1100011) begin
//	
//		if(pc_item.instr_addr_o == p_trans.pc)
//			`uvm_info("\n\n========================= \n CV32E40P_scoreboard", $sformatf("Result match and B operation passed successfully Expected = %1d , actual = %1d \n======================\n",pc_item.instr_addr_o , p_trans.pc), UVM_LOW)
//		
//		else
//		`uvm_error("\n\n========================== \n CV32E40P_scoreboard", $sformatf("Result match and B operation Failed Expected = %1d , actual = %1d \n=====================\n",pc_item.instr_addr_o , p_trans.pc))
//	
//	end
//	
	
	
	end
	
endtask

//<<----------------------------------- R_Type_Decoder -------------------------------------------

function void CV32E40P_Predictor::R_Type_Decoder(logic[31:0] IEXE, ref Rf_Model reg_ins);

logic [4:0] rs1 = 	IEXE[19:15]	;
logic [4:0] rs2 =   IEXE[24:20] ;
logic [4:0] rd  =   IEXE[11:7 ] ;

logic [31:0] op1 = reg_ins.read_reg(rs1) ; // access data of rs1 address 
logic [31:0] op2 = reg_ins.read_reg(rs2) ; // access data of rs2 address 

logic [31:0] expected_result;		 
      logic [63:0] temp	;

if(IEXE[31:25] == 7'h01) begin


  case (IEXE[14:12])  
    
    3'h0 : temp = op1 * op2;
		
	3'h1 : temp = op1 * op2 ; 
	
	3'h2 : temp =op1 * $unsigned(op2);
	
	3'h3 : temp = $unsigned(op1) * $unsigned(op2);
	
	3'h4 : temp = op1 / op2;
	
	3'h5 : temp = op1 / op2;
	
	3'h6 : temp = op1 % op2;  
	
	3'h7 : temp =  $unsigned(op1) % $unsigned(op2);  
  
  endcase
	
	if(IEXE[14:12]==3'b001 || IEXE[14:12]==3'b010 || IEXE[14:12]==3'b011)
				expected_result = temp[63:32];
				
	else 
		expected_result = temp[31:0];
end
		
			///---------------------------------------------------------------------------//
			
/// the rest of  R-Type Arthematic , logical and shift Operations 

else begin
	if(IEXE[14:12] == 3'h0 && IEXE[31:25] == 7'h20 )
		expected_result = op1 - op2	;
		
	else if(IEXE[14:12] == 3'h5 && IEXE[31:25] == 7'h20 )
		expected_result = op1 >>> op2[4:0]	;
	
	else if(IEXE[14:12] == 3'h0 )	
		expected_result = op1 + op2	;
		
	else if(IEXE[14:12] == 3'h4 )	
		expected_result = op1 ^ op2	;
		
	else if(IEXE[14:12] == 3'h6 )	
		expected_result = op1 | op2	;
		
	else if(IEXE[14:12] == 3'h7 )	
		expected_result = op1 & op2;
		
	else if(IEXE[14:12] == 3'h1 )	
		expected_result = op1 << op2[4:0];
	
	else if(IEXE[14:12] == 3'h5 )	
		expected_result = op1 >> op2[4:0];
	
	else if(IEXE[14:12] == 3'h2 )	
		expected_result = { {31{1'b0}}, ((op1<op2)?1:0)};
		
	else if(IEXE[14:12] == 3'h3 )	
		expected_result = { {31{1'b0}}, ($signed(op1)<$signed(op2)?1:0)};

end

 //reg_ins.write_reg(rd, expected_result);
 //p_trans.rd_data = expected_result ;
 //p_trans.rd_addr = rd ;
 rd_write = rd ;
 Wdata2reg_2_EXE = expected_result ;


//`uvm_info("\n\n---------------- \n CV32E40P_scoreboard", $sformatf("Expected R_Type addr = %1d : %1d , data = %1d : %1d \n-----------\n",rd,p_trans.rd_addr ,expected_result, p_trans.rd_data), UVM_LOW) 

endfunction

//<<----------------------------------- I_Type_Decoder -------------------------------------------

function void CV32E40P_Predictor::I_Type_Decoder(logic[31:0] IEXE, ref Rf_Model reg_ins);

logic [4:0] rs1 = 	IEXE[19:15]	;
logic [4:0] imm =   IEXE[31:20]    ;
logic [4:0] rd  =   IEXE[11:7 ]    ;

logic [31:0] op1 = reg_ins.read_reg(rs1) ; 	//access data of rs1 address 


logic [31:0] expected_result;

if(IEXE[14:12] == 3'h5 && IEXE[31:25] == 7'h20 )
	expected_result = op1 >>> imm[4:0];
	
else if(IEXE[14:12] == 3'h0)
	expected_result = op1 + SignExt(imm);

else if(IEXE[14:12] == 3'h4 )	
	expected_result = op1 ^ SignExt(imm);
	
else if(IEXE[14:12] == 3'h6 )	
	expected_result = op1 | SignExt(imm) ;
	
else if(IEXE[14:12] == 3'h7 )	
	expected_result = op1 & SignExt(imm) ;
	
else if(IEXE[14:12] == 3'h1 )	
	expected_result = op1 << imm[4:0]	;

else if(IEXE[14:12] == 3'h5 )	
	expected_result = op1 >> imm[4:0]	;

else if(IEXE[14:12] == 3'h2 )	
	//op2 = SignExt(imm);
	expected_result = (op1 < SignExt(imm))?1:0;

else if(IEXE[14:12] == 3'h3 )	
	 //op2 = {{20{0}},imm};
	expected_result = (op1 < $unsigned({{20{0}},imm}))?1:0;

 //reg_ins.write_reg(rd, expected_result);
 //p_trans.rd_data = expected_result ;
 //p_trans.rd_addr = rd ;
 
 Wdata2reg_2_EXE = expected_result ;
 rd_write = rd ; 
 //`uvm_info("\n\n---------------- \n CV32E40P_scoreboard", $sformatf("Expected I_Type addr = %1d : %1d , data = %1d : %1d \n-----------\n",p_trans.rd_addr,rd, expected_result, p_trans.rd_data ), UVM_LOW) 
 
endfunction

//<<--------------------------------------- Load instructions ----------------------

function void CV32E40P_Predictor::ILoad_Type_Decoder(logic[31:0] IEXE, ref Rf_Model reg_ins, ref Storage_Model data_mem);

logic [4:0] 	rs1 = 	IEXE[19:15]	;
logic [11:0] 	imm =   IEXE[31:20]    ;
logic [4:0] 	rd  =   IEXE[11:7 ]    ;

logic [31:0] op1 = reg_ins.read_reg(rs1)  ;


logic [31:0] temp;
logic [31:0] expected_result;

if(IEXE[14:12] == 3'h0  )begin

	temp  = data_mem.read(op1+SignExt(imm));
	expected_result = {{24{temp[7]}} ,temp[7:0]} ;
end

else if(IEXE[14:12] == 3'h1  )begin

	temp  = data_mem.read(op1+SignExt(imm));
	expected_result = {{16{temp[15]}} ,temp[15:0]};
end

else if(IEXE[14:12] == 3'h2  )begin
	temp  = data_mem.read(op1+SignExt(imm));
	expected_result = temp ;
end

else if(IEXE[14:12] == 3'h4  )begin
	temp  = data_mem.read(op1+SignExt(imm));
	expected_result = {24'b0 ,temp[7:0]};
end

else if(IEXE[14:12] == 3'h5  )begin
	temp  = data_mem.read(op1+SignExt(imm));
	expected_result = {16'b0 ,temp[15:0]};
end

//data_resp.data_rdata_i = expected_result ;
//reg_ins.write_reg(rd, expected_result);
	//predict_ap.write(data_resp);
//	p_trans.rd_data = expected_result ;
//	p_trans.rd_addr = rd ;
rd_write = rd ; 
	Wdata2reg_2_EXE = expected_result ;
//`uvm_info("\n\n---------------- \n CV32E40P_scoreboard", $sformatf("Expected load Instruction addr = %1d : %1d , data = %1d : %1d \n-----------\n",p_trans.rd_addr,rd, expected_result, p_trans.rd_data ), UVM_LOW) 	
	
endfunction

//<<----------------------------------- S_Type_Decoder -------------------------------------------

function void CV32E40P_Predictor::S_Type_Decoder(logic[31:0] IMEM , ref Rf_Model reg_ins, ref Storage_Model data_mem);

logic [4:0] 	rs1 	= 	IMEM[19:15]	;
logic [4:0] 	rs2 	=   IMEM[24:20]    ;
logic [11:0]	imm     =  {IMEM[31:25] , IMEM[11:7]}	;

logic [31:0] op1 = reg_ins.read_reg(rs1) ;
logic [31:0] op2 = reg_ins.read_reg(rs2) ;


  if(IMEM[14:12] == 3'h0 ) begin
	//p_trans.rs2_data = {{24{op2[7]}}, op2[7:0]} ; 
   // p_trans.rs1_data = data_mem.read(SignExt(imm)+rs1) ;
	
	expected_result = {{24{op2[7]}}, op2[7:0]} ; 
	real_result     = data_mem.read(SignExt(imm)+rs1) ;
  end

  else if(IMEM[14:12] == 3'h1 ) begin
	//p_trans.rs2_data = {{16{op2[15]}}, op2[15:0]} ; 
   // p_trans.rs1_data = data_mem.read(SignExt(imm)+rs1) ;
 expected_result  = {{16{op2[15]}}, op2[15:0]} ; 
 real_result      = data_mem.read(SignExt(imm)+rs1) ;
   
   
  end
	
  else if(IMEM[14:12] == 3'h2 ) begin
  
	expected_result =	op2 ;   
	real_result     =	data_mem.read(SignExt(imm)+rs1) ;  
  
  end
	//p_trans.rs2_data = op2 ;  
    //p_trans.rs1_data = data_mem.read(SignExt(imm)+rs1) ; 
    //                            end
//data_resp.data_rdata_i = op2 ;

//predict_ap.write(data_resp);

endfunction

//<<------------------------------------- B_type_Decoder ------------------------

function void CV32E40P_Predictor::B_Type_Decoder(logic[31:0] IEXE, ref Rf_Model reg_ins);

logic [4:0] 	rs1 	= 	IEXE[19:15]	;
logic [4:0] 	rs2 	=   IEXE[24:20]    ;
logic [6:0]		imm     =  {IEXE[31], IEXE[7], IEXE[30:25] , IEXE[11:8],1'b0}	;

logic [31:0] op1 = reg_ins.read_reg(rs1) ;
logic [31:0] op2 = reg_ins.read_reg(rs2) ;
logic [31:0] expected_result;

if(IEXE[14:12] == 3'h0 ) begin
	if(op1 == op2)
		expected_result = resp_instr.instr_addr_o + SignExt(imm) ;
	
	else 
		expected_result = resp_instr.instr_addr_o + 4 ;

end	

else if(IEXE[14:12] == 3'h1 ) begin
	if(op1 != op2)
		expected_result = resp_instr.instr_addr_o + SignExt(imm) ;
	
	else 
		expected_result = resp_instr.instr_addr_o + 4 ;
		
end
		
else if(IEXE[14:12] == 3'h4 ) begin
	if($signed(op1) < $signed(op2))
		expected_result = resp_instr.instr_addr_o + SignExt(imm) ;
	
	else 
		expected_result = PC_IEXE + 4 ;

end
		
else if(IEXE[14:12] == 3'h5 ) begin
	if($signed(op1) >= $signed(op2))
		expected_result = resp_instr.instr_addr_o + SignExt(imm) ;
	
	else 
		expected_result = PC_IEXE + 4 ;
end

else if(IEXE[14:12] == 3'h6 ) begin
	if($unsigned(op1) < $unsigned(op2))
		expected_result = resp_instr.instr_addr_o + SignExt(imm) ; 
	
	else 
		expected_result = PC_IEXE + 4 ;
end

else if(IEXE[14:12] == 3'h7 ) begin
  if($unsigned(op1) >= $unsigned(op2))
		expected_result = resp_instr.instr_addr_o + SignExt(imm) ; 
	
	else 
		expected_result = PC_IEXE + 4 ;

end	

//p_trans.pc =  expected_result ;

if(expected_result == ( resp_instr.instr_addr_o + SignExt(imm)))  begin 

          ID =32'bx;
          IF=32'bx;
          PT=1;

       end

endfunction



//<<---------------------------------- J_Type -------------------------------------

function void CV32E40P_Predictor::J_Type_Decoder(logic[31:0] IEXE, ref Rf_Model reg_ins);


logic [4:0] 	rd  =    IEXE[11:7 ];
logic [20:1]	imm =	{{12{IEXE[31]}}, IEXE[19:12], IEXE[20], IEXE[30:21]};

logic [31:0] 	rd_addr =  resp_instr.instr_addr_o + 4      ;
logic [31:0] expected_result;

//reg_ins.read_reg(rd) = rd_addr;  
Wdata2reg_1 = rd_addr ;
expected_result = resp_instr.instr_addr_o + imm;

ID =32'bx;
        IF=32'bx;
        PT=1;

//p_trans.pc = expected_result ;

endfunction
 
      //-------------------------------------//
 
function void CV32E40P_Predictor::J_Type_Decoder_jalr(logic[31:0] IEXE, ref Rf_Model reg_ins);
 
logic [19:0] imm =   IEXE[31:20];
logic [4:0] rd  =    IEXE[11:7 ];
logic [4:0] rs1 = 	 IEXE[19:15]	;


logic [31:0] rs1_addr = reg_ins.read_reg(IEXE[19:15]);

logic [31:0] rd_addr = resp_instr.instr_addr_o + 4;

logic [31:0] expected_result;

Wdata2reg_1 = rd_addr ;
expected_result = resp_instr.instr_addr_o + imm;

ID =32'bx;
        IF=32'bx;
        PT=1;

//p_trans.pc = expected_result ;
 
endfunction

//<<------------------------------------------------ U_Type Decoder -----------------

function void CV32E40P_Predictor::U_Type_Decoder_auipc(logic[31:0] IEXE, ref Rf_Model reg_ins);
 
logic [19:0] imm =   IEXE[31:12];
logic [4:0 ] rd  =   IEXE[11:7 ];

logic [31:0] expected_result;
expected_result = resp_instr.instr_addr_o + {imm, 12'b0}; 
// p_trans.rd_data = expected_result ; 
 
 Wdata2reg_2_EXE = expected_result ;
 rd_write = rd ; 
endfunction

function void CV32E40P_Predictor::U_Type_Decoder_Lui(logic[31:0] IEXE, ref Rf_Model reg_ins);
 
logic [19:0] imm =   IEXE[31:12];
logic [4:0 ] rd  =   IEXE[11:7 ];

logic [31:0] expected_result;
expected_result =  {imm, 12'b0} ; 

Wdata2reg_2_EXE = expected_result ;
 rd_write = rd ; 
//p_trans.rd_data = expected_result ; 
endfunction


//<<----------------------------------------- MUL_Type Decoder ---------------------------
/*
static function void CV32E40P_predictor::MUL_Type_Decoder(logic[31:0] instr, ref Rf_Model reg_ins, seq_item seq_items);

bit [63:0] temp;

logic [4:0] rs1 = 	instr[19:15]	;
logic [4:0] rs2 =   instr[31:20]    ;
logic [4:0] rd  =   instr[11:7 ]    ;

logic [31:0] op1 = reg_ins.read(rs1) ;
logic [31:0] op2 = reg_ins.read(rs2) ;

logic [31:0] expected_result;

if(instr[14:12] == 3'h0  )
	temp = op1 * op2;;
	
else if(instr[14:12] == 3'h1)
	temp = op1 * op2 ; 

else if(instr[14:12] == 3'h2 )	
	temp =op1 * $unsigned(op2);

else if(instr[14:12] == 3'h3 )	
	temp = $unsigned(op1) * $unsigned(op2);

else if(instr[14:12] == 3'h4 )	
	temp = op1 / op2;

else if(instr[14:12] == 3'h5 )	
	temp = op1 / op2;

else if(instr[14:12] == 3'h6 )	
	temp = op1 % op2;  

else if(instr[14:12] == 3'h7 )	
	temp =  $unsigned(op1) % $unsigned(op2);  

 if( instr[14:12]==3'b001 || instr[14:12]==3'b010 || instr[14:12]==3'b011)
              expected_result = temp[63:32];
        else
              expected_result = temp[31:0];
            end
 
 reg_ins.write_reg(rd, expected_result);
endfunction

*/


// Function to Sign Extend
function [31:0] CV32E40P_Predictor::SignExt(bit [11:0] imm);
    SignExt = {{20{imm[11]}}, imm};
endfunction

 


//class Rf_Model extends uvm_object;
//  rand logic [31:0] regs[32];
//
//  /*function logic [31:0] read(logic [4:0] addr);
//    return (addr == 0) ? 0 : regs[addr];
//  endfunction
//
//  function void write(logic [4:0] addr, logic [31:0] data);
//    if (addr != 0)
//      regs[addr] = data;
//  endfunction
//  */
//endclass
//       

       
//class Storage_Model extends uvm_object;
//  rand logic [31:0] memory[int];
///*
//  function logic [31:0] read(logic [31:0] addr);
//    return memory[addr];
//  endfunction
//
//  function void write(logic [31:0] addr, logic [31:0] data);
//    memory[addr] = data;
//  endfunction
//  */
//endclass 
