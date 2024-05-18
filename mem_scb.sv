class mem_scb; 
  mailbox #(mem_trans) mntr2scb;
  //mailbox drvr2scb;
  mem_trans item;
  semaphore sema;
  DATA_VAL mem [ADDR_VAL]; //bit [15:0] mem [31:0]
  event ev1;
  static int pass;
  static int fail; 
  function new(mailbox #(mem_trans) mntr2scb, semaphore sema);
    this.mntr2scb = mntr2scb;
    this.sema = sema;
    $display ($time, "ns || SCB_CREATED");
  endfunction

  task run (); 
    forever begin 
      mntr2scb.get(item);
      $display ($time, "ns || item get done at scb");

      if(!item.rst_n)
        begin 
          foreach (mem[i]) mem[i] = 0;
          $display  ($time, "ns || mem Updated at scb");
        end 
      else if(item.rst_n && !item.rd_wr) 
        begin 
          mem[item.addr]=item.data_in;
          $display  ($time, "ns || Updated");
        end 
      else if(item.rst_n && item.rd_wr)  
        begin
          if (item.data_out === mem[item.addr])
            begin 
              $display ($time, "ns || pass");
              //$display ($time, item.data_out, item.addr, "ns || expected data [%0d] and data at scb[%0d]");
              pass++;
              $display ($time,"ns || Total Pass = %0d", pass);
            end
          else 
            begin $display ($time, "ns || failed");
              //$display ($time, item.data_out, item.addr, "ns || expected data [%0d] and data at scb [%0d]");
              fail++;
              $display ($time,"ns || Total Fail = %0d", fail);
            end 
        end
      sema.put();
      //->ev1;
    end

  endtask

endclass

// function compare (int exp_value, observed_value);

//   if (exp_value === observed_value) begin
//     $display($time, "ns || Read data that was written earlier || PASSED");
//     PASSED++;
//   end

//   else begin
//     $display($time, "ns || Read data that was not written earlier || FAILED");
//     FAILED++;
//     address_failed_for = new[address_failed_for.size() +1](address_failed_for);
//     address_failed_for[address_failed_for.size() +1] = INTF.addr;
//   end

// endfunction