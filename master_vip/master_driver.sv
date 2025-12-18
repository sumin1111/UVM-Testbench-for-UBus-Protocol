class master_driver extends uvm_driver #(packet);

	`uvm_component_utils(master_driver)

	virtual ubus_m_if vif;

	int wait_count = 0;
    int max_wait = 1000; // 안전 장치: 무한 루프 방지

	function new(string name = "master_driver", uvm_component parent=null);
		
		super.new(name,parent);
	endfunction


	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual ubus_m_if)::get(this,"uvm_test_top.env.m_agent*","vif", vif)) begin
			`uvm_fatal("NOVIF", "No virtual interface specified for this monitor instance");
		end
	endfunction

	task run_phase(uvm_phase phase);
		packet tr;

		forever begin
			seq_item_port.get_next_item(tr);
			drive_transfer(tr);
			seq_item_port.item_done(tr);
		end
	endtask

	task drive_transfer(packet tr);

		@(posedge vif.ubus_clock);

			wait_count=0;

			vif.ubus_addr <= tr.addr;
			vif.ubus_write <= tr.write;
			vif.ubus_read <= tr.read;
			vif.ubus_size <= (tr.size ==1) ? 2'b00:
					(tr.size ==2) ? 2'b01:
					(tr.size ==4) ? 2'b10:
					(tr.size ==8) ? 2'b11:2'b00;
			vif.ubus_bip <= 0;



			if(tr.write) begin
				@(posedge vif.ubus_clock);				
				vif.ubus_size <= 'z;
				vif.ubus_read <= 'z;
				vif.ubus_write <= 'z;	
				vif.ubus_data <= tr.data[0];
				vif.ubus_bip <= 0;
				vif.ubus_addr <= 'z;

			wait (vif.ubus_wait==0) ;

				for (int i =0; i<tr.size; i++) begin


					vif.ubus_size <= 'z;
					vif.ubus_read <= 'z;
					vif.ubus_write <= 'z;	
					vif.ubus_data <= tr.data[i];
					vif.ubus_bip <= 1;
					vif.ubus_addr <= 'z;

					
					if (i==tr.size-1) vif.ubus_bip <=0;	
					@(posedge vif.ubus_clock);
				end
					`uvm_info("MSTR_DRV_write",$sformatf("data=%p,addr=%h, read=%0b, write=%0b, size=%0d",tr.data, tr.addr, tr.read, tr.write , tr.size),UVM_LOW)
					

				vif.ubus_size <= 'z;
				vif.ubus_addr <= 'z;
				vif.ubus_data <= 'z;
				vif.ubus_write <= 'z;
				vif.ubus_read <= 'z;
				vif.ubus_bip <= 0;
				@(posedge vif.ubus_clock);

			end else if (tr.read) begin
				vif.ubus_data <= 'z;
			@(posedge vif.ubus_clock);				
				vif.ubus_size <= 'z;
				vif.ubus_read <= 'z;
				vif.ubus_write <= 'z;	
				vif.ubus_bip <= 0;
				vif.ubus_addr <= 'z;


			wait (vif.ubus_wait==0) ;

				for (int i=0; i<tr.size; i++) begin

						tr.data[i] <= vif.ubus_data;
						vif.ubus_bip <= (i == tr.size - 1 ) ? 0 : 1;
						@(posedge vif.ubus_clock);
				end
				end

			

	endtask

		
endclass 

