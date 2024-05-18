class mem_monitor;

  virtual mem_intf INTF;
  mailbox #(mem_trans) mntr2scb;
  //mailbox #(mem_trans) mntr2cov;
  mem_trans item;
  semaphore sema;

  function new(virtual mem_intf INTF, mailbox #(mem_trans) mntr2scb, semaphore sema);

    this.INTF = INTF;
    this.mntr2scb = mntr2scb;
    //this.mntr2cov = mntr2cov;
    this.sema = sema;
    $display ($time, "|| MONITOR_CREATED");
  endfunction

  task run();
    forever begin 
      @(posedge INTF.clk);
      if(!INTF.rst_n)
        begin 
          item=new();
          item.addr=INTF.addr;
          item.data_in= INTF.data_in;
          item.rd_wr= INTF.rd_wr;
          item.rst_n= INTF.rst_n;      
          mntr2scb.put(item); 
          $display ($time, "ns || put done");

        end 
      else if (INTF.rst_n && INTF.enb && !INTF.rd_wr)
        expected_capture();
      else if (INTF.rst_n && INTF.enb && INTF.rd_wr)
        actual_capture();
    end 
  endtask

  task expected_capture();

    begin 
      item=new();
      item.addr=INTF.addr;
      item.data_in= INTF.data_in;
      item.rd_wr= INTF.rd_wr;
      item.rst_n= INTF.rst_n;
      $display ($time, "ns || [%0d] Writing item [%0d] at address [%0d] ",item.rd_wr, item.data_in, item.addr);
      mntr2scb.put(item); 
      $display ($time, "ns || put done");

    end 
  endtask
  task actual_capture();
    begin 
      item=new();
      item.addr=INTF.addr;

      item.rd_wr= INTF.rd_wr;
      item.rst_n= INTF.rst_n;
      @(negedge INTF.clk);
      item.data_out= INTF.data_out;
      $display ($time, "ns || [%0d] Reading item [%0d] at address [%0d] ",item.rd_wr, item.data_out, item.addr);
      mntr2scb.put(item); 
      $display ($time, "ns || item put done");

    end
  endtask

endclass