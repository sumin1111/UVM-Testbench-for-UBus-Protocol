class ubus_virtual_sequence_test extends uvm_test;

	`uvm_component_utils(ubus_virtual_sequence_test)
	
	my3_vip_environment env;
	ubus_virtual_sequence virtual_sequence;
	slave_sequence s_sequence;
	ubus_coverage coverage_handle;


	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = my3_vip_environment::type_id::create("env",this);

		
		uvm_config_db#(uvm_object_wrapper)::set(this,"env.s_agent.sequencer.main_phase","default_sequence", slave_sequence::type_id::get());

		uvm_config_db#(uvm_object_wrapper)::set(this, "env.virtual_sequencer.main_phase", "default_sequence", ubus_virtual_sequence::type_id::get()); //Factory가 관리하는 클래스 타입에 대한 정보(메타데이터)를 제공하는 핸들
		
		//uvm_config_db#(uvm_object_wrapper)::set(this, "env.virtual_sequencer.m_sequencer.main_phase", "default_sequence", ubus_master_write_random_size_seq::type_id::get());
		//uvm_config_db#(uvm_object_wrapper)::set(this, "env.virtual_sequencer.m_sequencer.main_phase", "default_sequence", ubus_master_read_random_size_seq::type_id::get());

		/*uvm_config_db#(uvm_object_wrapper)::set(this, "env.virtual_sequencer.m_sequencer.main_phase", "default_sequence", ubus_master_write_low_seq::type_id::get());
		uvm_config_db#(uvm_object_wrapper)::set(this, "env.virtual_sequencer.m_sequencer.main_phase", "default_sequence", ubus_master_read_low_seq::type_id::get());
		uvm_config_db#(uvm_object_wrapper)::set(this, "env.virtual_sequencer.m_sequencer.main_phase", "default_sequence", ubus_master_write_mid_seq::type_id::get());
		uvm_config_db#(uvm_object_wrapper)::set(this, "env.virtual_sequencer.m_sequencer.main_phase", "default_sequence", ubus_master_read_mid_seq::type_id::get());
		uvm_config_db#(uvm_object_wrapper)::set(this, "env.virtual_sequencer.m_sequencer.main_phase", "default_sequence", ubus_master_write_high_seq::type_id::get());
		uvm_config_db#(uvm_object_wrapper)::set(this, "env.virtual_sequencer.m_sequencer.main_phase", "default_sequence", ubus_master_read_high_seq::type_id::get());*/

 


		uvm_root::get().set_timeout(500000);
	endfunction

	task run_phase(uvm_phase phase);
		// 1. Objection을 올립니다.
		/*phase.raise_objection(this); 
		
		// 2. 가상 시퀀스를 생성합니다.
		virtual_sequence = ubus_virtual_sequence::type_id::create("virtual_sequence");

		// 3. 가상 시퀀스를 가상 시퀀서에서 실행하고, 시퀀스가 완료될 때까지 기다립니다.
		virtual_sequence.start(env.virtual_sequencer); // <--- 🌟 이제 명시적으로 시작됩니다!

		// 4. 시퀀스가 완료된 후, Test가 올렸던 Objection을 내립니다.
		#1000
		phase.drop_objection(this); */
	endtask

endclass
