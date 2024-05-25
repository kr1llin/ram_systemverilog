module ControlRAM_testbench;


  ControlRAM #(
    .DATA_WIDTH(8),
    .ADDR_WIDTH(32)
  ) control_ram (
    .addr(addr),
    .dataIn(dataIn),
    .writeEnable(writeEnable),
    .dataOut(dataOut)
  );


  logic clk, reset;


  initial begin
    clk <= 0;
    forever #10 clk <= ~clk;
  end


  initial begin
    reset <= 1;
    #100 reset <= 0;
  end


  initial begin
    @(posedge clk);
    control_ram.writeEnable <= 1;
    control_ram.addr <= 32'h00000000;
    control_ram.dataIn <= 8'h5a;

    @(posedge clk);
    control_ram.writeEnable <= 0;
  end

  initial begin
    @(posedge clk);
    control_ram.writeEnable <= 0;
    control_ram.addr <= 32'h00000000;
  end

endmodule
