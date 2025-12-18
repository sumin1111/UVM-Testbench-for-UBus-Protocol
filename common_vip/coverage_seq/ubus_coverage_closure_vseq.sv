class ubus_coverage_closure_vseq extends uvm_sequence;
    `uvm_object_utils(ubus_coverage_closure_vseq)

    // 생성자
    function new(string name = "ubus_coverage_closure_vseq");
        super.new(name);
    endfunction

    // 1. 주소 영역 정의 (6개의 Bin에 해당)
    typedef struct {
        string name;
        int unsigned start_addr;
        int unsigned end_addr;
    } addr_map_t;

    addr_map_t addr_maps[] = {
        {"CONFIG_REGS", 0, 4095},
        {"INTERNAL_SRAM_LOW", 4096, 10239},
        {"INTERNAL_SRAM_HIGH", 10240, 16383},
        {"PERIPHERAL_REGS", 16384, 20479},
        {"EXTERNAL_CODE_FLASH", 20480, 40959},
        {"EXTERNAL_DATA_DDR", 40960, 65535} 
    };

    virtual task body();
        // 개별 시나리오를 실행할 단일 시퀀스 핸들
        ubus_target_addr_dir_seq target_seq;
        string dir_name;
        
        // 12가지 시나리오를 단 하나의 Loop로 표현:
        
        // 6개 주소 영역 순회
        foreach (addr_maps[i]) begin
            
            // ** Illegal Bin Skip Logic **
            // CONFIG_REGS (index 0)와 PERIPHERAL_REGS (index 3)는 size=8이 불법이므로 건너뜁니다.
            if (i == 0 || i == 3) begin
                `uvm_info(get_full_name(), 
                          $sformatf("Skipping %s: size=8 is illegal in this region.", addr_maps[i].name), UVM_LOW)
                continue; 
            end
            
            // 2개 방향 순회 (target_read = 0: READ, 1: WRITE)
            for (int target_read = 0; target_read < 2; target_read++) begin
                
                dir_name = (target_read == 0) ? "READ" : "WRITE";
                
                // 시퀀스를 동적으로 생성
                target_seq = ubus_target_addr_dir_seq::type_id::create($sformatf("target_seq_%s_%s", addr_maps[i].name, dir_name));
                
                // 1. 시퀀스 파라미터 설정 (Loop 변수 사용)
                target_seq.start_addr = addr_maps[i].start_addr;
                target_seq.end_addr   = addr_maps[i].end_addr;
                target_seq.target_read = target_read;
                target_seq.num_trans = 50; // 각 조합당 50개의 트랜잭션 실행
                
                // 2. 시퀀스 시작 (m_sequencer는 ubus_virtual_sequencer를 가리킵니다.)
                `uvm_info(get_full_name(), 
                          $sformatf("--- STARTING SCENARIO: %s %s ---", 
                                    addr_maps[i].name, dir_name), UVM_MEDIUM)
                
                // m_master_sqr는 실제 master agent의 sequencer를 가리켜야 합니다.
                target_seq.start(m_sequencer.m_master_sqr); 
                
            end // for target_read
        end // foreach addr_maps
        
        `uvm_info(get_full_name(), "All directed scenarios have finished.", UVM_LOW)

    endtask : body

endclass : ubus_coverage_closure_vseq