module mem #(addrWidth = 16, dataWidth =32) (
  input wire clk, rst_n, enb, rd_wr,
  input wire [addrWidth -1:0] addr,
  input wire [dataWidth -1:0] data_in,
  output reg [dataWidth -1:0] data_out
);

  parameter int DEPTH = 2**addrWidth;

  reg [dataWidth -1: 0] mem_block [DEPTH/256];
  reg [dataWidth -1: 0]outData;

  always @(posedge clk or negedge rst_n) begin
	outData = 'hz;
    if (rst_n == 0) begin
      foreach (mem_block[i]) mem_block[i] <= 0;
    end 

    else begin
      //$display($time, "ns || [DUT] Normal Opp");
      if (rd_wr) begin
        //$display($time, "ns || [DUT] Read from %d Opp", addr);
        if (enb) begin
          //$display($time, "ns || [DUT] Read done from %d Opp", addr);
          outData <= mem_block[addr]; 
        end
        else mem_block[addr] <= mem_block[addr];
      end

      else begin
        //$display($time, "ns || [DUT] Write %d to %d Opp", data_in, addr);
        if (enb) mem_block[addr] <= data_in;
        else mem_block[addr] <= mem_block[addr];
      end
    end

  end

  assign data_out = outData;

endmodule


// if (enb) begin
//   if (rd_wr) begin 
//     $display($time, "ns Reading data from adderss %0h", addr);
//     outData <= mem_block[addr];
//   end
//   else begin
//     $display($time, "ns Writting data %0h to adderss %0h", data_in, addr);
//     mem_block[addr] <= data_in;
//   end
// end
// else mem_block[addr] <= mem_block[addr];