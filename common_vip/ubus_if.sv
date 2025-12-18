interface ubus_if;

	logic ubus_clock;
	logic ubus_reset;
	logic [15:0] ubus_addr;
	logic [1:0] ubus_size;
	logic ubus_read;
	logic ubus_write;
	logic ubus_bip;
	logic [7:0] ubus_data;
	logic ubus_wait;
	logic ubus_error;



    // master_driver용 포트
    modport MASTER (
         ubus_addr,
         ubus_size,
         ubus_read,
         ubus_write,
         ubus_data,
	 ubus_clock,
          ubus_wait,
          ubus_bip,
          ubus_error
    );

    // slave_driver용 포트
    modport SLAVE (
	 ubus_clock,
          ubus_addr,
          ubus_size,
         output ubus_read,
          ubus_write,	
          ubus_data,
         ubus_wait,
        output ubus_bip,
         ubus_error
    );



endinterface
