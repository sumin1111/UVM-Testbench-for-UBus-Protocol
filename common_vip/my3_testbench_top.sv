module my3_testbench_top;
    //`include "uvm_macros.svh" 
    import uvm_pkg::*;
    `include "../common_vip/packet.sv"
    `include "../common_vip/ubus_scoreboard.sv"   
    `include "../common_vip/analysis_imp/slave_analysis_imp.sv"
    `include "../common_vip/analysis_imp/master_analysis_imp.sv"
 
    `include "../master_vip/master_monitor.sv"
    `include "../master_vip/master_driver.sv"
    `include "../master_vip/master_sequencer.sv"
    `include "../master_vip/master_agent.sv"
   
  
    `include "../slave_vip/slave_monitor.sv"
    `include "../slave_vip/slave_driver.sv"
    `include "../slave_vip/slave_sequencer.sv"
    `include "../slave_vip/slave_agent.sv"

    `include "../common_vip/ubus_coverage.sv"
    `include "../common_vip/ubus_virtual_sequencer.sv"
    

    

    `include "../slave_vip/slave_sequence.sv"
    `include "../master_vip/master_seq/ubus_master_write_word_seq.sv"
    `include "../master_vip/master_seq/ubus_master_read_word_seq.sv"
    `include "../master_vip/master_seq/ubus_master_write_random_size_seq.sv"
    `include "../master_vip/master_seq/ubus_master_read_random_size_seq.sv"

    `include "../common_vip/coverage_seq/ubus_target_addr_dir_seq.sv"
    `include "../common_vip/coverage_seq/ubus_target_addr_dir_seq_1.sv"
    `include "../common_vip/coverage_seq/ubus_target_addr_dir_seq_2.sv"
    `include "../common_vip/coverage_seq/ubus_target_addr_dir_seq_3.sv"
    `include "../common_vip/coverage_seq/ubus_target_addr_dir_seq_4.sv"
    `include "../common_vip/coverage_seq/ubus_target_addr_dir_seq_5.sv"
    `include "../common_vip/coverage_seq/ubus_target_addr_dir_seq_6.sv"
    `include "../common_vip/coverage_seq/ubus_target_addr_dir_seqf.sv"

    `include "../common_vip/pkg/sequence_pkg.sv"
    `include "../common_vip/ubus_virtual_sequence.sv"

    `include "../common_vip/my3_vip_environment.sv"

    `include "../common_vip/ubus_virtual_sequence_test.sv"

    // Interface Instance
    ubus_m_if m_vif();
    ubus_s_if s_vif();

    dummy_dut dut(
	.m_vif(m_vif),
	.s_vif(s_vif)
	);

    // Clock Generation
    initial m_vif.ubus_clock = 0;
    always #5 m_vif.ubus_clock = ~m_vif.ubus_clock;

    //uvm_config_db#(virtual ubus_if)::set(null,"*","vif",vif);
    // 구성요소: context, inst_name , field_name, vif
    // null-> root에서 시작 , hierarchy의 모든 component에 적용, component에서 get할 때 사용 , 실제 interface instance 

	

    initial begin 
	$fsdbDumpfile("wave.fsdb");
	$fsdbDumpvars(0, my3_testbench_top);
	
	uvm_config_db#(virtual ubus_m_if)::set(null,"uvm_test_top.env.m_agent*","vif",m_vif);
	uvm_config_db#(virtual ubus_s_if)::set(null,"uvm_test_top.env.s_agent*","vif",s_vif);
        run_test();

        /*forever @(posedge vif.ubus_clock) begin
			$display("[%0t] Clock tick", $time);
	end*/
    end


endmodule
