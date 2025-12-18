class my3_vip_environment extends uvm_env;
	// UVM Factory //
	`uvm_component_utils(my3_vip_environment)

		
	master_agent m_agent;
	slave_agent s_agent;
	ubus_virtual_sequencer virtual_sequencer;
	master_analysis_imp master_imp;
	slave_analysis_imp slave_imp;
	ubus_coverage coverage;


	// Create System //
	//my3_vip_environment env;
	

	ubus_scoreboard scoreboard;	

	// Constructor //
	function new(string name , uvm_component parent) ;
		super.new(name, parent);
	endfunction

	// Build Phase //
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);


		m_agent	= master_agent::type_id::create("m_agent",this);
		s_agent	= slave_agent::type_id::create("s_agent",this);
		scoreboard =new("scoreboard" , this);
		master_imp = new("master_imp", scoreboard);
		slave_imp = new("slave_imp", scoreboard);
		virtual_sequencer= ubus_virtual_sequencer::type_id::create("virtual_sequencer",this);
		coverage = ubus_coverage::type_id::create("coverage",this);

		
	endfunction

	// Scoreboard Connection //
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		m_agent.monitor.item_collected_port.connect(master_imp);
		m_agent.monitor.item_collected_port.connect(coverage.analysis_export);
	    s_agent.monitor.item_collected_port.connect(slave_imp);	
		//s_agent.monitor.item_collected_port.connect(coverage.analysis_export);
		virtual_sequencer.m_sequencer=m_agent.sequencer;
		virtual_sequencer.s_sequencer=s_agent.sequencer;


		//uvm_config_db#(ubus_coverage)::set(null, "*", "coverage", coverage);
		if (coverage != null) begin
			uvm_config_db#(ubus_coverage)::set(
				.cntxt(null), 
				.inst_name("*"), 
				.field_name("coverage"), 
				.value(coverage)
			);
			`uvm_info(get_name(), "UBUS coverage handle successfully set in config_db.", UVM_LOW)
		end

	endfunction
	
	// Topology //
	function void start_of_simulation_phase(uvm_phase phase);
		uvm_root::get().print_topology();
	endfunction	
endclass
		
