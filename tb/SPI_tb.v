    module SPI_tb();
    reg MOSI,SS_n,clk,rst;
    wire MISO;

    //Clock Generation
    initial begin
        clk=0;
        forever begin
            #1 clk=~clk;
        end
    end
    TOP t(.MOSI(MOSI),.MISO(MISO),.SS_n(SS_n),.clk(clk),.rst(rst));

    initial begin
    //Test 0 check rst
    rst= 0 ;
    @(negedge clk);
    if(MISO!==0)
    $display("Error in rst");
    rst=1;

    //==================================================
    //////Test 1 data=0x7a   add=0Xff     
    //==================================================

    //write address;
    SS_n=0; 
    @(negedge clk); // state --> CHK_CMD
    MOSI=0;
    @(negedge clk); // // STATE --> WRITE

    repeat(2)begin // rx_data[9:8]=2'b00
    MOSI=0;
    @(negedge clk);
    end
    repeat(8) begin //rx_data[7:0]=8'hff
        MOSI=1;
        @(negedge clk);
    end
    @(negedge clk); // here spi makes rx_valid=1
    SS_n=1; // to return to IDLE state
    @(negedge clk);   // here ram reads rx_valid

    //Write data
    SS_n=0;
    @(negedge clk); // state --> CHK_CMD
    MOSI=0;
    @(negedge clk); // STATE --> WRITE
    MOSI=0;
    @(negedge clk);
    MOSI=1;
    @(negedge clk); //rx_data [9:8]=2'b01

    MOSI=0; //rx_data[7]=0
    @(negedge clk);
    repeat(3) begin //rx_data[6:4]=3'b111
        MOSI=1;
        @(negedge clk);
    end
    repeat(2)begin //rx_data [3:0]=4'b1010
        MOSI=1;
        @(negedge clk);
        MOSI=0;
        @(negedge clk);
    end
    @(negedge clk); // here spi makes rx_valid=1
    SS_n=1; // to return to IDLE state
    @(negedge clk);   // here ram reads rx_valid

    //read address
    SS_n=0;
    @(negedge clk); // state --> CHK_CMD
    MOSI=1;
    @(negedge clk); //READ

    MOSI=1;
    @(negedge clk);
    MOSI=0;
    @(negedge clk); //din [9:8]= 10

    repeat(8) begin
        MOSI=1;
        @(negedge clk);
    end
    @(negedge clk); // here spi makes rx_valid=1
    SS_n=1; //  return to IDLE state
    @(negedge clk);   // here ram reads rx_valid

    //READ data
    SS_n=0;
    @(negedge clk); // state --> CHK_CMD
    MOSI=1;
    @(negedge clk); //READ

    MOSI=1;
    @(negedge clk);
    MOSI=1;
    @(negedge clk); //din [9:8]= 11

    repeat(8) begin // din[7:0] --> Garbage
        MOSI=0;
        @(negedge clk);
    end
    @(negedge clk) // here spi makes rx_valid=1
    @(negedge clk);  // here reads rx_valid && ram makes tx_valid=1
    @(negedge clk);  // here spi reads tx_valid


    repeat(8) begin // tx_data[7:0] --> MISO
        @(negedge clk);
    end
    SS_n=1; //  return to IDLE state
    @(negedge clk);


    //===============================================
    //Test 2 address =0xfe  data=0xf1
    //===============================================
    SS_n=0; 
    @(negedge clk); // state --> CHK_CMD
    MOSI=0;
    @(negedge clk); // // STATE --> WRITE

    repeat(2)begin // rx_data[9:8]=2'b00
    MOSI=0;
    @(negedge clk);
    end
    repeat(7) begin //rx_data[7:1]=7'b1111 111
        MOSI=1;
        @(negedge clk);
    end
    MOSI=0;
    @(negedge clk); // rx_data[0] = 0


    @(negedge clk); // here spi makes rx_valid=1
    SS_n=1; // to return to IDLE state
    @(negedge clk);   // here ram reads rx_valid

    //Write data
    SS_n=0;
    @(negedge clk); // state --> CHK_CMD
    MOSI=0;
    @(negedge clk); // STATE --> WRITE
    MOSI=0;
    @(negedge clk);
    MOSI=1;
    @(negedge clk); //rx_data [9:8]=2'b01

    repeat(4) begin //rx_data[7:4]=3'b111
        MOSI=1;
        @(negedge clk);
    end
    repeat(3)begin //rx_data [4:1]=3'b000
        MOSI=0;
        @(negedge clk);
    end
    MOSI=1; // rx_data[0]=1'b1
    @(negedge clk);

    @(negedge clk); // here spi makes rx_valid=1
    SS_n=1; // to return to IDLE state
    @(negedge clk);   // here ram reads rx_valid

    //read address
    SS_n=0;
    @(negedge clk); // state --> CHK_CMD
    MOSI=1;
    @(negedge clk); //READ

    MOSI=1;
    @(negedge clk);
    MOSI=0;
    @(negedge clk); //din [9:8]= 10

    repeat(7) begin //rx_data[7:1]=7'b1111 111
        MOSI=1;
        @(negedge clk);
    end

    MOSI=0; // rx_data[0]=1'b0
    @(negedge clk);

    @(negedge clk); // here spi makes rx_valid=1
    SS_n=1; //  return to IDLE state
    @(negedge clk);   // here ram reads rx_valid

    //READ data
    SS_n=0;
    @(negedge clk); // state --> CHK_CMD
    MOSI=1;
    @(negedge clk); //READ

    MOSI=1;
    @(negedge clk);
    MOSI=1;
    @(negedge clk); //din [9:8]= 11

    repeat(8) begin // din[7:0] --> Garbage
        MOSI=0;
        @(negedge clk);
    end
    @(negedge clk) // here spi makes rx_valid=1
    @(negedge clk);  // here reads rx_valid && ram makes tx_valid=1
    @(negedge clk);  // here spi reads tx_valid


    repeat(8) begin // tx_data[7:0] --> MISO
        @(negedge clk);
    end
    SS_n=1; //  return to IDLE state
    @(negedge clk);

    $stop;
    end
    endmodule