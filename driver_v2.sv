class driver_v2 extends mem_driver;

  function new(virtual mem_intf INTF, mailbox #(mem_trans) test2drvr, semaphore sema);
    super.new(INTF, test2drvr, sema);
    name = "Driver V2";
  endfunction

  virtual task run();
    $display($time, "ns || [%s] INITIATED", name);
    
    forever begin
      test2drvr.get(item);  
      $display($time, "ns || [%s] Got Item", name);
      $display($time, "ns || [%s] Running %s", name, item.opp.name());
      INTF.rst_n   <= item.rst_n;
      INTF.rd_wr   <= item.rd_wr;
      INTF.enb     <= 0;
      INTF.data_in <= item.data_in;
      INTF.addr    <= item.addr;
      @(negedge INTF.clk);

      if (item.opp == WRITE || item.opp == READ) begin
        INTF.enb <= 1;
        @(negedge INTF.clk);
      end

      $display($time, "ns || [%s] done %s", name, item.opp.name());
     //sema.put();
    end

  endtask


endclass