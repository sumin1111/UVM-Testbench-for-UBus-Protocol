class master_sequence extends uvm_sequence #(packet);
	// UVM Factory //
	`uvm_object_utils(master_sequence)

	// Constructor //
	function new(string name = "master_sequence");
		super.new(name);
	endfunction

	// Simulation Execution //
	task body(); // sequence는 body에 run_phase 코드를 작성
		packet tr;
		repeat (10) begin
			tr = packet::type_id::create("tr");
			assert(tr.randomize());
			start_item(tr);  // ready to transfer
			finish_item(tr);
		end
		`uvm_info("SEQ", $sformatf("Randomized tr: %s", tr.sprint()), UVM_LOW)
	endtask	

endclass 
