class ubus_scoreboard extends uvm_scoreboard;
    `uvm_component_utils_begin(ubus_scoreboard)
    `uvm_field_int(num_writes, UVM_DEFAULT|UVM_DEC)
    `uvm_field_int(num_reads,  UVM_DEFAULT|UVM_DEC)
    `uvm_component_utils_end

    //uvm_analysis_port #(packet) item_collected_export;
    //uvm_analysis_port #(packet) item_collected_export2;

    protected int num_writes = 0;
    protected int num_reads  = 0;
    protected int unsigned m_mem_expected[int unsigned];
    protected int unsigned actual_mem[int unsigned];


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);

	//item_collected_export = new("item_collected_export", this);
    //item_collected_export2 = new("item_collected_export2", this);
    endfunction

   function void write(packet trans);
	//memory_verify(trans);
   endfunction



    virtual function void write_master(packet trans);
        for (int i=0; i<trans.size; i++) begin
            int unsigned addr = trans.addr + i;
            int unsigned data = trans.data[i];
            if (trans.write) begin
                m_mem_expected[addr] = data;
                num_writes++;
                `uvm_info("SCOREBOARD", $sformatf("Master write: addr=0x%0h, data=0x%0h", addr, data), UVM_LOW)
            end

	        if (trans.read) begin
		        `uvm_info("SCOREBOARD", $sformatf("Master read: addr=0x%0h, data=0x%0h", addr, data), UVM_LOW)
	        end
        end
    endfunction

    virtual function void write_slave(packet trans);
        for (int i=0; i<trans.size; i++) begin
            int unsigned addr = trans.addr + i;
            int unsigned data = trans.data[i];
	        if (trans.write) begin

		    `uvm_info("SCOREBOARD", $sformatf("Slave write: addr=0x%0h, data=0x%0h", addr, data), UVM_LOW)

	         end

            if (trans.read) begin
                num_reads++;
                if (m_mem_expected.exists(addr)) begin
                    assert(m_mem_expected[addr] == data) else
                        `uvm_error("SCOREBOARD",$sformatf("Data mismatch at addr=0x%0h, expected=0x%0h, got=0x%0h", addr, m_mem_expected[addr], data));
                end else begin
                    m_mem_expected[addr] = data;
                end
                `uvm_info("SCOREBOARD", $sformatf("Slave read: addr=0x%0h, data=0x%0h", addr, data), UVM_LOW)
            end
        end

    endfunction

    virtual function void report_phase(uvm_phase phase);
        `uvm_info("SCOREBOARD", $sformatf("Final Report: %0d writes, %0d reads", num_writes, num_reads), UVM_LOW)
    endfunction
endclass
