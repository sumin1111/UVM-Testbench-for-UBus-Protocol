class ubus_master_read_high_seq extends uvm_sequence #(packet);
	
	`uvm_object_utils(ubus_master_read_high_seq)
	
	int n_repeat;

	function new(string name = "ubus_master_read_high_seq");
		super.new(name);
		if (!$value$plusargs("N_REPEAT=%d", n_repeat))
		n_repeat=4;
		set_automatic_phase_objection(1);
	endfunction

	virtual task body();
		packet req;
        packet rsp;

		for (int i = 0; i < n_repeat; i++) begin
			req = packet::type_id::create("req");
			start_item(req);



			if (!req.randomize() with {req.read==1; req.size inside {1,2,4,8}; req.addr inside {[40960:$]};}) begin
				`uvm_fatal(get_full_name(), "Failed to randomize High Read packet")
			end

			`uvm_info("HIGH_RD_SEQ", $sformatf("Generated High Read Req: 0x%h, Size: %0d", req.addr, req.size), UVM_LOW)
			finish_item(req);
            
            get_response(rsp);
		end
	endtask



endclass