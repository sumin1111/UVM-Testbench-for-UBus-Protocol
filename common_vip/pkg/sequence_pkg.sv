// This file consolidates all ubus master-side sequence includes.

// 기존의 Write/Read random/word sequences
/*`include "ubus_master_write_word_seq.sv"
`include "ubus_master_read_word_seq.sv"
`include "ubus_master_write_random_size_seq.sv"
`include "ubus_master_read_random_size_seq.sv"*/

// 🚨 Low/Mid/High 주소 범위 타겟 시퀀스
`include "../common_vip/coverage_seq/ubus_master_write_low_seq.sv"
`include "../common_vip/coverage_seq/ubus_master_write_mid_seq.sv"
`include "../common_vip/coverage_seq/ubus_master_write_high_seq.sv"
`include "../common_vip/coverage_seq/ubus_master_read_low_seq.sv"
`include "../common_vip/coverage_seq/ubus_master_read_mid_seq.sv"
`include "../common_vip/coverage_seq/ubus_master_read_high_seq.sv"

