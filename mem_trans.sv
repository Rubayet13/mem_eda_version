class mem_trans;

  bit rst_n;
  bit enb;
  bit rd_wr;
  bit [addrWidth -1:0] addr;
  bit [dataWidth -1:0] data_in;
  logic [dataWidth -1:0] data_out;

  OPERATION opp;

endclass