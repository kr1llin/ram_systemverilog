module Testbench;

  ControlRAM #(
    .ADDR_WIDTH(32),
    .DATA_WIDTH(8)
  ) control_ram (
    .clk(clk),
    .rst(rst),
    .addr(addr),
    .data_in(data_in),
    .wr_en(wr_en),
    .data_out(data_out)
  );

  reg clk, rst;

  initial begin
    clk <= 0;
    forever #10 clk <= ~clk;
  end

  initial begin
    rst <= 1;
    #100 rst <= 0;
  end

  // Запись данных в кэш
  initial begin
    @(posedge clk);
    control_ram.wr_en <= 1;
    control_ram.addr <= 5;
    control_ram.data_in <= 8'h56;

    @(posedge clk);
    control_ram.wr_en <= 0;
  end

  // Чтение данных из кэша
  initial begin
    @(posedge clk);
    control_ram.wr_en <= 0;
    control_ram.addr <= 5;

    @(posedge clk);
    $display("Data read from the cache: %h", control_ram.data_out);
  end

endmodule
