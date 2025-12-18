class ubus_master_write_high_seq extends uvm_sequence #(packet);
	
	`uvm_object_utils(ubus_master_write_high_seq)
	
	int n_repeat;

	function new(string name = "ubus_master_write_high_seq");
		super.new(name);
		if (!$value$plusargs("N_REPEAT=%d", n_repeat))
		n_repeat=4;
		set_automatic_phase_objection(1);
	endfunction

	virtual task body();
		packet req;

 		for (int i = 0; i < n_repeat; i++) begin

			`uvm_do_with(req, {	req.addr inside { ['h8000 : 'hFFFF] }; 
				req.write == 1;})     

		/* for (int i = 0; i < n_repeat; i++) begin
			req = packet::type_id::create("req");
			start_item(req);

			// 🚨 [핵심 설정] 주소 범위: HIGH (2), 방향: WRITE (1)
			req.addr_range_sel = 2; // High Range
			req.dir_sel = 1;        // Write Direction

			if (!req.randomize() with {req.size inside {1,2,4,8};}) begin
				`uvm_fatal(get_full_name(), "Failed to randomize High Write packet")
			end

			`uvm_info("HIGH_WR_SEQ", $sformatf("Generated High Write Req: 0x%h, Size: %0d", req.addr, req.size), UVM_LOW)
			finish_item(req); 
		end */

        end

	endtask
endclass