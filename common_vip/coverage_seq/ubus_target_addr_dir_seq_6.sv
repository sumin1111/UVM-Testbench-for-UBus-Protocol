class ubus_target_addr_dir_seq_6 extends uvm_sequence #(packet);

    `uvm_object_utils(ubus_target_addr_dir_seq_6)

    // Virtual Sequence가 전달할 파라미터
    int unsigned start_addr;
    int unsigned end_addr;
    bit target_read;  // 0=READ, 1=WRITE
    int num_trans;    
    string dir_name;

    int n_repeat;

    function new(string name = "ubus_target_addr_dir_seq_6");
        super.new(name);
        if (!$value$plusargs("N_REPEAT=%d", n_repeat))
            n_repeat = 4;
        set_automatic_phase_objection(1);
    endfunction

    // 주소 맵 구조체
    typedef struct {
        string name;
        int unsigned start_addr;
        int unsigned end_addr;
    } addr_map_t;

    

addr_map_t addr_maps[] = '{
    '{name:"CONFIG_REGS",        start_addr:0,     end_addr:4095},
    '{name:"INTERNAL_SRAM_LOW",  start_addr:4096,  end_addr:10239},
    '{name:"INTERNAL_SRAM_HIGH", start_addr:10240, end_addr:16383},
    '{name:"PERIPHERAL_REGS",    start_addr:16384, end_addr:20479},
    '{name:"EXTERNAL_CODE_FLASH",start_addr:20480, end_addr:40959},
    '{name:"EXTERNAL_DATA_DDR",  start_addr:40960, end_addr:65535}
};

    // WRITE 트랜잭션
    virtual task do_write(int i);

		packet rsp;

        if( i!=3) begin

        `uvm_do_with(req, {
            req.addr inside {[addr_maps[i].start_addr:addr_maps[i].end_addr]};
            req.read  == 0;
            req.write == 1;
            req.size  inside {1,2,4,8};
        })
	
        end else begin

        `uvm_do_with(req, {
            req.addr inside {[addr_maps[i].start_addr:addr_maps[i].end_addr]};
            req.read  == 0;
            req.write == 1;
            req.size  inside {1,2,4};
        })

        end

        get_response(rsp);
		$display("");
    endtask

    // READ 트랜잭션
    virtual task do_read(int i);

		packet rsp;

        if( i!=3) begin

        `uvm_do_with(req, {
            req.addr inside {[addr_maps[i].start_addr:addr_maps[i].end_addr]};
            req.read  == 1;
            req.write == 0;
            req.size  inside {1,2,4,8};
        })
	

        end else begin

        `uvm_do_with(req, {
            req.addr inside {[addr_maps[i].start_addr:addr_maps[i].end_addr]};
            req.read  == 1;
            req.write == 0;
            req.size  inside {1,2,4};
        })

        end
		
        get_response(rsp);
		$display("");
    endtask

    // body에서 반복 실행
    virtual task body();


			/* for (int r = 0; r < n_repeat; r++) begin
                do_write(0);
                do_write(1);
                do_write(2);
                do_write(4);
                do_write(5);
			end

            for (int j=0; j<n_repeat; j++) begin
                do_write(3);
            end

			for (int r = 0; r < n_repeat; r++) begin
                do_read(0);
                do_read(1);
                do_read(2);
                do_read(4);
                do_read(5);
			end 

            for (int j=0; j<n_repeat; j++) begin
                do_read(3);
            end */


            for (int r = 0; r < n_repeat; r++) begin
                do_write(5);

			end

            for (int r = 0; r < n_repeat; r++) begin
                do_read(5);

			end 



			//do_write(0);
    endtask

endclass