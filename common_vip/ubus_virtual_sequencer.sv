class ubus_virtual_sequencer extends uvm_sequencer;

	`uvm_component_utils(ubus_virtual_sequencer)

	master_sequencer m_sequencer;
	slave_sequencer s_sequencer;
	ubus_coverage coverage_handle;
	
	function new(string name = "ubus_virtual_sequencer" , uvm_component parent);
		super.new(name,parent);
		m_sequencer = master_sequencer::type_id::create("m_sequencer", this);
    	s_sequencer = slave_sequencer::type_id::create("s_sequencer", this);
		coverage_handle = ubus_coverage::type_id::create("coverage_handle", this);
	endfunction




endclass
