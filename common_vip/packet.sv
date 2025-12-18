class packet extends uvm_sequence_item;
           
    rand bit [15:0] addr;
    rand bit read;
    rand bit write;
    rand bit [3:0] size;
    rand bit [7:0] data[];
    rand int wait_state;
    rand bit error;

    function new(string name = "packet");
        super.new(name);
    endfunction: new


    constraint c_dir { (read ^ write) == 1; }
    constraint c_size { size inside{1,2,4,8};}
    constraint c_data_size { data.size() == size; }
    constraint global_legality { 

        !(addr inside {[16384:20479]} && size == 8);
    }


    // 메크로 세트 , UVM 클래스 등록 + 자동화
    `uvm_object_utils_begin(packet)  // UVM Factory에 class 등록 + 필드 자동화 (동적)
        `uvm_field_int(addr, UVM_DEFAULT) // 맴버를 UVM 시스템에 등록 => 자동화 , copy compare print etc 가능하게 해줌
        `uvm_field_int(read, UVM_DEFAULT)
        `uvm_field_int(write, UVM_DEFAULT)
        `uvm_field_int(size, UVM_DEFAULT)
        `uvm_field_array_int(data, UVM_DEFAULT)
        `uvm_field_int(error, UVM_DEFAULT)
        `uvm_field_int(wait_state, UVM_DEFAULT)
    `uvm_object_utils_end


endclass: packet

