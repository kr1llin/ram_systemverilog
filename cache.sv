module Cache #(
  parameter ADDR_WIDTH = 32,
  parameter DATA_WIDTH = 8
) (
  input logic clk,
  input logic rst,
  input logic [ADDR_WIDTH-1:0] addr,
  input logic [DATA_WIDTH-1:0] data_in,
  input logic wr_en,
  output logic [DATA_WIDTH-1:0] data_out,
  output logic hit
);

  logic [DATA_WIDTH-1:0] data [2**ADDR_WIDTH-1:0];
  logic [ADDR_WIDTH-1:0] tag [2**ADDR_WIDTH-1:0];
  logic [$pow(2, (ADDR_WIDTH + 3))- 1 : 0] addrCount;

  assign hit = (tag[addr] == addr) & (addrCount[0] == 0);

  always @(posedge clk) begin
    if (rst) begin
      for (integer i = 0; i < 2**ADDR_WIDTH; i = i + 1) begin
        data[i] <= 0;
        tag[i] <= 0;
      end
      addrCount <= 0;
    end else if (addrCount < ($pow(2, (ADDR_WIDTH + 3)) - 1)) begin
      addrCount <= addrCount + 1;
    end else if (wr_en & hit) begin
      data[addr] <= data_in;
      tag[addr] <= addr;
      addrCount <= 0;
    end else if (hit) begin
      data_out <= data[addr];
      addrCount <= 0;
    end
  end

endmodule
