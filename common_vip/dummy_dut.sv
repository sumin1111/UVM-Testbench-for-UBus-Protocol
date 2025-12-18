module dummy_dut(
  ubus_m_if m_vif,  // 마스터에서 들어오는 쪽
  ubus_s_if  s_vif    // 슬레이브로 나가는 쪽
);

  // 기본 클록 연결
  assign s_vif.ubus_clock = m_vif.ubus_clock;

  // 주소, 제어 신호, 데이터 전달
  assign s_vif.ubus_addr  = m_vif.ubus_addr;
  assign s_vif.ubus_write = m_vif.ubus_write;
  assign s_vif.ubus_read  = m_vif.ubus_read;
  assign s_vif.ubus_data  = m_vif.ubus_data; 
  assign m_vif.ubus_data  =s_vif.ubus_data;

  assign s_vif.ubus_bip = m_vif.ubus_bip;
  assign s_vif.ubus_size = m_vif.ubus_size;
  assign s_vif.ubus_reset= m_vif.ubus_reset;

  // 슬레이브 응답 신호를 마스터로 되돌림
  assign m_vif.ubus_wait = s_vif.ubus_wait;
  assign m_vif.ubus_error = s_vif.ubus_error;

endmodule
