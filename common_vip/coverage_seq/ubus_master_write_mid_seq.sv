class ubus_master_write_mid_seq extends uvm_sequence #(packet);
	
	`uvm_object_utils(ubus_master_write_mid_seq)
	
	int n_repeat;

	function new(string name = "ubus_master_write_mid_seq");
		super.new(name);
		if (!$value$plusargs("N_REPEAT=%d", n_repeat))
		n_repeat=4;
		set_automatic_phase_objection(1);
	endfunction


	virtual task body();
		packet req;

		for (int i = 0; i < n_repeat; i++) begin

			`uvm_do_with(req, {
				req.addr inside { ['h4000 : 'h7FFF] }; 
				req.write == 1;
			})

			`uvm_info("MID_WR_SEQ", $sformatf("Generated Mid Write Req: 0x%h, Size: %0d", req.addr, req.size), UVM_LOW)
		end
        
	endtask
endclass