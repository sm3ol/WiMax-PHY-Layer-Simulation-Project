`timescale 1ns / 1ns
module Interleaver_tb;

    // Inputs
    logic clk;
    logic rstn;
    logic Ready_in;
    logic Valid_in;
    logic Data_in;

    logic [191:0] expected_output = 192'h4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E;
    // Outputs  
    logic Ready_out;
    logic Data_out;
    logic Valid_out;

    // ROM for input data (from test_data_rom)
    logic [191:0] test_data_rom = 191'h2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA;
    
    // Register to capture output data
    logic [383:0] captured_output;
    integer bit_index = 0;  // Start from MSB of test_data_rom
    integer error_count=0;
    integer correct_count = 0;

    // Instantiate the Interleaver module
    interleaver uut (
        .clk(clk),
        .rstn(rstn),
        .Ready_in(Ready_in),
        .Valid_in(Valid_in),
        .Data_in(Data_in),
        .Ready_out(Ready_out),
        .Data_out(Data_out),
        .Valid_out(Valid_out)
    );

    // Clock generation
    always begin
        clk = 1;
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Test procedure
    initial begin
        // Initialize inputs
        rstn = 0;
        Ready_in = 0;
        Valid_in = 0;
        Data_in = 1;
        captured_output = 0;

        // Apply reset
        #10 rstn = 1;
        #10;
        // Start sending data
        Valid_in = 1;
        
        // filing the A buffer 
        for (bit_index =192; bit_index >= 0; bit_index = bit_index - 1) begin
            Data_in = test_data_rom[bit_index];
            @(posedge clk); // Wait one clock cycle for each bit
        end
		  
        Valid_in = 0;  // End of data input
     ///
        #10;
        ////
        Ready_in = 1;
        Valid_in = 1;
        
        for (bit_index =192; bit_index >= 0; bit_index = bit_index - 1) begin
            Data_in = test_data_rom[bit_index];
            
            if (Valid_out) begin
                if (Data_out!=expected_output[bit_index])begin
                    error_count=error_count+1;
                    error  :  the expected out is %b , the output is %b 
                    ", expected_output[bit_index], Data_out);

                end else begin
                    correct_count=correct_count+1;
                    $display (" correct :   the expected out is %b , the output is %b", expected_output[bit_index], Data_out);
                end 
            end
            @(negedge clk); // Wait one clock cycle for each bit
        end

        Ready_in = 0;
        Valid_in = 0;  // End of data input

        #10;
    ///////    
        Ready_in = 1;
        Valid_in = 1;
        
        for (bit_index =192; bit_index >=0; bit_index = bit_index - 1) begin
            Data_in = test_data_rom[bit_index];

            @(posedge clk); // Wait one clock cycle for each bit
            
              if (Valid_out) begin
                if (Data_out!=expected_output[bit_index])begin
                    error_count=error_count+1;
                      $display ("
                    error  :  the expected out is %b , the output is %b 
                    ", expected_output[bit_index], Data_out);

                end else begin
                    correct_count=correct_count+1;
                    $display (" correct :   the expected out is %b , the output is %b", expected_output[bit_index], Data_out);
                end 
            end
            
        end

            

        

        Ready_in = 0;
        
        // Display Comprehensive Test Results
        display_results();

        // Finish the test
        $finish;
    end



task display_results;
    begin
        // Display Comprehensive Test Results
        $display("\n///////////////////////////////////////////////////////////////");
        $display("//             2 Set-Interleaver Test Results                 //");
        $display("///////////////////////////////////////////////////////////////");
        $display("// Total Bits Tested   : %0d", 385);
        $display("// Errors Detected     : %0d", error_count);
        $display("// Correct Bits        : %0d", correct_count);
        if (error_count == 0)
            $display("// Test Status         : PASS");
        else
            $display("// Test Status         : FAIL");
        $display("///////////////////////////////////////////////////////////////\n");
    end
endtask




endmodule



