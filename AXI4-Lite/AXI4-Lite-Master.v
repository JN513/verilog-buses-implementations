// -----------------------------------------------------------------------------
// Módulo Master AXI4-Lite
// -----------------------------------------------------------------------------
module AXI4_Lite_Master #(
    parameter ADDR_WIDTH = 32, // Largura do endereço
    parameter DATA_WIDTH = 32  // Largura dos dados
)(
    input  wire                  clk,         // Clock do sistema
    input  wire                  reset_n,     // Reset ativo em nível baixo
    // Sinais de Escrita
    output reg  [ADDR_WIDTH-1:0] awaddr,      // Endereço de escrita
    output reg                   awvalid,     // Sinal de validação do endereço de escrita
    input  wire                  awready,     // Sinal de pronto do slave para escrita
    output reg  [DATA_WIDTH-1:0] wdata,       // Dados de escrita
    output reg                   wvalid,      // Sinal de validação dos dados de escrita
    input  wire                  wready,      // Sinal de pronto do slave para os dados
    input  wire [1:0]            bresp,       // Resposta de escrita (OKAY ou ERROR)
    input  wire                  bvalid,      // Validação da resposta de escrita
    output reg                   bready,      // Sinal indicando que o master recebeu a resposta
    // Sinais de Leitura
    output reg  [ADDR_WIDTH-1:0] araddr,      // Endereço de leitura
    output reg                   arvalid,     // Sinal de validação do endereço de leitura
    input  wire                  arready,     // Sinal de pronto do slave para leitura
    input  wire [DATA_WIDTH-1:0] rdata,       // Dados lidos
    input  wire [1:0]            rresp,       // Resposta de leitura (OKAY ou ERROR)
    input  wire                  rvalid,      // Validação dos dados lidos
    output reg                   rready       // Sinal indicando que o master recebeu os dados
);

    // Registradores internos
    reg [2:0] write_state;  // Estado da FSM para escrita
    reg [2:0] read_state;   // Estado da FSM para leitura

    // Definição dos estados para FSM
    localparam IDLE      = 3'b000;
    localparam WRITE_ADDR = 3'b001;
    localparam WRITE_DATA = 3'b010;
    localparam WRITE_RESP = 3'b011;

    localparam READ_ADDR = 3'b100;
    localparam READ_DATA = 3'b101;

    // Lógica de reset
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Resetar os sinais do master
            awaddr  <= 0;
            awvalid <= 0;
            wdata   <= 0;
            wvalid  <= 0;
            bready  <= 0;
            araddr  <= 0;
            arvalid <= 0;
            rready  <= 0;
            write_state <= IDLE;
            read_state  <= IDLE;
        end else begin
            // FSM para escrita
            case (write_state)
                IDLE: begin
                    if (/* Condição de início de escrita */) begin
                        awaddr  <= /* Endereço desejado */;
                        awvalid <= 1;
                        write_state <= WRITE_ADDR;
                    end
                end
                WRITE_ADDR: begin
                    if (awready) begin
                        awvalid <= 0;
                        wdata   <= /* Dados desejados */;
                        wvalid  <= 1;
                        write_state <= WRITE_DATA;
                    end
                end
                WRITE_DATA: begin
                    if (wready) begin
                        wvalid <= 0;
                        bready <= 1;
                        write_state <= WRITE_RESP;
                    end
                end
                WRITE_RESP: begin
                    if (bvalid) begin
                        bready <= 0;
                        write_state <= IDLE;
                    end
                end
            endcase

            // FSM para leitura
            case (read_state)
                IDLE: begin
                    if (/* Condição de início de leitura */) begin
                        araddr  <= /* Endereço desejado */;
                        arvalid <= 1;
                        read_state <= READ_ADDR;
                    end
                end
                READ_ADDR: begin
                    if (arready) begin
                        arvalid <= 0;
                        rready  <= 1;
                        read_state <= READ_DATA;
                    end
                end
                READ_DATA: begin
                    if (rvalid) begin
                        /* Processar rdata */
                        rready <= 0;
                        read_state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule

