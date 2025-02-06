// -----------------------------------------------------------------------------
// Módulo Slave AXI4-Lite
// -----------------------------------------------------------------------------
module AXI4_Lite_Slave #(
    parameter ADDR_WIDTH = 32, // Largura do endereço
    parameter DATA_WIDTH = 32  // Largura dos dados
)(
    input  wire                  clk,         // Clock do sistema
    input  wire                  reset_n,     // Reset ativo em nível baixo
    // Sinais de Escrita
    input  wire [ADDR_WIDTH-1:0] awaddr,      // Endereço de escrita
    input  wire                  awvalid,     // Validação do endereço de escrita
    output reg                   awready,     // Sinal de pronto para endereço de escrita
    input  wire [DATA_WIDTH-1:0] wdata,       // Dados de escrita
    input  wire                  wvalid,      // Validação dos dados de escrita
    output reg                   wready,      // Sinal de pronto para dados de escrita
    output reg  [1:0]            bresp,       // Resposta de escrita (OKAY ou ERROR)
    output reg                   bvalid,      // Validação da resposta de escrita
    input  wire                  bready,      // Sinal indicando que o master recebeu a resposta
    // Sinais de Leitura
    input  wire [ADDR_WIDTH-1:0] araddr,      // Endereço de leitura
    input  wire                  arvalid,     // Validação do endereço de leitura
    output reg                   arready,     // Sinal de pronto para endereço de leitura
    output reg  [DATA_WIDTH-1:0] rdata,       // Dados lidos
    output reg  [1:0]            rresp,       // Resposta de leitura (OKAY ou ERROR)
    output reg                   rvalid,      // Validação dos dados lidos
    input  wire                  rready       // Sinal indicando que o master recebeu os dados
);

    // Memória interna simples (somente para demonstração)
    reg [DATA_WIDTH-1:0] memory [0:255]; // Memória de 256 palavras

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Resetar os sinais do slave
            awready <= 0;
            wready  <= 0;
            bvalid  <= 0;
            arready <= 0;
            rvalid  <= 0;
        end else begin
            // Lógica de escrita
            if (awvalid && !awready) begin
                awready <= 1; // Aceitar endereço de escrita
            end else begin
                awready <= 0;
            end

            if (wvalid && !wready) begin
                wready <= 1; // Aceitar dados de escrita
                memory[awaddr] <= wdata; // Escrever na memória
                bresp <= 2'b00; // OKAY
                bvalid <= 1;
            end else begin
                wready <= 0;
                bvalid <= 0;
            end

            // Lógica de leitura
            if (arvalid && !arready) begin
                arready <= 1; // Aceitar endereço de leitura
            end else begin
                arready <= 0;
            end

            if (arvalid && arready) begin
                rdata <= memory[araddr]; // Ler da memória
                rresp <= 2'b00;          // OKAY
                rvalid <= 1;
            end else if (rready) begin
                rvalid <= 0;
            end
        end
    end

endmodule
