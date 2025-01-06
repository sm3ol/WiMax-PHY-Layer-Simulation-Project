`timescale 1ns / 1ns
module Top_tb;

    // Inputs
    logic rst_n;
    logic clk;
    logic Valid_top;
    logic datain;
    logic ready_mod;
    
    // Output declarations
    logic [15:0] I_top;
    logic [15:0] Q_top;
    logic Valid_out_top;

    Top u_Top (
    .rst_n(rst_n),
    .clk(clk),
    .Valid_top(Valid_top),
    .datain(datain),
    .ready_mod(ready_mod),
    // outputs 
    .I_top(I_top),
    .Q_top(Q_top),
    .Valid_out_top(Valid_out_top)
);

    
        integer bit_index = 0;  // Start from MSB of test_data_rom
        integer Block_um=0;
    // ROM for input data (from test_data_rom)
    logic [191:0] test_data_rom = 191'h2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA;


    // Clock generation
    always begin
        clk = 1;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Test procedure
    initial begin
        // Initialize inputs
        rst_n = 0;
        ready_mod = 0;
        Valid_top = 0;
        datain = 1;
    

        // Apply reset
        #10 rst_n = 1;
        #10;
        // Start sending data
        Valid_top = 1;
        
        // filing the A buffer 
        for (bit_index =192; bit_index >= 0; bit_index = bit_index - 1) begin
            datain = test_data_rom[bit_index];
            @(posedge clk); // Wait one clock cycle for each bit
        end

        Valid_top=0;
        
        #10 Valid_top=1;
        Block_um=1;

        for (bit_index =192; bit_index >= 0; bit_index = bit_index - 1) begin
            datain = test_data_rom[bit_index];
            
            @(negedge clk); // Wait one clock cycle for each bit
        end
         
      
        Valid_top=0;
        #10 Valid_top=1;
        Block_um =2;
        
        for (bit_index =192; bit_index >=0; bit_index = bit_index - 1) begin
            datain = test_data_rom[bit_index];

            @(posedge clk); // Wait one clock cycle for each bit
            
            
        end

            #20;

        

        
        // Display Comprehensive Test Results
       // display_results();

        // Finish the test
        $finish;
    end

    initial begin
     ready_mod=0;   
     #1960 ready_mod=1;
     #1925 ready_mod=0;
     #25 ready_mod=1;
     
    end





endmodule



