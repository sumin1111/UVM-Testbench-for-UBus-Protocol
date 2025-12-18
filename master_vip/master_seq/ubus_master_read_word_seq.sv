class ubus_master_read_word_seq extends uvm_sequence #(packet);
	`uvm_object_utils(ubus_master_read_word_seq)
	int n_repeat;

	function new(string name = "ubus_master_read_word_seq");
		super.new(name);
		if (!$value$plusargs("N_REPEAT=%d", n_repeat))
		n_repeat=4;
		set_automatic_phase_objection(1);
	endfunction
	
	virtual task pre_body(); // body 태스크 실행 직전에 호출
        // 현재 시퀀스가 시작된 phase를 가져와 objection을 올립니다.
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
	packet req, rsp;
	for(int i =0; i<n_repeat; i++) begin
	req = packet::type_id::create("req");
	rsp = packet::type_id::create("rsp");


	req.addr='0+4*i;
	
	req.size=4;
	req.write = 0;
	req.read = 1;
	req.data = new[4];
	req.error =0 ;

	start_item(req);

	`uvm_info("MSTR_SEQ", $sformatf("READ : addr = 0x%0h , read = 0x%0h, write = 0x%0h , size = %0d" , req.addr, req.read, req.write ,req.size), UVM_LOW)

	finish_item(req);

	get_response(rsp);
	

	repeat(2+req.size) @(posedge s_vif.ubus_clock);
	$display("");
	end

	endtask

	/*virtual task post_body(); // body 태스크 실행 직후에 호출
        // body가 완료되면 objection을 내려 시뮬레이션이 종료될 수 있도록 합니다.
        	uvm_phase starting_phase = get_starting_phase();
       		if (starting_phase != null) begin
            		starting_phase.drop_objection(this);
        	end
    	endtask*/

	

endclass 
