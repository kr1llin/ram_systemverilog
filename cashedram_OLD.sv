module CachedRAM #(
    parameter DATA_WIDTH = 8,  // Ширина данных
    parameter ADDR_WIDTH = 8   // Ширина адреса
) (
    input  logic clk,          // тактовый сигнал
    input  logic reset,        // сброс
    input  logic [ADDR_WIDTH-2:0] addr,  // входной адресс
    input  logic [DATA_WIDTH-1:0] dataIn, // входные данные
    input  logic writeEnable,  // сигнал записи
    output logic [DATA_WIDTH-1:0] dataOut // выходные данные
);

    // размер кэша
    parameter CACHE_SIZE = 16;
    // ширина тега
    parameter TAG_WIDTH = ADDR_WIDTH - $clog2(CACHE_SIZE);
    // количество слов в кэш-линии
    parameter CACHE_LINE_SIZE = 4;
    // размер слова (в байтах)
    parameter WORD_SIZE = DATA_WIDTH / 8;

    // определение кэш-памяти
    logic [DATA_WIDTH-1:0] cache [0: (1<<ADDR_WIDTH) - 1][0:CACHE_LINE_SIZE-1];
    logic [TAG_WIDTH-1:0] tag [0: (1<<ADDR_WIDTH) - 1];
    logic [ (1<<ADDR_WIDTH) - 1:0] valid;
    
    // внутренние регистры для управления кэшем
    logic [DATA_WIDTH-1:0] cacheLineData [0:CACHE_LINE_SIZE-1];
    logic [ADDR_WIDTH-1:0] cacheLineAddr;
    logic [TAG_WIDTH-1:0] cacheLineTag;
    logic cacheHit, cacheWriteEnable;

    // обработка чтения из кэша
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            dataOut <= 0;
            cacheLineAddr <= 0;
            cacheLineTag <= 0;
            cacheHit <= 0;
            cacheWriteEnable <= 0;
            valid <= 0;
        end
        else begin
            cacheHit <= (tag[addr[(ADDR_WIDTH-2): $clog2(CACHE_LINE_SIZE)]] == addr[TAG_WIDTH-1:0]) && valid[addr[(ADDR_WIDTH-2): $clog2(CACHE_LINE_SIZE)]];
            if (cacheHit) begin
                dataOut <= cache[addr[(ADDR_WIDTH-2): $clog2(CACHE_LINE_SIZE)]][addr[$clog2(CACHE_LINE_SIZE)-1:0]];
            end
            else begin
                cacheLineAddr <= addr;
                cacheLineTag <= addr[TAG_WIDTH-1:0];
            end
        end
    end

    // обработка записи в кэш
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            cacheWriteEnable <= 0;
        end
        else begin
            if (cacheHit && writeEnable) begin
                cache[addr[(ADDR_WIDTH-2): $clog2(CACHE_LINE_SIZE)]][addr[$clog2(CACHE_LINE_SIZE)-1:0]] <= dataIn;
            end
            else begin
                if (writeEnable) begin
                    cacheWriteEnable <= 1;
                end
            end
        end
    end

    // обновление кэша после промаха
    always_comb begin
        if (cacheWriteEnable) begin
            cacheLineData[addr[$clog2(CACHE_LINE_SIZE)-1:0]] <= dataIn;
            cache[addr[(ADDR_WIDTH-2): $clog2(CACHE_LINE_SIZE)]][addr[$clog2(CACHE_LINE_SIZE)-1:0]] <= dataIn;
            tag[addr[(ADDR_WIDTH-2): $clog2(CACHE_LINE_SIZE)]] <= addr[TAG_WIDTH-1:0];
            valid[addr[(ADDR_WIDTH-2): $clog2(CACHE_LINE_SIZE)]] <= 1;
        end
    end

endmodule
