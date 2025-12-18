class ubus_master_read_mid_seq extends uvm_sequence #(packet);
	
	`uvm_object_utils(ubus_master_read_mid_seq)
	
	int n_repeat;

	function new(string name = "ubus_master_read_mid_seq");
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



			if (!req.randomize() with {req.read==1; req.size inside {1,2,4,8}; req.addr inside {['h4000 : 'h7FFF]};}) begin
				`uvm_fatal(get_full_name(), "Failed to randomize Mid Read packet")
			end

			`uvm_info("MID_RD_SEQ", $sformatf("Generated Mid Read Req: 0x%h, Size: %0d", req.addr, req.size), UVM_LOW)
			finish_item(req);
            
            get_response(rsp);
		end
	endtask
endclass