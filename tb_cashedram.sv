`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.05.2024 11:55:21
// Design Name: 
// Module Name: tb_cashedram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module CachedRAM_tb;

    localparam DATA_WIDTH = 8;
    localparam ADDR_WIDTH = 8;
    
    logic clk;
    logic reset;
    logic [ADDR_WIDTH-1:0] addr;
    logic [DATA_WIDTH-1:0] dataIn;
    logic writeEnable;
    logic [DATA_WIDTH-1:0] dataOut;

    CachedRAM #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) cachedRAM_inst (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .dataIn(dataIn),
        .writeEnable(writeEnable),
        .dataOut(dataOut)
    );

    // генерируем тактовый сигнал
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // тесты
    initial begin
        // сброс
        reset = 1;
        addr = 0;
        dataIn = 0;
        writeEnable = 0;
        #10 reset = 0;

        // запись в кэш
        addr = 4;
        dataIn = 8'hFF;
        writeEnable = 1;
        #20;

        // чтение из кэша
        addr = 4;
        dataIn = 0;
        writeEnable = 0;
        #20;

        // проверка чтения
        if (dataOut !== 8'hFF) begin
            $display("Неверные данные при чтении кэша!");
        end
        else begin
            $display("Чтение успешно");
        end

        $finish;
    end
endmodule
