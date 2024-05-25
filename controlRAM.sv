module controlRAM #(
  parameter ADDR_WIDTH = 32,
  parameter DATA_WIDTH = 8
) (
  input logic clk,
  input logic rst,
  input logic [ADDR_WIDTH-1:0] addr,
  input logic [DATA_WIDTH-1:0] data_in,
  input logic wr_en,
  output logic [DATA_WIDTH-1:0] data_out
);

  logic hit;

  Cache #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) cache (
    .clk(clk),
    .rst(rst),
    .addr(addr),
    .data_in(data_in),
    .wr_en(wr_en),
    .data_out(data_out),
    .hit(hit)
  );

  RAM #(
    .ADDR_WIDTH(ADDR_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) ram (
    .clk(clk),
    .rst(rst),
    .addr(addr),
    .data_in(data_in),
    .wr_en(wr_en & ~hit),
    .data_out(data_out)
  );

endmodule
