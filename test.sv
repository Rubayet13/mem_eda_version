program basetest (input clk, mem_intf INTF);

  driver_v2 DRVR;
  mem_monitor mntr;
  mem_scb scb;
  mailbox #(mem_trans) test2drvr;
  mailbox #(mem_trans) mntr2scb;
  mem_trans item;
  semaphore sema;

  initial begin
    $display("test initiated");

    test2drvr = new();
    mntr2scb = new();
    sema = new();
    DRVR = new(INTF, test2drvr, sema);
    mntr = new(INTF, mntr2scb, sema);
    scb = new(mntr2scb, sema);
    //basetest.sema=DRVR.sema;
    //basetest.sema=scb.sema;

    fork
      DRVR.run();
      mntr.run();
      scb.run();
    join_none

    reset();
    read(145);
    write(105, 1100);
    //scb.mem[105] =10;
    read(105);
    write(105, 20);
    write(15, 11);
    write(205, 15);
    read(105);
    read(15);
    read(205);
    read(115);
    reset();
    read(105);
    read(15);
    read(205);
    read(115);
    write(513,299);
    read(513);

    //idle();
    //read(105);


    @(negedge clk);
    $finish;

  end

  task reset();
    $display("\n", $time, "ns || [TEST] Running RESET");
    item = new();
    item.opp = RESET;
    item.rst_n = 0;
    item.rd_wr = 0;
    item.addr  = 0;
    item.data_in = 0;

    test2drvr.put(item);
    sema.get();
    $display($time, "ns || [TEST] RESET Done");
  endtask

  task write(ADDR_VAL addr, DATA_VAL data);
    $display("\n", $time, "ns || [TEST] Running WRITE");
    item = new();
    item.opp     = WRITE;
    item.rst_n   = 1;
    item.data_in = data;
    item.addr    = addr;
    item.rd_wr   = 1'b0;

    test2drvr.put(item);
    sema.get();
    $display($time, "ns || [TEST] WRITE Done");
  endtask

  task idle();
    $display("\n", $time, "ns || [TEST] Running IDLE");
    item = new();
    item.opp = IDLE;
    item.rst_n   = 1;

    test2drvr.put(item);
    sema.get();
    $display($time, "ns || [TEST] IDLE Done");
  endtask

  task read(ADDR_VAL addr);
    $display("\n", $time, "ns || [TEST] Running READ");
    item = new();
    item.opp = READ;
    item.rst_n   = 1;
    item.addr = addr;
    item.rd_wr   = 1'b1;

    test2drvr.put(item);
    sema.get();
    $display($time, "ns || [TEST] READ Done");
  endtask

endprogram



// INTF.rst_n <= 0;
// INTF.rd_wr <= 0;
// INTF.enb <= 0;
// INTF.data_in <= 0;
// INTF.addr <= 0;
// @(negedge clk);

// INTF.rst_n <= 1;
// INTF.rd_wr <= 0;
// INTF.enb <= 1;
// INTF.data_in <= 10;
// INTF.addr <= 110;
// @(negedge clk);

// INTF.rd_wr <= 1;
// INTF.enb <= 1;
// INTF.addr <= 110;
// @(negedge clk);
// @(negedge clk);

// repeat (10) begin
//   @(negedge clk);
// end

// $finish;



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
