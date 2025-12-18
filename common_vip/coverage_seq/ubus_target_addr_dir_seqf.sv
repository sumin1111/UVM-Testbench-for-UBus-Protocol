class ubus_target_addr_dir_seqf extends uvm_sequence #(packet);

    `uvm_object_utils(ubus_target_addr_dir_seqf)

    int n_repeat;
    ubus_coverage cov; // coverage 핸들

    // 주소 맵
    typedef struct {
        string name;
        int unsigned start_addr;
        int unsigned end_addr;
    } addr_map_t;

    addr_map_t addr_maps[] = '{
        '{name:"CONFIG_REGS",         start_addr:0,      end_addr:4095},
        '{name:"INTERNAL_SRAM_LOW",   start_addr:4096,   end_addr:10239},
        '{name:"INTERNAL_SRAM_HIGH",  start_addr:10240,  end_addr:16383},
        '{name:"PERIPHERAL_REGS",     start_addr:16384,  end_addr:20479},
        '{name:"EXTERNAL_CODE_FLASH", start_addr:20480,  end_addr:40959},
        '{name:"EXTERNAL_DATA_DDR",   start_addr:40960,  end_addr:65535}
    };

    function new(string name = "ubus_target_addr_dir_seqf");
        // UVM Factory 호환성을 위해 new(string name)을 유지합니다.
        super.new(name);
        if (!$value$plusargs("N_REPEAT=%d", n_repeat))
            n_repeat = 4;
        set_automatic_phase_objection(1);
    endfunction

    // ubus_target_addr_dir_seqf::pre_body() - Config DB Get 복원
    virtual task pre_body();
        super.pre_body();
        // Global Set과 호환되는 가장 확실한 Get 방식 사용
        if (!uvm_config_db#(ubus_coverage)::get(null, get_full_name(), "coverage", cov)) begin
            `uvm_warning(get_name(), "Failed to get 'ubus_coverage' handle. Will run blindly.")
        end
    endtask

    virtual task do_transaction(int i, bit dir);
        packet rsp;
        
        // size 제약 조건을 동적으로 설정하기 위한 local 변수
        int size_array[];
        if (i == 3) // PERIPHERAL_REGS
            size_array = '{1, 2, 4};
        else
            size_array = '{1, 2, 4, 8};

        `uvm_do_with(req, {
            // i에 해당하는 주소 영역으로 addr을 제약
            req.addr inside {[addr_maps[i].start_addr:addr_maps[i].end_addr]}; 
            // dir (0: READ, 1: WRITE)에 따라 read/write 설정
            req.read  == (dir == 1);
            req.write == (dir == 0);
            // size 제약 조건을 동적으로 적용
            req.size  inside {size_array}; 
        })
        
        get_response(rsp);
    endtask

    virtual task body();
        int size_map_small[] = '{1, 2, 4};
        int size_map_large[] = '{1, 2, 4, 8};

        // 🌟🌟🌟 오류 수정: 변수를 body() 스코프 내에서 미리 선언 🌟🌟🌟
        int max_attempts;
        bit all_covered = 0; // 초기화

        if (cov == null) begin
            `uvm_warning(get_name(), "Coverage handle is null. Running blind random tests.")
            // 핸들 연결 실패 시, n_repeat 만큼 기존 랜덤 실행 로직을 여기에 복사하여 사용
            // 예시로 가장 기본적인 랜덤 실행 로직을 추가합니다.
             for (int r = 0; r < n_repeat; r++) begin
                `uvm_do_with(req, {
                    // 기본 랜덤 제약 조건
                    req.size inside {1, 2, 4, 8};
                    req.addr inside {[0:65535]};
                })
            end
        end else begin
            
            // 🌟🌟🌟 타겟팅: 모든 조합을 반복하며 누락된 빈만 채우기 🌟🌟🌟
            
            // 선언된 max_attempts 변수를 루프 제어에 사용 (int 선언 제거)
            for (max_attempts = 0; max_attempts < 100; max_attempts++) begin 
                all_covered = 1; // 🌟 루프가 시작될 때마다 커버리지 플래그를 리셋
                
                // 1. 모든 주소 영역 (i = 0 to 5)
                foreach (addr_maps[i]) begin
                    // 2. 모든 Direction (dir = 0:READ, 1:WRITE)
                    for (int dir = 0; dir <= 1; dir++) begin
                        
                        int size_array[] = (i == 3) ? size_map_small : size_map_large;

                        // 3. 모든 Size
                        foreach (size_array[s_idx]) begin
                            int size = size_array[s_idx];
                            
                            // 🌟 누락된 빈(Bin)인지 확인
                            // is_covered 함수는 size_to_index로 변환된 인덱스(s_idx)를 받음
                            if (!cov.is_covered(i, dir, s_idx)) begin
                                
                                all_covered = 0; // 누락된 빈 발견
                                
                                `uvm_info(get_name(),
                                    $sformatf("[TARGET] Running %s for region %0d (%s) size %0d. Bin missing.",
                                        dir == 0 ? "READ" : "WRITE", i, addr_maps[i].name, size), UVM_LOW)
                                
                                // 4. 해당 조합으로 트랜잭션 생성
                                do_transaction(i, dir); 
                                
                                // 이 시도(max_attempts) 내에서 하나만 생성 후 다음 조합으로 넘어감
                            end
                        end
                    end
                end
                
                // 모든 조합을 순회했는데 모두 커버되었다면 루프 종료
                if (all_covered) begin
                    `uvm_info(get_name(), $sformatf("All target bins covered after %0d attempts.", max_attempts+1), UVM_MEDIUM)
                    break;
                end
            end
            
            // 최대 시도 횟수를 초과했을 경우 경고
            if (max_attempts == 100 && !all_covered) begin
                 `uvm_warning(get_name(), "Max attempts reached. Coverage may be incomplete.")
            end

        end
    endtask
endclass






