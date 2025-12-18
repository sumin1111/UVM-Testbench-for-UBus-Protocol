class ubus_master_write_word_seq extends uvm_sequence #(packet);

	
	`uvm_object_utils(ubus_master_write_word_seq)
	//`uvm_declare_p_sequencer (master_sequencer)

	//slave_sequencer slave_seq;	
	int n_repeat;
	
	function new(string name = "ubus_master_write_word_seq");
		super.new(name);
		if (!$value$plusargs("N_REPEAT=%d", n_repeat))
		n_repeat=4;
		set_automatic_phase_objection(1);
	endfunction

	
	virtual task pre_body(); // body 태스크 실행 직전에 호출
        // 현재 시퀀스가 시작된 phase를 가져와 objection을 올립니다.
        	/*if (!uvm_config_db#(slave_sequencer)::get(this, "", "slave_seq", slave_seq))
        	`uvm_fatal("CONFIG", "Failed to get slave_done_evt")*/
		/*int val;
		if (!$value$plusargs("N_REPEAT=%d", val))
			n_repeat=4;
		else
			n_repeat=val;*/
	

        	/*uvm_phase starting_phase = get_starting_phase();
        	if (starting_phase != null) begin
           	 starting_phase.raise_objection(this);
       	 	end*/
    	endtask
	
	virtual task body();

		//packet req;

		for (int i=0;i<n_repeat;i++) begin

			
		 	`uvm_do_with(req, {req.addr==4*i; req.read==0; req.write==1; req.size==4; req.data.size() ==4;})	
			`uvm_info("MSTR_SEQ", $sformatf("WRITE : addr = 0x%0h , size = %0d, data = %0p" , req.addr, req.size, req.data), UVM_LOW)
			$display("");
		end

		repeat (10) @(posedge m_vif.ubus_clock); 	


	endtask



endclass 
