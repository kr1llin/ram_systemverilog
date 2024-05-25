module ControlRAM #(
    parameter DATA_WIDTH = 8,  // Ширина данных
    parameter ADDR_WIDTH = 32   // Ширина адреса
) (
    input  logic clk,          // тактовый сигнал
    input  logic reset,        // сброс
    input  logic [ADDR_WIDTH-1:0] addr,  // входной адресс
    input  logic [DATA_WIDTH-1:0] dataIn, // входные данные
    input  logic writeEnable,  // сигнал записи
    output logic [DATA_WIDTH-1:0] dataOut // выходные данные
    
);

    // создание экземпляров модулей кэша и ОЗУ
    cache #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) cache (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .dataIn(dataIn),
        .writeEnable(writeEnable),
        .dataOut(cacheDataOut)
    );

    ram #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) ram (
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .dataIn(dataIn),
        .writeEnable(writeEnable & ~cache.cacheHit),
        .dataOut(ramDataOut)
    );

    // mux
    always @(*) begin
        if (cache.cacheHit) begin
            dataOut <= cacheDataOut;
        end else begin
            dataOut <= ramDataOut;
        end
    end

endmodule
