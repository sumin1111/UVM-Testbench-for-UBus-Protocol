# UBUS VIP (Verification IP) Project

## 1. 프로젝트 개요
이 프로젝트는 UBUS 프로토콜을 위한 UVM(Universal Verification Methodology) 기반의 검증 IP(VIP)를 구현합니다.
본 VIP는 UBUS Master 및 Slave Agent를 포함하고 있어, UBUS 프로토콜을 사용하는 다양한 DUT(Design Under Test)를 효과적으로 검증할 수 있는 환경을 제공합니다.

## 2. 디렉토리 구조


```text
UVM_PROJECT_FINAL/
├── common_vip/
│ ├── my3_testbench_top.sv
│ ├── my3_vip_environment.sv
│ ├── packet.sv
│ ├── ananlysis_imp
│ │ ├── master_analysis_imp.sv
│ │ └── slave_analysis_imp.sv
│ ├── covereage_seq
│ ├── ubus_if/
│ │ ├── ubus_m_if.sv
│ │ └── ubus_s_if.sv
│ ├── dummy_dut.sv
│ ├── ubus_scoreboard.sv
│ ├── ubus_virtual_sequence.sv
│ ├── ubus_virtual_sequencer.sv
│ ├── ubus_coverage.sv
│ └── ubus_virtual_sequence_test.sv
│
├── master_vip/
│ ├── master_agent.sv
│ ├── master_driver.sv
│ ├── master_monitor.sv
│ ├── master_sequencer.sv
│ └── master_seq/
│   ├── ubus_master_write_word_seq.sv
│   ├── ubus_master_read_word_seq.sv
│   ├── ubus_master_write_random_size_seq.sv
│   └── ubus_master_read_random_size_seq.sv
│ 
├── slave_vip/
│ ├── slave_agent.sv
│ ├── slave_driver.sv
│ ├── slave_monitor.sv
│ ├── slave_sequencer.sv 
│ └── slave_sequence.sv
│
├── common_sim/
│ └── Makefile
│
└── README.md
```


  

- **`common_vip/`**: Coverage용 sequence와 scoreboard, coverage , test , env , interface 등 대부분의 component로 구성되어 있습니다.

- **`common_sim/`**: 테스트벤치 실행을 위한 스크립트 및 로그 파일이 위치합니다.

- **`master_vip/`**: 기능검증용 sequence와 master_agent로 구성되어 있습니다.

- `**`slave_vip/`**: slave sequence와 slave_agent로 구성되어 있습니다.

  

## 3. 컴파일 및 시뮬레이션 실행 방법
`sim` 디렉토리로 이동하여 `make` 명령어를 실행합니다.

```bash
# 1. tb 디렉토리로 이동
cd common_sim/

# 2. make 명령어 실행

# 랜덤 시뮬레이션 실행
make random N_REPEAT=100 RANDOM_SEED=127   # N_REPEAT: read/write 반복 횟수, RANDOM_SEED: 시드 값 지정

# 생성된 파일 정리
make clean                                 # Makefile을 제외한 모든 생성 파일 삭제

# Verdi 실행 (fsdb 자동 로드)
make verdi                                 # wave.fsdb 자동 로드 후 Verdi 실행
```



## 4. Sequence List
Functional 검증 sequence # master와 slave에서 addr 증가폭 일정 #write 후 메모리 저장값과 read 후 값 비교
- ubus_master_read_word_seq # burst write
- ubus_master_write_word_seq # burst read

Coverage용 sequence # 4가지 방법으로 Coverage 100% 달성 및 read/write 수 최소화
- ubus_master_read_random_size_seq / ubus_master_write_random_size_seq # address size 전 범위에서 커버리지
- ubus_target_addr_dir_seq1~6 # targeting한 addr에 따른 6가지 sequence
- ubus_target_addr_dir_seq # targeting 6가지 sequence 1개로 통합
- ubus_target_addr_dir_seqf # hit 영역은 반복안하는 sequence

## 5. 결론 및 제언
본 프로젝트에서는 UVM 방법론을 기반으로 UBUS 프로토콜 검증을 위한 VIP(Verification IP)를 성공적으로 구현하였다. 
특히 Coverage-Driven Verification(CDV) 기법을 도입하여, 무가치한 중복 트랜잭션을 배제하고 미달성된 커버리지 영역만 지능적으로 타겟팅함으로써 검증 효율을 83% 이상 획기적으로 개선할 수 있었다. 
본 VIP는 재사용 가능한 모듈형 구조로 설계되어 향후 다양한 SoC 검증 환경에 유연하게 적용될 수 있을 것으로 기대된다.

