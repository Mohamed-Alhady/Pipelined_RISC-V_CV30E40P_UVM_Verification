class configure_sequence extends uvm_sequence#(config_seq_item);
  `uvm_object_utils(configure_sequence)

  function new(string name = "configure_sequence");
    super.new(name);
  endfunction

  config_seq_item sequ_item;

  // Pre-body task
  task pre_body;
    // init_mem();
    sequ_item = config_seq_item::type_id::create("sequ_item");
  endtask : pre_body

  // Body task
  task body;
    start_item(sequ_item);
    
    assert(sequ_item.randomize());

    finish_item(sequ_item);
  endtask : body
endclass : configure_sequence
