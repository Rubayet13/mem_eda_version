interface  mem_intf #(addrWidth = 16, dataWidth = 32) (input clk);

  // Declared as logic as, the pins can act as both like inputs or outputs, 
  //depending on who's accessing
  
  logic rst_n; 
  logic enb; 
  logic rd_wr;
  logic [addrWidth -1:0] addr;
  logic [dataWidth -1:0] data_in;
  logic [dataWidth -1:0] data_out;

endinterface