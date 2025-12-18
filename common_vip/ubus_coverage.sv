// =================================================================
// 2. 트랜잭션 커버리지 그룹 정의 및 서브스크라이버
// =================================================================
covergroup cov_trans() with function sample(packet trans);
    // [참고: UBUS Functional coverage example에서 가져온 커버 포인트]
    
    option.per_instance = 1;


    // 1. 주소 (addr): 16개의 자동 빈(bin)으로 커버
    trans_addr : coverpoint trans.addr {
        bins CONFIG_REGS           = { [0:4095] }; 
        // 12K SRAM 분할
        bins INTERNAL_SRAM_LOW     = { [4096:10239] };
        bins INTERNAL_SRAM_HIGH    = { [10240:16383] };
        
        bins PERIPHERAL_REGS       = { [16384:20479] };
        
        // 45K 외부 메모리 분할
        bins EXTERNAL_CODE_FLASH = { [20480:40959] };
        bins EXTERNAL_DATA_DDR   = { [40960:65535] }; // $ 대신 명시적 범위 사용
    }

    // 2. 방향 (read/write): Read=0, Write=1로 분리 (read 필드가 1이면 Read, 0이면 Write)
    trans_dir : coverpoint trans.read { bins READ = {1}; bins WRITE = {0}; }
    
    // 3. 사이즈 (size): 정의된 값만 커버
    trans_size : coverpoint trans.size { bins sizes[] = {1, 2, 4, 8}; } 
    
    // 4. 크로스 커버리지 (Address, Direction, Size의 조합)
    trans_addrDirXSize : cross trans_addr, trans_dir, trans_size{
        // size 8은 PERIPHERAL_REGS (16384:20479)에서 불가능하므로 무시
        ignore_bins IGN_SIZE8_ADDR =
            binsof(trans_addr) intersect {[16384:20479]} &&
            binsof(trans_size) intersect {8};
    }
    
    // 5. 지연(Wait State) 커버리지 (지연이 없는 경우와 있는 경우 모두 확인)
    trans_wait_state : coverpoint trans.wait_state { bins NO_WAIT = {0}; bins WITH_WAIT1 = {1}; bins WITH_WAIT2 = {2}; bins WITH_WAIT3 = {3}; }

endgroup


class ubus_coverage extends uvm_subscriber #(packet);

    `uvm_component_utils(ubus_coverage)

    // 커버리지 그룹
    cov_trans m_trans_cg;

    // 각 bin 달성 여부를 추적하는 배열
    // [addr_index][dir_index (0=WRITE, 1=READ)][size_index (0=1, 1=2, 2=4, 3=8)]
    bit covered_bins[6][2][4]; 

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        // 🌟 수정: function 내의 변수 선언은 실행문보다 먼저 위치해야 합니다.
        // build_phase의 지역 변수 a, d, s를 맨 위로 이동
        int a, d, s; 
        
        super.build_phase(phase);
        m_trans_cg = new();
        
        // 초기화: covered_bins 배열의 모든 요소 0으로 설정
        foreach(covered_bins[a][d][s]) begin
             covered_bins[a][d][s] = 0;
        end
    endfunction


    // Monitor에서 트랜잭션 도착 시 호출
    virtual function void write(packet t);
        int a, d, s; // local variables
        
        // 1. UVM Covergroup 샘플링
        m_trans_cg.sample(t);

        // 2. 시퀀스 타겟팅을 위한 커버리지 배열 업데이트
        a = addr_to_index(t.addr);
        d = t.read ? 1 : 0; // READ(1)이면 1, WRITE(0)이면 0. (trans_dir 정의와 일치)
        s = size_to_index(t.size);
        
        // size 8이 불가능한 영역(PERIPHERAL_REGS, index 3)에 대한 예외 처리
        if (a == 3 && s == 3) begin
            // 이 트랜잭션은 ignore_bin에 해당하므로 covered_bins에 기록하지 않음
            // 하지만 시뮬레이터에서 ignore_bins를 자동으로 커버된 것으로 간주하므로, 
            // is_covered를 통해 이 조합을 요청하는 시퀀스를 막는 것이 중요합니다.
             `uvm_info(get_name(), $sformatf("Ignored bin: addr=%0d, size=%0d", a, t.size), UVM_HIGH)
        end else begin
            // 유효한 조합만 기록
            covered_bins[a][d][s] = 1;
        end
    
        `uvm_info(get_name(), $sformatf("Sampled transaction: addr=0x%0h, read=%0d, size=%0d, a=%0d, d=%0d, s=%0d", t.addr, t.read, t.size, a, d, s), UVM_LOW)
    endfunction

    // 시퀀스에서 bin 달성 확인용
    // 🌟 PERIPHERAL_REGS (a=3)와 size 8 (s=3) 조합은 항상 '커버됨'으로 처리
    function bit is_covered(int a, int d, int s);
        if (a == 3 && s == 3) begin
            return 1; // ignore_bin이므로 커버되었다고 간주
        end
        return covered_bins[a][d][s];
    endfunction

    // 주소 → bin index 계산 (0~5)
    function int addr_to_index(int unsigned addr);
        if(addr <= 4095)      return 0; // CONFIG_REGS
        else if(addr <= 10239) return 1; // INTERNAL_SRAM_LOW
        else if(addr <= 16383) return 2; // INTERNAL_SRAM_HIGH
        else if(addr <= 20479) return 3; // PERIPHERAL_REGS
        else if(addr <= 40959) return 4; // EXTERNAL_CODE_FLASH
        else                   return 5; // EXTERNAL_DATA_DDR
    endfunction

    // size → bin index 계산 (0~3)
    function int size_to_index(int size);
        case(size)
            1: return 0;
            2: return 1;
            4: return 2;
            8: return 3;
            default: return 0;
        endcase
    endfunction

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        if (m_trans_cg.get_coverage() < 100) begin
              `uvm_warning(get_name(), $sformatf("UBUS Transaction Coverage is incomplete: %0.2f%%", m_trans_cg.get_coverage()))
        end else begin
              `uvm_info(get_name(), $sformatf("UBUS Transaction Coverage reached 100%%. Verification SUCCESS!"), UVM_LOW)
        end
        
        // 커버리지 리포트 출력
        m_trans_cg.get_inst_coverage();
    endfunction

endclass