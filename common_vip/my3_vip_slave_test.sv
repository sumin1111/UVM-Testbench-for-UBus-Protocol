class my3_vip_slave_test extends uvm_test;

    `uvm_component_utils(my3_vip_slave_test)

    my3_vip_slave_environment env; // 저장할 변수
    slave_sequence seq;

    function new(string name = "my3_vip_slave_test", uvm_component parent = null);
        super.new(name, parent);
	//`uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
	//`uvm_info("TRACE", $sformatf("%m"), UVM_HIGH);
        env = my3_vip_slave_environment::type_id::create("env", this); //객체가 생성될 때 build_phase 자동 호출
	seq = slave_sequence::type_id::create("seq", this);
    endfunction


    function void start_of_simulation_phase(uvm_phase phase); //시뮬레이션 시작전 UVM이 자동호출
        super.start_of_simulation_phase(phase); //부모 phase class의 기본 동작 수행
	uvm_root::get().print_topology(); // 최상위 객체 아래에 계층적 구조를 tree 형태로 출력
	uvm_factory::get().print(); //사용자 등록 class 출력
	//`uvm_info("TRACE", $sformatf("%m"),UVM_HIGH);
       
	//dynamic array 내부 class에서 설정 - success
        /*if (env != null && env.tr != null) begin
	    //env.tr.wait_state = new[4];
            for(int i=0;i<4; i++) begin 
	    	env.tr.randomize();
            	env.tr.print(); 
					
		`uvm_info("UBUS_TRANS", $sformatf("addr=%0h read=%0b write=%0b size=%0d data=%0h wait=%p error=%0b",
            	env.tr.addr, env.tr.read, env.tr.write,
            	env.tr.size, env.tr.data, env.tr.wait_state, env.tr.error), UVM_HIGH);		
	    end
	end else begin
		`uvm_error("NULL", "env.tr is null! Check build_phase")
	end   	*/
     endfunction

     function void end_of_elaboration_phase(uvm_phase phase); // 시뮬레이션 직전에 환경 연결 및 설정을 마무리하는 단계
	uvm_config_db#(uvm_object_wrapper)::set(this,"env.s_agent.sequencer.run_phase","default_sequence", slave_sequence::type_id::get()); //master와 다르게 반응형이기 자동으로 실행되는 default sequence를 등록/ 별도의 strequest_fifo.get(art 없이도 자동 수행 , uvm_object_wrapper, uvm_config_db는 UVM의 자동화,연결 데이터베이스 

     endfunction

     task run_phase(uvm_phase phase);
	phase.raise_objection(this);
		for (int i =0; i<10; i++) begin
			slave_packet tr = slave_packet::type_id::create($sformatf("tr_%0d",i));
			assert(tr.randomize());
			env.s_agent.sequencer.request_fifo.put(tr); //sequencer가 처리해야 할 transaction을 대기열에 넣는다
		end

		//wait(env.s_agent.sequencer.request_fifo.num_items() == 0 );
		#100
	phase.drop_objection(this);
     endtask

endclass
