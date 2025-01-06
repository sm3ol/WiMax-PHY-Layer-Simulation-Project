`timescale 1ns / 1ps

module fec_tb;

    // Declare signals for the FEC module
    logic clk, clk1;
    logic reset;
    logic valid_in;
    logic ready_in;
    logic fec_in;
    logic fec_out;
    logic ready_out;
    logic valid_out;
    
    // Instantiate the FEC module
    fec uut (
        .clk(clk),
        .clk1(clk1),
        .reset(reset),
        .valid_in(valid_in),
        .ready_in(ready_in),
        .fec_in(fec_in),
        .fec_out(fec_out),
        .ready_out(ready_out),
        .valid_out(valid_out)
    );

    // Clock Generation
    always 
    begin
        #10 clk = ~clk; // clock cycle 20n (50MHz)
    end
    always 
    begin
        #5 clk1 = ~clk1; // clock cycle 10n (100MHz)
    end

    // Define the randomized data and expected encoded data (from your provided values)
    logic [95:0] randomized_data = 96'h558AC4A53A1724E163AC2BF9;

    
    
    // Convolutional Encoded Data (Expected Output, Hex):
    logic [191:0] expected_encoded_data = 192'h2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA;

    // Stimulus Generation
    initial begin
        // Initialize signals
        clk = 0;
        clk1 = 1;
        reset = 0;
        valid_in = 0;
        ready_in = 0;
        fec_in = 0;

        // Reset the FEC module
        reset = 0;
        #20;
        reset = 1;

        

        // Test case 1: Apply randomized data one bit at a time
        
        #20;
        valid_in = 1;
        ready_in = 1;

        // #20;   
             
        // Feed each bit of randomized_data serially into fec_in
        for (int i = 95; i >=0; i--) begin
            @(posedge clk);
            fec_in = randomized_data[i]; // Feed one bit at a time
            // #20; // Wait for the next clock cycle
            @(negedge clk);
        end
         
        ready_in = 0;
        valid_in=0;
        
        #100

        //$stop;
        
        valid_in = 1;
        ready_in = 1;

        for (int i = 95; i >=0; i--) begin
            @(posedge clk);
            fec_in = randomized_data[i]; // Feed one bit at a time
            // #20; // Wait for the next clock cycle
            @(negedge clk);
        end

        ready_in = 0;
        valid_in = 0;

        #100


        $display("Self-Checking Testbench: Cycle 2");
        $display("Actual:   %h", uut.fec_out_reg);
        $display("Expected: %h", expected_encoded_data);
                // Compare the internal register with the expected data
        if (uut.fec_out_reg !== expected_encoded_data) begin
            $display("ERROR: UUT output data does not match expected encoded data.");

        end else begin
            $display("PASS: UUT output data matches expected encoded data.");
        end

        valid_in = 1;
        ready_in = 1;

        for (int i = 95; i >=0; i--) begin
            @(posedge clk);
            fec_in = randomized_data[i]; // Feed one bit at a time
            // #20; // Wait for the next clock cycle
            @(negedge clk);
        end

        ready_in = 0;
        valid_in = 0;

        #100

        $display("Self-Checking Testbench: Cycle 3");
        $display("Actual:   %h", uut.fec_out_reg);
        $display("Expected: %h", expected_encoded_data);
                // Compare the internal register with the expected data
        if (uut.fec_out_reg !== expected_encoded_data) begin
            $display("ERROR: UUT output data does not match expected encoded data.");

        end else begin
            $display("PASS: UUT output data matches expected encoded data.");
        end

        //$stop;

        valid_in = 1;
        ready_in = 1;

        for (int i = 95; i >=0; i--) begin
            @(posedge clk);
            fec_in = randomized_data[i]; // Feed one bit at a time
            // #20; // Wait for the next clock cycle
            @(negedge clk);
        end

        ready_in = 0;
        valid_in = 0;

        #100
        $display("Self-Checking Testbench: Cycle 4");
        $display("Actual:   %h", uut.fec_out_reg);
        $display("Expected: %h", expected_encoded_data);
                // Compare the internal register with the expected data
        if (uut.fec_out_reg !== expected_encoded_data) begin
            $display("ERROR: UUT output data does not match expected encoded data.");

        end else begin
            $display("PASS: UUT output data matches expected encoded data.");
        end
        //$stop;


        valid_in = 1;
        ready_in = 1;

        for (int i = 95; i >=0; i--) begin
            @(posedge clk);
            fec_in = randomized_data[i]; // Feed one bit at a time
            // #20; // Wait for the next clock cycle
            @(negedge clk);
        end

        ready_in = 0;
        valid_in = 0;
        #100

        $display("Self-Checking Testbench: Cycle 5");
        $display("Actual:   %h", uut.fec_out_reg);
        $display("Expected: %h", expected_encoded_data);
        if (uut.fec_out_reg !== expected_encoded_data) begin
            $display("ERROR: UUT output data does not match expected encoded data.");

        end else begin
            $display("PASS: UUT output data matches expected encoded data.");
        end
        $stop;       
    end


endmodule
