class slave_sequencer extends uvm_sequencer #(packet);
	// UVM Factory //
	`uvm_component_utils(slave_sequencer)

	// TLM Analysis FIFO Declaration //
	uvm_tlm_analysis_fifo #(packet) request_fifo; // UVM transaction queue class	
	
	// Constructor //
	function new(string name = "slave_sequencer" , uvm_component parent = null);
		super.new(name,parent);
	endfunction

	// Build Phase //
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		request_fifo = new("request_fifo", this);
	endfunction
endclass
