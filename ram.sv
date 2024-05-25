module ram #(
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

    // определение RAM
    logic [DATA_WIDTH-1:0] mem [0: (1<<ADDR_WIDTH) - 1];

    // обработка чтения из RAM
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            dataOut <= 0;
        end
        else begin
            dataOut <= mem[addr];
        end
    end

    // обработка записи в RAM
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            mem[addr] <= 0;
        end
        else begin
        if (writeEnable) begin
                        mem[addr] <= dataIn;
                    end
                end
            end
        
endmodule
