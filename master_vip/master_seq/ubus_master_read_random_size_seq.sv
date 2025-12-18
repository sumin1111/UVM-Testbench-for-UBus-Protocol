class ubus_master_read_random_size_seq extends uvm_sequence #(packet);
	`uvm_object_utils(ubus_master_read_random_size_seq)
	//`uvm_declare_p_sequencer(ubus_master_sequencer)
	int n_repeat;


	function new(string name = "ubus_master_read_word_seq");
		super.new(name);
		if (!$value$plusargs("N_REPEAT=%d", n_repeat))
		n_repeat=4;
		set_automatic_phase_objection(1);
	endfunction
	


	virtual task body();
	packet req, rsp;
	for(int i =0; i<n_repeat; i++) begin
	req = packet::type_id::create("req");

	req.randomize();
	req.write = 0;
	req.read = 1;
	req.data = new[req.size];
	

	start_item(req);

	`uvm_info("MSTR_SEQ", $sformatf("READ : addr = 0x%0h , read = 0x%0h, write = 0x%0h , size = %0d" , req.addr, req.read, req.write ,req.size), UVM_LOW)

	finish_item(req);

	get_response(rsp);
	

	repeat(2+req.size) @(posedge s_vif.ubus_clock);
	$display("");
	end

	endtask

	virtual task post_body(); // body 태스크 실행 직후에 호출
        // body가 완료되면 objection을 내려 시뮬레이션이 종료될 수 있도록 합니다.
        	uvm_phase starting_phase = get_starting_phase();
       		if (starting_phase != null) begin
            		starting_phase.drop_objection(this);
        	end
    	endtask

	

endclass 
