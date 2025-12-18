class slave_sequence extends uvm_sequence #(packet);
	`uvm_object_utils(slave_sequence)
	
	`uvm_declare_p_sequencer(slave_sequencer)

	int unsigned m_mem[int unsigned];
	
	int wait_1_size = 0;
	int wait_size = 0;

	packet req;
	packet rsp;

	
	//event all_done;

	function new(string name = "slave_sequence");
		super.new(name);
		req = packet::type_id::create("req");
		rsp = packet::type_id::create("rsp");
		//set_automatic_phase_objection(1);
	endfunction





	virtual task body(); //sequence는 body에 run_phase 코드를 작성
		

		forever begin

			p_sequencer.request_fifo.get(req);

			rsp = packet::type_id::create("rsp");
			rsp.addr = req.addr;
			rsp.size = req.size;
			rsp.read = req.read;
			rsp.write = req.write;
			rsp.data = new[req.size];
			rsp.data = req.data;
			rsp.error = 0;

			wait_1_size = $urandom_range(0, 2);
			wait_size = rsp.size + wait_1_size;

			rsp.wait_state= new[wait_size];
			

		
			for (int i=0 ; i< wait_1_size; i++) begin

				rsp.wait_state[i] =1;

			end

			for (int i=wait_1_size; i<wait_size; i++) begin

				rsp.wait_state[i] =0;

			end

			for (int i=0; i< req.size; i++) begin

				if (req.write) begin
					m_mem[req.addr+i] = req.data[i];

				end

				if (req.read) begin
					if(!m_mem.exists(req.addr + i)) begin
						m_mem[req.addr +i] = $urandom_range(8'h10,8'hFF);
					end
					rsp.data[i] = m_mem[req.addr + i];
				end
			end


				start_item(rsp);  // ready to transfer
					/*if(rsp.write==1) begin  
					`uvm_info("SLV_SEQ",$sformatf("data=%p,addr=%h, read=%0b, write=%0b, size=%0d",rsp.data, rsp.addr, rsp.read, rsp.write , rsp.size),UVM_LOW)

					end
					if(rsp.read==1) begin `uvm_info("SLV_SEQ",$sformatf("data=%p,addr=%h, read=%0b, write=%0b, size=%0d",rsp.data, rsp.addr, rsp.read, rsp.write , rsp.size),UVM_LOW)
					end*/
				finish_item(rsp);





		end


	endtask	
		




endclass 
