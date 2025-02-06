module ISC_Master #(
    parameter CLK_FREQ = 25_000_000
) (
    // Sys signals
    input wire i_sys_clk,
    input wire i_sys_rstn,

    input wire [7:0] i_address,
    input wire [7:0] i_write_data,
    input wire req_trans, // Init transmission

    // Read Data
    output reg [7:0] o_read_data,
    output reg o_valid_out,

    // I2C signals
    output wire i2c_scl,
    inout  wire i2c_sda,

    // Module signals
    output  reg busy
);
    
    localparam IDLE = 4'b0000;

    reg [3:0] state;


    always @(posedge i_sys_clk) begin
        if(!i_sys_rstn) begin
            state <= IDLE;
        end else begin

        end
    end
endmodule

