class ubus_virtual_sequence extends uvm_sequence;
	`uvm_object_utils(ubus_virtual_sequence)
	`uvm_declare_p_sequencer(ubus_virtual_sequencer)



	ubus_master_write_random_size_seq m_write_random_size_seq; 
	ubus_master_read_random_size_seq m_read_random_size_seq;
	ubus_master_write_low_seq write_low_seq;
	ubus_master_read_low_seq read_low_seq;
	ubus_master_write_mid_seq write_mid_seq;
	ubus_master_read_mid_seq read_mid_seq;
	ubus_master_write_high_seq write_high_seq;
	ubus_master_read_high_seq read_high_seq;

	ubus_target_addr_dir_seq target_addr_dir_seq;
	ubus_target_addr_dir_seqf target_addr_dir_seqf;
	ubus_target_addr_dir_seq_2 target_addr_dir_seq_1;
	ubus_target_addr_dir_seq_2 target_addr_dir_seq_2;
	ubus_target_addr_dir_seq_3 target_addr_dir_seq_3;
	ubus_target_addr_dir_seq_4 target_addr_dir_seq_4;
	ubus_target_addr_dir_seq_5 target_addr_dir_seq_5;
	ubus_target_addr_dir_seq_6 target_addr_dir_seq_6;

	
	function new(string name = "ubus_virtual_sequence");
		super.new(name);

		set_automatic_phase_objection(1);
	endfunction

	
	virtual task body();

    ubus_coverage cov_h;
    ubus_target_addr_dir_seqf cov_seq;

	if (p_sequencer == null) begin
		`uvm_fatal("NULL_SEQ", "p_sequencer is NULL. Virtual sequencer not connected.")
	end

	if (p_sequencer.m_sequencer == null) begin
		`uvm_fatal("NULL_SEQ", "m_sequencer inside virtual sequencer is NULL.")
	end
	

		/* `uvm_do_on(m_write_random_size_seq, p_sequencer.m_sequencer)
		`uvm_do_on(m_read_random_size_seq, p_sequencer.m_sequencer) */

		

		/* `uvm_do_on(write_low_seq, p_sequencer.m_sequencer)
		`uvm_do_on(read_low_seq, p_sequencer.m_sequencer)
		`uvm_do_on(write_mid_seq, p_sequencer.m_sequencer)
		`uvm_do_on(read_mid_seq, p_sequencer.m_sequencer)
		`uvm_do_on(write_high_seq, p_sequencer.m_sequencer)
		`uvm_do_on(read_high_seq, p_sequencer.m_sequencer) */




        /* `uvm_do_on(target_addr_dir_seq_1, p_sequencer.m_sequencer)
		`uvm_do_on(target_addr_dir_seq_2, p_sequencer.m_sequencer)
		`uvm_do_on(target_addr_dir_seq_3, p_sequencer.m_sequencer)
		`uvm_do_on(target_addr_dir_seq_4, p_sequencer.m_sequencer)
		`uvm_do_on(target_addr_dir_seq_5, p_sequencer.m_sequencer)
		`uvm_do_on(target_addr_dir_seq_6, p_sequencer.m_sequencer) */

		//`uvm_do_on(target_addr_dir_seq, p_sequencer.m_sequencer)
		//`uvm_do_on(target_addr_dir_seqf, p_sequencer.m_sequencer)



    // 2) Coverage-driven 실행: p_sequencer에서 coverage handle을 얻어서
    //    아직 hit 안된 bin만 채우도록 ubus_target_addr_dir_seqf 인스턴스 생성 후 실행

		// coverage handle 가져오기
		if (!$cast(cov_h, p_sequencer.coverage_handle)) begin
			if (!uvm_config_db#(ubus_coverage)::get(null, "", "coverage_handle", cov_h)) begin
				`uvm_warning(get_name(), "No coverage handle available. Running fallback.")
				ubus_target_addr_dir_seqf::type_id::create("fallback_seq").start(p_sequencer.m_sequencer);
				return;
			end
		end

		// 🌟 핵심: 하나의 시퀀스로 누락 bin 처리
		cov_seq = ubus_target_addr_dir_seqf::type_id::create("cov_seq");
		cov_seq.cov = cov_h;
		cov_seq.start(p_sequencer.m_sequencer);



		repeat(3) @(posedge m_vif.ubus_clock);





	endtask 



endclass 
