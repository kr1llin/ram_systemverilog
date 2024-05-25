module ControlRAM_testbench;

    parameter DATA_WIDTH1 = 8;
    parameter ADDR_WIDTH1 = 32;
    
      //logic writeEnable1;
      logic [ADDR_WIDTH1-1:0] addr1;
      logic [DATA_WIDTH1-1:0] dataIn1;
      logic [DATA_WIDTH1-1:0] dataOut1;

  ControlRAM #(
    .DATA_WIDTH(8),
    .ADDR_WIDTH(32)
  ) control_ram (
    .addr(addr1),
    .dataIn(dataIn1),
    //.writeEnable(writeEnable1),
    .dataOut(dataOut1)
  );


  logic clk, reset, writeEnable1;


  initial begin
    clk <= 0;
    forever #10 clk <= ~clk;
  end


  initial begin
    reset <= 1;
    writeEnable1 <= 1;
    #100 reset <= 0;
  end

  initial begin
    @(posedge clk);
    writeEnable1 <= 1;
    addr1 <= 32'h00000000;
    dataIn1 <= 8'h5a;

    @(posedge clk);
    #100 writeEnable1 <= 0;
  end

  initial begin
    @(posedge clk);
    #100 writeEnable1 <= 0;
    addr1 <= 32'h00000000;
  end

endmodule
