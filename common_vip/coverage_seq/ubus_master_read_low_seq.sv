class ubus_master_read_low_seq extends uvm_sequence #(packet);
	
	`uvm_object_utils(ubus_master_read_low_seq)
	
	int n_repeat;

	function new(string name = "ubus_master_read_low_seq");
		super.new(name);
		if (!$value$plusargs("N_REPEAT=%d", n_repeat))
		n_repeat=4;
		set_automatic_phase_objection(1);
	endfunction

	virtual task body();
		packet req;
        packet rsp; // Read 응답을 받기 위한 변수

		for (int i = 0; i < n_repeat; i++) begin
			req = packet::type_id::create("req");
			start_item(req);

	


			if (!req.randomize() with { req.addr inside {['h0000 : 'h3FFF]}; req.read==1;}) begin
				`uvm_fatal(get_full_name(), "Failed to randomize Low Read packet")
			end

            
 


			`uvm_info("LOW_RD_SEQ", $sformatf("Generated Low Read Req: 0x%h, Size: %0d", req.addr, req.size), UVM_LOW)
			finish_item(req);
            
            // 응답을 받습니다.
            get_response(rsp);
		end
	endtask
endclass