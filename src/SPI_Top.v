module TOP#(
    parameter DATA_WIDTH =10,
    parameter MEM_DEPTH =256 ,
    parameter ADDR_SIZE =8 
)(
    input MOSI,
    input SS_n,
    input clk,
    input rst,

    output MISO
);
wire [DATA_WIDTH-1:0]rx_data;
wire rx_valid,tx_valid;
wire [DATA_WIDTH-3:0]tx_data;
SPI_SLAVE #(.DATA_WIDTH(DATA_WIDTH)) S(
    .MOSI(MOSI),
    .SS_n(SS_n),
    .MISO(MISO),
    .rx_data(rx_data),
    .rx_valid(rx_valid),
    .tx_data(tx_data),
    .tx_valid(tx_valid),
    .clk(clk),
    .rst(rst));

Ram #(.ADDR_SIZE(ADDR_SIZE),.MEM_DEPTH(MEM_DEPTH)) R(
    .din(rx_data),
    .rx_valid(rx_valid),
    .dout(tx_data),
    .tx_valid(tx_valid),
    .clk(clk),
    .rst(rst));

endmodule