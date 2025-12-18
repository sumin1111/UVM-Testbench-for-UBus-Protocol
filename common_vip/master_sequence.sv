class master_sequence extends uvm_sequence #(packet);
	`uvm_object_utils(master_sequence)

	function new(string name = "master_sequence");
		super.new(name);
	endfunction


	task body(); //sequence는 body에 run_phase 코드를 작성
		packet tr;
		repeat (1) begin
			tr = packet::type_id::create("tr");
			assert(tr.randomize());
			start_item(tr);  // ready to transfer
			`uvm_info("SEQ", $sformatf("Randomized tr: %s", tr.sprint()), UVM_LOW)
			finish_item(tr);
                        //`uvm_info("SEQ", $sformatf("Randomized tr: %s", tr.sprint()), UVM_LOW)	
		end
		//`uvm_info("SEQ", $sformatf("Randomized tr: %s", tr.sprint()), UVM_LOW)
	endtask	

endclass 
