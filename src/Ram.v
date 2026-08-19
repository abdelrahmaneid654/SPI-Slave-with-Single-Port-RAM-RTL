module Ram#(
    parameter MEM_DEPTH =256 ,
    parameter ADDR_SIZE =8 
)(
    input [9:0]din,
    input clk,
    input rst,
    input rx_valid,
    output reg [7:0] dout,
    output reg tx_valid
);
reg [ADDR_SIZE-1:0] write_add;
reg [ADDR_SIZE-1:0] read_add;

reg [ADDR_SIZE-1:0] MEM [MEM_DEPTH-1:0];

always@(posedge clk)begin
    if(~rst) begin
        dout<=0;
        tx_valid<=0;
        write_add<=0;
        read_add<=0;
    end
    else
    begin
    if (rx_valid)begin
    case(din[9:8])
    2'b00: begin 
       write_add<=din[7:0];
       tx_valid<=0 ;
    end

    2'b01: begin
    MEM[write_add]<=din[7:0];
    tx_valid<=0 ;
    end

    2'b10: begin
    read_add<=din[7:0];
    tx_valid<=0 ;
    end

    2'b11 :
    begin
    dout<=MEM[read_add];
    tx_valid<=1;
    end

    default :dout<=MEM[read_add];
    endcase
    end
  end
end
endmodule