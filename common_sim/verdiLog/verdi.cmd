verdiSetActWin -dock widgetDock_<Decl._Tree>
debImport "wave.fsdb"
wvCreateWindow
wvSetPosition -win $_nWave2 {("G1" 0)}
wvOpenFile -win $_nWave2 {/DATA/home/edu028/3team/final/common_sim/wave.fsdb}
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -win $_nWave2
wvGetSignalOpen -win $_nWave2
wvGetSignalSetScope -win $_nWave2 "/my3_testbench_top"
wvGetSignalSetScope -win $_nWave2 "/my3_testbench_top/s_vif"
wvGetSignalSetScope -win $_nWave2 "/my3_testbench_top/m_vif"
wvGetSignalSetScope -win $_nWave2 "/my3_testbench_top/dut"
wvGetSignalSetScope -win $_nWave2 "/my3_testbench_top/s_vif"
wvGetSignalSetScope -win $_nWave2 "/my3_testbench_top/m_vif"
wvSetPosition -win $_nWave2 {("G1" 10)}
wvSetPosition -win $_nWave2 {("G1" 10)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/my3_testbench_top/m_vif/ubus_addr\[15:0\]} \
{/my3_testbench_top/m_vif/ubus_bip} \
{/my3_testbench_top/m_vif/ubus_clock} \
{/my3_testbench_top/m_vif/ubus_data\[7:0\]} \
{/my3_testbench_top/m_vif/ubus_error} \
{/my3_testbench_top/m_vif/ubus_read} \
{/my3_testbench_top/m_vif/ubus_reset} \
{/my3_testbench_top/m_vif/ubus_size\[2:0\]} \
{/my3_testbench_top/m_vif/ubus_wait} \
{/my3_testbench_top/m_vif/ubus_write} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 )} 
wvSetPosition -win $_nWave2 {("G1" 10)}
wvSetPosition -win $_nWave2 {("G1" 10)}
wvSetPosition -win $_nWave2 {("G1" 10)}
wvAddSignal -win $_nWave2 -clear
wvAddSignal -win $_nWave2 -group {"G1" \
{/my3_testbench_top/m_vif/ubus_addr\[15:0\]} \
{/my3_testbench_top/m_vif/ubus_bip} \
{/my3_testbench_top/m_vif/ubus_clock} \
{/my3_testbench_top/m_vif/ubus_data\[7:0\]} \
{/my3_testbench_top/m_vif/ubus_error} \
{/my3_testbench_top/m_vif/ubus_read} \
{/my3_testbench_top/m_vif/ubus_reset} \
{/my3_testbench_top/m_vif/ubus_size\[2:0\]} \
{/my3_testbench_top/m_vif/ubus_wait} \
{/my3_testbench_top/m_vif/ubus_write} \
}
wvAddSignal -win $_nWave2 -group {"G2" \
}
wvSelectSignal -win $_nWave2 {( "G1" 1 2 3 4 5 6 7 8 9 10 )} 
wvSetPosition -win $_nWave2 {("G1" 10)}
wvGetSignalClose -win $_nWave2
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 2485.186453
wvScrollDown -win $_nWave2 0
debExit
