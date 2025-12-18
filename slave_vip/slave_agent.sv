class slave_agent extends uvm_agent;
	// UVM Factory //
	`uvm_component_utils(slave_agent)

	// Create Environment //
	slave_sequencer sequencer;
	slave_driver driver;
	slave_monitor monitor;

	// Constructor //
	function new(string name = "slave_agent", uvm_component parent);
		super.new(name,parent);
	endfunction

	// Build Phase //
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sequencer = slave_sequencer::type_id::create("sequencer",this);
		driver = slave_driver::type_id::create("driver",this);
		monitor = slave_monitor::type_id::create("monitor",this);
	endfunction

	// Connect Phase //
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		driver.seq_item_port.connect(sequencer.seq_item_export);
		monitor.request_aport.connect(sequencer.request_fifo.analysis_export);
		//monitor.item_collected_port.connect(sequencer.request_fifo.analysis_export);		
	endfunction

	
	function void write(packet req);
 	 `uvm_info("SLV_SEQx", $sformatf("data=%p ,addr=%h, read=%0b, write=%0b, size=%0d",
             req.data, req.addr, req.read, req.write, req.size), UVM_LOW)
	endfunction


endclass
