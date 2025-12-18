// slave_analysis_imp.sv

//`include "../common_vip/ubus_scoreboard.sv" // scoreboard 포함



class slave_analysis_imp extends uvm_analysis_imp#(packet, ubus_scoreboard);

    ubus_scoreboard s_parent;

    function new(string name, ubus_scoreboard parent);
        super.new(name, parent);
        s_parent = parent;
    endfunction

    virtual function void write(packet t);
        `uvm_info("SLAVE_IMP","write called",UVM_LOW)
        s_parent.write_slave(t);
    endfunction
endclass


