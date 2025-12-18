class ubus_master_write_random_size_seq extends uvm_sequence #(packet);

	
	`uvm_object_utils(ubus_master_write_random_size_seq)
	int n_repeat;
	
	function new(string name = "ubus_master_write_word_seq");
		super.new(name);
		if (!$value$plusargs("N_REPEAT=%d", n_repeat))
		n_repeat=4;
		set_automatic_phase_objection(1);
	endfunction

	
	virtual task body();
		packet rsp;
		
		for (int i=0;i<n_repeat;i++) begin

			
		 	`uvm_do_with(req, {req.read==0; req.write==1;})	
			`uvm_info("MSTR_SEQ", $sformatf("WRITE : addr = 0x%0h , size = %0d, data = %0p" , req.addr, req.size, req.data), UVM_LOW)

			get_response(rsp);

			$display("");
		end




	endtask



endclass 
