class ubus_write_test extends uvm_test;

	`uvm_component_utils(ubus_write_test)
	
	my3_vip_environment env;
	ubus_master_write_word_seq seq_h;
	slave_sequence s_seq;
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = my3_vip_environment::type_id::create("env",this);
		//uvm_config_db#(uvm_active_passive_enum)::set(this, "env.m_agent", "is_active", UVM_PASSIVE);
		uvm_config_db#(uvm_object_wrapper)::set(this, "env.m_agent.sequencer.main_phase", "default_sequence", ubus_master_write_word_seq::type_id::get()); //Factory가 관리하는 클래스 타입에 대한 정보(메타데이터)를 제공하는 핸들
		//uvm_config_db#(uvm_active_passive_enum)::set(this,"env.s_agent","is_active", UVM_ACTIVE );

		uvm_config_db#(uvm_object_wrapper)::set(this,"env.s_agent.sequencer.main_phase","default_sequence", slave_sequence::type_id::get());
	endfunction
//end_of_elaboration_phase
	/*function void start_of_simulation_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction*/

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			//ubus_master_write_word_seq seq_h;
			//seq_h = ubus_master_write_word_seq::type_id::create("seq_h");

			//s_seq = slave_sequence::type_id::create("s_seq");
    			//s_seq.start(env.s_agent.sequencer);
			//seq_h.start(env.m_agent.sequencer);

			#1000ns;
		phase.drop_objection(this);
	endtask

endclass
