

// =================================================================
// 2. 트랜잭션 커버리지 그룹 정의 (cov_trans)
// (Master/Slave Monitor에서 수집된 트랜잭션(packet)을 샘플링)
// =================================================================
covergroup cov_trans() with function sample(packet trans);
    // [참고: UBUS Functional coverage example에서 가져온 커버 포인트]
    // UBUS의 필수적인 필드 커버리지 정의
    
    option.per_instance = 1;

    // 1. 주소 (addr): 16개의 자동 빈(bin)으로 커버
    trans_addr : coverpoint trans.req.addr { option.auto_bin_max = 16; }

    // 2. 방향 (read/write): Read=0, Write=1로 분리
    trans_dir : coverpoint trans.req.read { bins READ = {0}; bins WRITE = {1}; }
    
    // 3. 사이즈 (size): 정의된 값만 커버
    trans_size : coverpoint trans.req.size { bins sizes[] = {1, 2, 4, 8}; } 
    
    // 4. 크로스 커버리지 (Address, Direction, Size의 조합)
    trans_addrDirXSize : cross trans_addr, trans_dir, trans_size;

endgroup


// =================================================================
// 3. Coverage Component (uvm_subscriber 상속)
// =================================================================
class ubus_coverage extends uvm_subscriber #(packet);
    
    // UVM 팩토리 등록 매크로
    `uvm_component_utils(ubus_coverage)

    // 1. 커버리지 객체 핸들 선언
    cov_trans m_trans_cg;
    
    // 2. Monitor의 analysis_port와 연결될 IMP (uvm_subscriber가 제공)
    // uvm_subscriber는 이미 'analysis_export'를 가지고 있습니다.
    
    // 3. 생성자
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // 4. build_phase: 커버리지 그룹 객체 생성
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // 트랜잭션 커버리지 그룹 인스턴스 생성
        m_trans_cg = new();
    endfunction

    // 5. write 함수: 트랜잭션이 도착할 때마다 호출됨 (핵심 샘플링 로직)
    // uvm_subscriber를 상속받았기 때문에, 이 함수를 오버라이드하여 Monitor로부터 트랜잭션을 받습니다.
    virtual function void write(packet t);
        // 도착한 트랜잭션을 커버리지 그룹으로 샘플링
        m_trans_cg.sample(t);
        
        `uvm_info(get_name(), $sformatf("Sampled transaction: addr=0x%0h, size=%0d", t.req.addr, t.req.size), UVM_LOW)
    endfunction

    // 6. report_phase: 커버리지 결과 출력
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        
        if (m_trans_cg.get_coverage() < 100) begin
             `uvm_warning(get_name(), $sformatf("UBUS Transaction Coverage is incomplete: %0.2f%%", m_trans_cg.get_coverage()))
        end
        
        // 커버리지 리포트 출력
        m_trans_cg.get_inst_coverage();
    endfunction

endclass
