`timescale 1ns/1ps

module prbs_tb();
    // -----------------------------
    // Signal Declarations
    // -----------------------------
    logic clk;
    logic reset_n;              // Renamed from 'reset' to 'reset_n' (Active-low reset)
    logic load;
    logic Ready_in;             // Renamed from 'en' to 'Ready_in'
    logic [15:1] seed;
    logic data_in;
    logic data_out;
    logic Ready_out;            // Renamed from 'Ready' to 'Ready_out'
    logic Valid_out;            // New signal to indicate when output starts
    logic  Valid_in;
    // -----------------------------
    // Test Data Definitions
    // -----------------------------
    // Input data sequence (96 bits)
    reg [95:0] data_in_ref       = 96'hACBCD2114DAE1577C6DBF4C9;     
    // Expected output sequence (96 bits)
    reg [95:0] data_out_expected = 96'h55_8A_C4_A5_3A_17_24_E1_63_AC_2B_F9;
    
    // -----------------------------
    // Instantiate the DUT (Device Under Test)
    // -----------------------------
    prbs p1 ( 
        .clk(clk), 
        .reset_n(reset_n),         // Connected to active-low reset
        .load(load),
        .Ready_in(Ready_in),       
        .seed(seed), 
        .data_in(data_in),
        .Valid_in(Valid_in),
        .data_out(data_out), 
        .Ready_out(Ready_out), 
        .Valid_out(Valid_out) 
    );

    // -----------------------------
    // Counters for Test Results
    // -----------------------------
    int i;
    int error_count = 0;
    int correct_count = 0;
    int total_valid = 0;

    // -----------------------------
    // Clock Generation 
    // -----------------------------
    initial begin
        clk = 1'b0;
        forever begin
            #10 clk = ~clk; // 20ns clock period
        end 
    end

    // -----------------------------
    // Stimulus and Monitoring
    // -----------------------------
    initial begin
        // Initialize Inputs
        reset_n   = 1'b1;    // De-asserted (inactive)
        load      = 1'b0;
        Ready_in  = 1'b0;
        seed      = 15'b0;
        data_in   = 1'b0;
        Valid_in   =0;
        // Apply Reset (Active-Low)
        #5;                     // Wait for 5ns before asserting reset
        reset_n = 1'b0;         // Assert reset
        #40;                    // Hold reset for 40ns (2 clock cycles)
        reset_n = 1'b1;         // De-assert reset
        
        // Load the Seed
        #15;                    // Wait for 15ns after reset de-assertion
        Valid_in=1;
        load    = 1'b1;         // Assert load
        seed    = 15'b101010001110110; // Example Seed value
        #20;                    // Hold load for 20ns (1 clock cycle)
        load    = 1'b0;         // De-assert load
        
        // Enable the PRBS Generator after a short delay
        #20;
        Ready_in = 1'b1;        // Assert Ready_in to enable PRBS operation
        
        Valid_in=1;
        // Apply Data Inputs and Monitor Outputs
        for (i = 0; i < 96; i = i + 1) begin
            data_in = data_in_ref[95-i];  // Apply data_in bit (MSB first)
            #20;                           // Wait for one clock cycle
            

            check_output_validity(Valid_out, data_out, data_out_expected, i, total_valid, error_count, correct_count);

        end

        // Disable PRBS after driving all inputs
        Ready_in = 1'b0;
        Valid_in=0;
/////////////////////////////////
repeat (3) begin
    #20;                    // Wait for 15ns after reset de-assertion
        Valid_in=1;
        load    = 1'b1;         // Assert load
        seed    = 15'b101010001110110; // Example Seed value
        #20;                    // Hold load for 20ns (1 clock cycle)
        load    = 1'b0;         // De-assert load
        
        // Enable the PRBS Generator after a short delay
        #20;
        Ready_in = 1'b1;        // Assert Ready_in to enable PRBS operation
        
        Valid_in=1;
        // Apply Data Inputs and Monitor Outputs
        for (i = 0; i < 96; i = i + 1) begin
            data_in = data_in_ref[95-i];  // Apply data_in bit (MSB first)
            #20;                           // Wait for one clock cycle  
            check_output_validity(Valid_out, data_out, data_out_expected, i, total_valid, error_count, correct_count);

        end

        // Disable PRBS after driving all inputs
        Ready_in = 1'b0;
        Valid_in=0;
        


end 


///////////////////

        display_test_results(total_valid, error_count, correct_count);

        $stop;
    end


// Function to Display Comprehensive Test Results
task display_test_results(input integer total_valid, input integer error_count, input integer correct_count);
    $display("\n///////////////////////////////////////////////////////////////");
    $display("//                       PRBS Test Results                   //");
    $display("///////////////////////////////////////////////////////////////");
    $display("// No of Sets tested : 4  Total Bits per set : 96 ");
    $display("// Total Valid Outputs : %0d", total_valid);
    $display("// Errors Detected     : %0d", error_count);
    $display("// Correct Bits        : %0d", correct_count);
    if (error_count == 0)
        $display("// Test Status         : PASS");
    else
        $display("// Test Status         : FAIL");
    $display("///////////////////////////////////////////////////////////////\n");
endtask

// Task to check output validity and compare data output with expected data
task check_output_validity(input Valid_out, input [95:0] data_out, input [95:0] data_out_expected, input integer i, inout integer total_valid, inout integer error_count, inout integer correct_count);
    if (Valid_out) begin
        total_valid = total_valid + 1;
        
        // Compare data_out with the expected bit
        if (data_out !== data_out_expected[95-i]) begin
            error_count = error_count + 1;
            $display("********** ERROR at Cycle %0d **********", i+1);
            $display("  Expected data_out = %b", data_out_expected[95-i]);
            $display("  Actual   data_out = %b", data_out);
            $display("*******************************************");
        end 
        else begin
            correct_count = correct_count + 1;
        end
    end
endtask


endmodule
