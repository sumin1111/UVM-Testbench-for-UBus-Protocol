// master_analysis_imp.sv

//`include "../common_vip/ubus_scoreboard.sv" // scoreboard 포함



class master_analysis_imp extends uvm_analysis_imp#(packet, ubus_scoreboard);

    ubus_scoreboard m_parent;

    function new(string name, ubus_scoreboard parent);
        super.new(name, parent);
        m_parent = parent;
    endfunction



    virtual function void write(packet t);
        `uvm_info("MASTER_IMP","write called",UVM_LOW)
        m_parent.write_master(t);
    endfunction
endclass



