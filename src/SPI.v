module SPI_SLAVE#(
    parameter DATA_WIDTH  = 10 ,
    parameter IDLE=3'b000,
    parameter CHK_CMD=3'b001,
    parameter READ_DATA=3'b010,
    parameter READ_ADD=3'b011,
    parameter WRITE=3'b100


)(
    input [7:0]tx_data,
    input tx_valid,
    input clk,
    input rst,
    input MOSI,
    input SS_n,

    output reg MISO,
    output reg rx_valid,
    output reg [DATA_WIDTH-1:0]rx_data

);
reg [3:0]counter,counter_MISO;
reg address_chk;

(* fsm_encoding = "gray" *) reg [2:0] cs, ns;
reg hold_tx_valid;
//State Meomery
always@(posedge clk)begin
    if(~rst)
    cs<=IDLE;
    else
    cs<=ns;
end

//next state logic
always@(*)begin
    case(cs)
    IDLE:
    begin
        if(SS_n==1)
            ns=IDLE;
        else
            ns=CHK_CMD;
    end
    CHK_CMD:
    begin
        if(SS_n==0 && MOSI==0)
            ns=WRITE;
        else if( SS_n==0 && MOSI ==1 && ~address_chk)
            ns=READ_ADD;
        else if( SS_n==0 && MOSI ==1 && address_chk)
            ns=READ_DATA;
        else
        ns=IDLE; 
    end
    READ_ADD: 
    if(SS_n==1) ns=IDLE;
    else ns= cs;

    READ_DATA:
    if(SS_n==1) ns=IDLE;
    else ns= cs;

     WRITE:
     if(SS_n==1) ns=IDLE;
    else ns= cs;

    default: ns=cs;

    endcase
end
//Output logic
always@(posedge clk)begin
    if(~rst)
    begin
        counter<=10;
        counter_MISO<=8;
        MISO<=0;
        rx_data<=0;
        rx_valid<=0;
        address_chk<=0;
    end
    else
    begin
    case(cs)
    IDLE: begin 
        counter<=10;
        counter_MISO<=8;
        rx_valid<=0;
        MISO<=0;
    end
    WRITE:
    if(counter!=0)begin
        counter<=counter-1;
        rx_data[counter-1]<=MOSI;
    end
    else
        rx_valid<=1;
    
    READ_ADD:
    if(counter!=0)begin
        rx_valid<=0;
        counter<=counter-1;
        rx_data[counter-1]<=MOSI;
    end
    else begin
        rx_valid<=1;
        address_chk<=1;
    end

    READ_DATA: begin
        if(counter!=0)begin // To Tell RAM the value of rx_data so RAM see rx[9:8]=2'b11 and know this is state read_data so it assert tx_data=1
        rx_valid<=0;
        counter<=counter-1;
        rx_data[counter-1]<=MOSI;
    end
    else begin
        rx_valid<=1;
    end


    if(hold_tx_valid) begin
    if(counter_MISO!=0)begin
        counter_MISO<=counter_MISO-1;
        MISO<=tx_data[counter_MISO-1];
    end
    else 
        address_chk<=0;  
        end
    end
    default: 
    begin
        counter<=10;
        counter_MISO<=8;
        rx_valid<=0;
        MISO<=0;
    end
    endcase
    end
end
// to hold tx_valid until tx_data transfering finished
always@(posedge clk)
begin
    if(~rst)
        hold_tx_valid<=0;
    else if(tx_valid==1)
        hold_tx_valid<=1; 
    else if(cs!=READ_DATA)
        hold_tx_valid<=0;
end
endmodule