class ubus_master_write_low_seq extends uvm_sequence #(packet);
	
	`uvm_object_utils(ubus_master_write_low_seq)
	
	int n_repeat;

	function new(string name = "ubus_master_write_low_seq");
		super.new(name);
		if (!$value$plusargs("N_REPEAT=%d", n_repeat))
		n_repeat=4;
		set_automatic_phase_objection(1);
	endfunction

	virtual task body();
		// 'uvm_do_with' 매크로는 item의 생성, start_item, randomize, finish_item을 처리합니다.
		packet req;

		for (int i = 0; i < n_repeat; i++) begin
			// 🚨 [수정] uvm_do_with 매크로를 사용하여 트랜잭션 흐름을 간소화했습니다.
            // 모든 제약 조건(주소 범위, 방향, 사이즈)을 'with' 블록에 명시합니다.
			`uvm_do_with(req, {
				req.addr inside { ['h0000 : 'h3FFF] }; 
				req.write == 1;
			})

			// uvm_do_with가 완료된 후 req가 유효합니다.
			`uvm_info("LOW_WR_SEQ", $sformatf("Generated Low Write Req: 0x%h, Size: %0d", req.addr, req.size), UVM_LOW)
		end
	endtask
endclass