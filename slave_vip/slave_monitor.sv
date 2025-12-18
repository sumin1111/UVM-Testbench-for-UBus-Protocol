class slave_monitor extends uvm_monitor;

	`uvm_component_utils(slave_monitor)

	virtual ubus_s_if vif; // database에서 값을 받아와 저장할 변수
	packet req;
	
	uvm_analysis_port #(packet) request_aport; //	monitor 안에 내장된 포트
	uvm_analysis_port #(packet) item_collected_port;

	typedef enum {IDLE, ADDR_PHASE, DATA_PHASE, COMPLETE} monitor_state_e;
	monitor_state_e current_state = IDLE;
	int data_beat_count = 0;
	int wait_count = 0;

	function new(string name = "slave_monitor", uvm_component parent = null);
		super.new(name, parent);
		request_aport = new("request_aport", this);
		item_collected_port = new("item_collected_port", this); 

	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db#(virtual ubus_s_if)::get(this,"uvm_test_top.env.s_agent*","vif",vif)) begin
			`uvm_fatal("NOVIF", "No virtual interface specified for this monitor instance");
		end
	endfunction

	task run_phase(uvm_phase phase);
		forever begin
		@(posedge vif.ubus_clock);
			if (vif.ubus_read || vif.ubus_write) begin

				req = packet::type_id::create("req");
				req.addr = vif.ubus_addr;
				
				case (vif.ubus_size)
					2'b00: req.size =1;
					2'b01: req.size =2;
					2'b10: req.size=4;
					2'b11: req.size =8;
				endcase
				req.read = vif.ubus_read;
				req.write = vif.ubus_write;
				req.data = new[req.size];
				



				//request_aport.write(req);

				if (req.read) begin
					collect_delayed_read_data(req);
				end else if (req.write) begin
					collect_write_data_immediately(req);
				end
				//item_collected_port.write(req);
				
			end					
		end
	endtask     
			
	task collect_delayed_read_data(packet req);
    // 여러 클록 동안 데이터를 기다릴 수 있음
		wait_count = 0;
		data_beat_count = 0;

		request_aport.write(req);

		while (vif.ubus_wait == 1) begin
			@(posedge vif.ubus_clock);
			wait_count++;
    	end

		wait(vif.ubus_wait==0);
		
			req.wait_state = wait_count; 
			for(int i =0; i<req.size; i++) begin
				@(posedge vif.ubus_clock);
				req.data[i] = vif.ubus_data;
				data_beat_count ++;
			end
		
		`uvm_info("SLV_MON", $sformatf("data_beat_count=%0h, data=%0p, addr=0x%0h, read=%0b, write=%0b, size=%0d, wait_state=%0d", data_beat_count, req.data, req.addr, req.read, req.write, req.size,req.wait_state),UVM_LOW)


		item_collected_port.write(req);
		

	endtask 





	task collect_write_data_immediately(packet req);
		wait_count = 0;
		request_aport.write(req);

		while (vif.ubus_wait == 1) begin
        	@(posedge vif.ubus_clock);
        	wait_count++;
    	end

		wait(vif.ubus_wait==0);
			req.wait_state = wait_count; 

    		for (int i = 0; i < req.size; i++) begin
				@(posedge vif.ubus_clock);
        		req.data[i] = vif.ubus_data;
		    end

		`uvm_info("SLV_MON", $sformatf("data=%0p, addr=%h, read=%0b, write=%0b, size=%0d", req.data, req.addr, req.read, req.write, req.size),UVM_LOW)
		
		item_collected_port.write(req);




	



		
    		
	endtask	




            		// 🚨 버스에서 포착한 신호를 로그로 출력 🚨
            		//`uvm_info("MONITOR", $sformatf("BUS ACTIVITY DETECTED: ADDR=%0h, WRITE=%0b, READ=%0b, DATA=%0h, size=%0d", vif.ubus_addr, vif.ubus_write, vif.ubus_read, vif.ubus_data, vif.ubus_size), UVM_MEDIUM)
            	
            
        		
endclass 

