`uvm_analysis_imp_decl(_inst)
`uvm_analysis_imp_decl(_data)

class Coverage_Collector extends uvm_component;
    `uvm_component_utils(Coverage_Collector)

    uvm_analysis_imp_inst #(seq_item, Coverage_Collector) inst_port;
    uvm_analysis_imp_data #(data_seq_item, Coverage_Collector) data_port;

    data_seq_item data_item;
    bit [4:0] rs1,rs2,rd;
    
    //=======================================================//
    //////// bins to cover all posibilities R_Type points    
    
    covergroup R_instr_cover ; 
        R_Type_instr: coverpoint item.instr_rdata_i[14:12] {
			bins SUB  = {3'b000} iff (item.instr_rdata_i[31:25] == 7'b010_0000);
            bins ADD  = {3'b000} iff (item.instr_rdata_i[31:25] == 7'b000_0000); 
            bins XOR  = {3'b100};
            bins OR   = {3'b110};
            bins AND  = {3'b111}; 
            bins SLL  = {3'b001};
            bins SRL  = {3'b101} iff (item.instr_rdata_i[31:25] == 7'b000_0000);
            bins SRA  = {3'b101} iff (item.instr_rdata_i[31:25] == 7'b010_0000);
            bins SLT  = {3'b010};
            bins SLTU = {3'b011};                   
        }

        R_Type_rs1: coverpoint rs1 {
            bins rs1[] = {[0:31]};
        }

        R_Type_rs2: coverpoint rs2 {
            bins rs2[] = {[0:31]};
        }

        R_Type_rd: coverpoint rd {
            bins rd[] = {[1:31]};
            ignore_bins zeros[] = {0}; 
        }

       
	
    endgroup: R_instr_cover
	
	

    //<<----------------------------------------------------------------------------------
    //// bins to cover all posibilities I_Type points

    covergroup I_instr_cover ; 
	option.cross_auto_bin_max = 0;
        I_Type_instr: coverpoint item.instr_rdata_i[14:12] {
            bins ADDI  = {3'b000};
            bins XORI  = {3'b100};
            bins ORI   = {3'b110};
            bins ANDI  = {3'b111}; 
            bins SLLI  = {3'b001};
            bins SRLI  = {3'b101};
            bins SRAI  = {3'b101} iff (item.instr_rdata_i[31 :25] == 7'h20);
            bins SLTI  = {3'b010};
            bins SLTU  = {3'b011};   
        }

        I_Type_rs1: coverpoint rs1 {
            bins rs1[] = {[0:31]};
	
		
        }

        I_Type_rs2: coverpoint item.instr_rdata_i[31:20] {
            bins imm_zero  = {12'b0000_0000_0000};
            bins all_ones  = {12'b1111_1111_1111};
            bins min  = {12'b1000_0000_0000};
            bins max  = {12'b0111_1111_1111};
            bins rest = default;
        }

        I_Type_rd: coverpoint rd {
            bins rd[] = {[1:31]};
	    ignore_bins zeros[] = {0}; 
        }
        
      
    endgroup: I_instr_cover

    //<<-------------------------------------------------------------------------
    ///// bins to cover all posibilities of Load_Type points

    covergroup L_instr_cover ; 
        L_Type_instr: coverpoint item.instr_rdata_i[14:12] {
            bins LB  = {3'b000};
            bins LH  = {3'b001};
            bins LW  = {3'b010};
            bins LBU = {3'b100}; 
            bins LHU = {3'b101};                      
        }
    
        L_Type_rs1: coverpoint rs1 {
            bins rs1[] = {[0:31]};
        }
        
        L_Type_rs2: coverpoint  item.instr_rdata_i[31:20] {
            bins imm_zero  = {12'b000000000000};
            bins all_ones  = {12'b111111111111};   
        }
        
        L_Type_rd: coverpoint rd  {
            bins rd[] = {[1:31]};
	    ignore_bins zeros[] = {0};
        }
    endgroup: L_instr_cover

    //<<-----------------------------------------------------------------------------
    ///// bins to cover all posibilities S_Type points

    covergroup S_instr_cover ; 
        S_Type_instr: coverpoint item.instr_rdata_i[14:12] {
            bins SB  = {3'b000};
            bins SH  = {3'b001};
            bins SW  = {3'b010};                        
        }

        S_Type_rs1: coverpoint rs1{
            bins rs1[] = {[0:31]};
        }

        S_Type_rs2: coverpoint rs2 {
            bins rs2[] = {[0:31]};
        }

        
    endgroup: S_instr_cover

    //<<---------------------------------------------------------
    //// bins to cover all posibilities B_Type points

    covergroup B_instr_cover ; 
        B_Type_instr: coverpoint item.instr_rdata_i[14:12]{
            bins BEQ  = {3'b000};
            bins BNE  = {3'b001};
            bins BLT  = {3'b100};
            bins BGE  = {3'b101}; 
            bins BLTU = {3'b110};
            bins BGEU = {3'b111};                       
        }

        B_Type_rs1: coverpoint rs1 {
            bins rs1[] = {[0:31]};
        }

        B_Type_rs2: coverpoint rs2{
            bins rs2[] = {[0:31]};  
        }

        B_Type_imm: coverpoint rd {
            bins rd[] = {[0:31]};  
        }

         
    endgroup: B_instr_cover

    //<<--------------------------------------------------------------------------

    covergroup J_jal_instr_cover ; 
	option.cross_auto_bin_max = 0;
        J_JAL_Type_instr: coverpoint item.instr_rdata_i[14:12]{
            bins JAL  = {[0:7]};
        }

        J_JAL_Type_rs2: coverpoint rd {
            bins rd = {[1:31]};
	    ignore_bins zeros[] = {0};
        }

        J_JAL_Type_rd: coverpoint item.instr_rdata_i[31:12] {
            bins j_imm_zero  = {20'b0000_0000_0000_0000_0000};
            bins j_all_ones  = {20'b1111_1111_1111_1111_1111};
            bins j_min  = {20'b1000_0000_0000_0000_0000};
            bins j_max  = {20'b0111_1111_1111_1111_1111};
            bins j_rest = default;
        }   
    endgroup: J_jal_instr_cover

    //<<-----------------------------------------------------
    //// bins to cover all posibilities J_Type points

    covergroup J_jalr_instr_cover ; 
        J_JALR_Type_instr: coverpoint  item.instr_rdata_i[14:12]  {
            bins JALR  = {3'b000};
        }

        J_JALR_Type_rs1: coverpoint rs1 {
            bins rs1 = {[0:31]};
        }

        J_JALR_Type_rs2: coverpoint  item.instr_rdata_i[31:20] {
            bins imm_zero  = {12'b000000000000};
            bins all_ones  = {12'b111111111111};   
        }

        J_JALR_Type_rd: coverpoint rd {
            bins rd = {[1:31]};
	    ignore_bins zeros[] = {0};
        }
    endgroup: J_jalr_instr_cover

    //<<-----------------------------------------------------

    covergroup U_lui_instr_cover ; 
        U_lui_Type_instr: coverpoint item.instr_rdata_i[14:12] {
            bins LUI = {[0:7]};           
        }

        U_lui_Type_rs1: coverpoint rd {
            bins rd[] = {[1:31]};
	    ignore_bins zeros[] = {0};
        }

        U_lui_Type_rs2: coverpoint item.instr_rdata_i[31:12] {
            bins U_imm_zero  = {20'b0000_0000_0000_0000_0000};
            bins U_all_ones  = {20'b1111_1111_1111_1111_1111};
            bins U_min  = {20'b1000_0000_0000_0000_0000};
            bins U_max  = {20'b0111_1111_1111_1111_1111};
            bins U_rest = default;
        }
    endgroup: U_lui_instr_cover

    covergroup U_auipc_instr_cover ; 
        U_auipc_Type_instr: coverpoint item.instr_rdata_i[14:12] {
            bins LUIPC = {[0:7]};           
        }

        U_auipc_Type_rs1: coverpoint  rd {
            bins rd[] = {[1:31]};
	    ignore_bins zeros[] = {0};
        }

       U_auipc_Type_rs2: coverpoint item.instr_rdata_i[31:12]{
            bins u_imm_zero  = {20'b0000_0000_0000_0000_0000};
            bins u_all_ones  = {20'b1111_1111_1111_1111_1111};
            bins u_min  = {20'b1000_0000_0000_0000_0000};
            bins u_max  = {20'b0111_1111_1111_1111_1111};
            bins u_rest = default;
        }
    endgroup: U_auipc_instr_cover
    
    //<<-----------------------------------------------------------------

    covergroup MUL_instr_cover ; 
        MUL_Type_instr: coverpoint item.instr_rdata_i[14:12] {
            bins MUL   = {3'b000};
            bins MULH  = {3'b001};
            bins MULSU = {3'b010};
            bins MULU  = {3'b011};
            bins DIV   = {3'b100}; 
            bins DIVU  = {3'b101};
            bins REM   = {3'b110};
            bins REMU  = {3'b111};                        
        }

        MUL_Type_rs1: coverpoint rs1 {
            bins rs1[] = {[0:31]};
        }

        MUL_Type_rs2: coverpoint rs2 {
            bins rs2[] = {[0:31]};
        }

        MUL_Type_rd: coverpoint rd {
            bins rd[] = {[1:31]};
	    ignore_bins zeros[] = {0};
        }

        
    endgroup: MUL_instr_cover

    //<<---------------------------------------------------------------- 
    ////////////////////////////////////////////////////////////////////////////////
    //<<------- Data_Memory Covergroup -------------------------------

    covergroup Data_Memory_cover;
        CP_we: coverpoint data_item.data_we_o {
            bins load = {0};
            bins store = {1};
        }

        CP_byte_en: coverpoint data_item.data_be_o {
            bins lb_0 = {4'b0001};          // Load byte  
            bins lb_1 = {4'b0010};          // Byte 1
            bins lb_2 = {4'b0100};          // Byte 2
            bins lb_3 = {4'b1000};          // Byte 3
            bins lh_01 = {4'b0011};         // Load halfword 
            bins lh_23 = {4'b1100};         // Load halfword 
            bins lw    = {4'b1111};         // Full word
        }

        // Coverpoint: Address Allign
        CP_addr_allign: coverpoint data_item.data_addr_o[1:0] {
            bins byte0 = {2'b00};
            bins byte1 = {2'b01};
            bins byte2 = {2'b10};
            bins byte3 = {2'b11};
        }

        // Coverpoint for data_rdata_i
        cp_rdata: coverpoint data_item.data_rdata_i iff (!data_item.data_we_o) {
            bins zero_rdata = {32'h00000000};
            
            bins byte_low   = {[0:255]};        // load byte
            bins hw_low     = {[0:65535]};      // load halfword
            bins others     = default;
        }

        // Coverpoint: Write Data
          CP_wdata : coverpoint data_item.data_wdata_o iff (data_item.data_we_o) {
            bins zero       = {32'h00000000};
           
            bins byte_only  = {[8'h00:8'hFF]};
            bins upper_only = {[32'hFF000000:32'hFFFFFFFF]};
            bins others     = default;
        }
    endgroup

    seq_item item;
    
    ////<<=============================================================================================
    function new(string name, uvm_component parent);
        super.new(name, parent);
        R_instr_cover        = new();
        I_instr_cover        = new();
        L_instr_cover        = new();
        S_instr_cover        = new();
        B_instr_cover        = new();
        J_jal_instr_cover    = new();
        U_lui_instr_cover    = new();
        U_auipc_instr_cover  = new();
        MUL_instr_cover      = new();
        J_jalr_instr_cover   = new();
        Data_Memory_cover    = new();
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        inst_port = new("inst_port", this);
        data_port = new("data_port", this);
        
        data_item = data_seq_item::type_id::create("data_item");
        item = seq_item::type_id::create("item");
    endfunction

    virtual function void write_inst(seq_item inst_item);
        item = inst_item;
        if (item.instr_rdata_i[6:0] == 7'b0110011 && 
           (item.instr_rdata_i[31:25] == 7'h00 || item.instr_rdata_i[31:25] == 7'h20)) begin
            rs1 = item.instr_rdata_i[19:15];
            rs2 = item.instr_rdata_i[24:20];
            rd = item.instr_rdata_i[11:7];
            R_instr_cover.sample(); 
        end
        //<<----------------------------------------------
        else if (item.instr_rdata_i[6:0] == 7'b0010011) begin
            rs1 = item.instr_rdata_i[19:15];
            rd = item.instr_rdata_i[11:7];
            I_instr_cover.sample();
        end
        //<<--------------------------------------------------
        else if (item.instr_rdata_i[6:0] == 7'b0000011) begin
            rs1 = item.instr_rdata_i[19:15];
            rd = item.instr_rdata_i[11:7];
            L_instr_cover.sample();
        end
        //<<----------------------------------------------------
        else if (item.instr_rdata_i[6:0] == 7'b0100011) begin
            rs1 = item.instr_rdata_i[19:15];
            rs2 = item.instr_rdata_i[24:20];
            S_instr_cover.sample();
        end
        //<<----------------------------------------------------------
        else if (item.instr_rdata_i[6:0] == 7'b1100011) begin
            rs1 = item.instr_rdata_i[19:15];
            rs2 = item.instr_rdata_i[24:20];
            rd = item.instr_rdata_i[11:7];
            B_instr_cover.sample();
        end
        //<<---------------------------------------------------------
        else if (item.instr_rdata_i[6:0] == 7'b1101111) begin
            rd = item.instr_rdata_i[11:7];
			
            J_jal_instr_cover.sample();
        end
        //<<------------------------------------------------------------
        else if (item.instr_rdata_i[6:0] == 7'b1100111) begin
            rs1 = item.instr_rdata_i[19:15];
            rd = item.instr_rdata_i[11:7];
			
            J_jalr_instr_cover.sample();
        end
        //<<----------------------------------------------------------------
        else if (item.instr_rdata_i[6:0] == 7'b0110111) begin
            rd = item.instr_rdata_i[11:7];
			
            U_lui_instr_cover.sample();
        end
        //<<-------------------------------------------------------------------
        else if (item.instr_rdata_i[6:0] == 7'b0010111) begin
            rd = item.instr_rdata_i[11:7];
			
            U_auipc_instr_cover.sample();
        end
        //<<--------------------------------------------------------------------
        else if (item.instr_rdata_i[6:0] == 7'b0110011 && 
                 item.instr_rdata_i[31:25] == 7'h01) begin
            rs1 = item.instr_rdata_i[19:15];
            rs2 = item.instr_rdata_i[24:20];
            rd = item.instr_rdata_i[11:7];
            MUL_instr_cover.sample();
        end
    endfunction

    virtual function void write_data(data_seq_item data_port);
        data_item = data_port;
        Data_Memory_cover.sample();
    endfunction
	
	
	

    function void report_phase(uvm_phase phase);
        `uvm_info("Coverage_Collector", $sformatf("R_instr_cover      ports covered now is %.2f%%",  R_instr_cover      .get_coverage()),UVM_NONE); 
        `uvm_info("Coverage_Collector", $sformatf("I_instr_cover      ports covered now is %.2f%%",  I_instr_cover      .get_coverage()),UVM_NONE);   
        `uvm_info("Coverage_Collector", $sformatf("L_instr_cover       Ports covered now is %.2f%%", L_instr_cover      .get_coverage()),UVM_NONE) ;    
        `uvm_info("Coverage_Collector", $sformatf("S_instr_cover       Ports covered now is %.2f%%", S_instr_cover      .get_coverage()),UVM_NONE) ;    
        `uvm_info("Coverage_Collector", $sformatf("B_instr_cover       Ports covered now is %.2f%%", B_instr_cover      .get_coverage()),UVM_NONE) ;    
        `uvm_info("Coverage_Collector", $sformatf("J_jal_instr_cover   Ports covered now is %.2f%%", J_jal_instr_cover  .get_coverage()),UVM_NONE) ;    
        `uvm_info("Coverage_Collector", $sformatf("U_lui_instr_cover   Ports covered now is %.2f%%", U_lui_instr_cover  .get_coverage()),UVM_NONE) ;    
        `uvm_info("Coverage_Collector", $sformatf("U_auipc_instr_cover Ports covered now is %.2f%%", U_auipc_instr_cover.get_coverage()),UVM_NONE) ;    
        `uvm_info("Coverage_Collector", $sformatf("MUL_instr_cover     Ports covered now is %.2f%%", MUL_instr_cover    .get_coverage()),UVM_NONE) ;    
        `uvm_info("Coverage_Collector", $sformatf("J_jalr_instr_cover  Ports covered now is %.2f%%", J_jalr_instr_cover .get_coverage()),UVM_NONE) ;    
        `uvm_info("Coverage_Collector", $sformatf("Data_Memory_cover   Ports covered now is %.2f%%", Data_Memory_cover  .get_coverage()),UVM_NONE) ;    
    endfunction
endclass
