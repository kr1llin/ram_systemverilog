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

    // Параметры модуля
    parameter DATA_WIDTH = 8;
    parameter ADDR_WIDTH = 8;
    parameter CACHE_SIZE = 16;
    parameter CACHE_LINE_SIZE = 4;
    parameter WORD_SIZE = DATA_WIDTH / 8;
    parameter TAG_WIDTH = ADDR_WIDTH - $clog2(CACHE_SIZE);

    // Сигналы для подключения к модулю
    logic clk;
    logic reset;
    logic [ADDR_WIDTH-2:0] addr;
    logic [DATA_WIDTH-1:0] dataIn;
    logic writeEnable;
    logic [DATA_WIDTH-1:0] dataOut;

    // Создание экземпляра модуля
    CachedRAM #(DATA_WIDTH, ADDR_WIDTH) ram (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .dataIn(dataIn),
        .writeEnable(writeEnable),
        .dataOut(dataOut)
    );

    // Счетчик для адреса
    reg [ADDR_WIDTH-1:0] count;

    // Генерация тактового сигнала
    always #5 clk = ~clk;

    // Инициализация и тестирование
    initial begin
        clk = 0;
        reset = 1;
        addr = 0;
        dataIn = 0;
        writeEnable = 0;
        count = 0;
        #10 reset = 0;

        // Запись данных в кэш
        dataIn = 8'hFF;
        writeEnable = 1;
        repeat (4) begin
            addr = count;
            #10;
            count = count + 1;
        end
        #10 writeEnable = 0;

        // Чтение данных из кэша
        writeEnable = 0;
        count = 0;
        repeat (4) begin
            addr = count;
            #10;
            count = count + 1;
            if (dataOut !== 8'hFF) begin
                $display("Ошибка: Некорректные данные при чтении из кэша! Ожидаемые данные: 8'hFF, Полученные данные: %h", dataOut);
                $finish;
            end
        end

        $display("Тест завершен: все данные успешно считаны из кэша.");
        $finish;
    end

endmodule
