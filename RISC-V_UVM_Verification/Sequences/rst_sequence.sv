class rst_sequence extends uvm_sequence#(config_seq_item);
    `uvm_object_utils(rst_sequence)    

    function new(string name = "rst_sequence");
        super.new(name);
    endfunction
    
    config_seq_item sequ_item;

    //////////////////build_phase
    task pre_body;
        // init_mem();
        sequ_item = config_seq_item::type_id::create("sequ_item");
    endtask : pre_body

    task body;
        repeat(2) begin
            start_item(sequ_item);

            assert(sequ_item.randomize() with { rst == 1'b0; });

            finish_item(sequ_item);
        end
    endtask : body
endclass : rst_sequence
