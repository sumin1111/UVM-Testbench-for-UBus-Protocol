class ubus_read_test extends uvm_test;

	`uvm_component_utils(ubus_read_test)
	
	my3_vip_environment env;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = my3_vip_environment::type_id::create("env",this);
		uvm_config_db#(uvm_object_wrapper)::set(this,"env.m_agent.sequencer.run_phase","default_sequence", ubus_master_read_word_seq::type_id::get()); //Factory가 관리하는 클래스 타입에 대한 정보(메타데이터)를 제공하는 핸들

		uvm_config_db#(uvm_object_wrapper)::set(this,"env.s_agent.sequencer.run_phase","default_sequence", slave_sequence::type_id::get());
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			#1000ns;
		phase.drop_objection(this);
	endtask

endclass
