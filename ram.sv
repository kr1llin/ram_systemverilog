module RAM #(
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

  logic [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0];

  assign data_out = mem[addr];

  always @(posedge clk) begin
    if (rst) begin
      mem[addr] <= 0;
    end else if (wr_en) begin
      mem[addr] <= data_in;
    end
  end

endmodule
