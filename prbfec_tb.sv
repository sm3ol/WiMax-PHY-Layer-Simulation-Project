`timescale 1ns / 1ps

module prbfec_tb;

    // Declare signals for the FEC module
    logic        clk;
    logic        clk1;
    logic        reset_n;
    logic        load;
    logic [15:1] seed;
    logic        prbs_data_in;
    logic        prbs_Valid_in;
    logic        fec_out;
    logic        fec_ready_out;
    logic        fec_valid_out;

    reg [95:0] data_in_ref = 96'hACBCD2114DAE1577C6DBF4C9;     
    int i;
    
    // Instantiate the FEC module
    prbsfec uut (
        .clk(clk), 
        .clk1(clk1),
        .reset_n(reset_n),
        .load(load),
        .seed(seed),
        .prbs_data_in(prbs_data_in),
        .prbs_Valid_in(prbs_Valid_in),
        .fec_out(fec_out),
        .fec_ready_out(fec_ready_out),
        .fec_valid_out(fec_valid_out)
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
;
    
    
    // Convolutional Encoded Data (Expected Output, Hex):
    logic [191:0] expected_encoded_data = 192'h2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA;

    // Stimulus Generation
    initial 
    begin
        // Initialize Inputs
        clk = 0;
        clk1 = 1;
        reset_n   = 1'b1;    // De-asserted (inactive)
        load      = 1'b0;
        seed      = 15'b0;
        prbs_data_in   = 1'b0;
        prbs_Valid_in   =0;
        // Apply Reset (Active-Low)
        #5;                     // Wait for 5ns before asserting reset
        reset_n = 1'b0;         // Assert reset
        #40;                    // Hold reset for 40ns (2 clock cycles)
        reset_n = 1'b1;         // De-assert reset
        
        // Load the Seed

        
        repeat(6)
        begin
            #20;                    // Wait for 15ns after reset de-assertion
            prbs_Valid_in = 1;
            load =          1'b1;         // Assert load
            seed =          15'b101010001110110; // Example Seed value
            #20;                    // Hold load for 20ns (1 clock cycle)
            load =          1'b0;         // De-assert load
            #20;

            for (i = 0; i < 96; i = i + 1) 
            begin
                prbs_data_in = data_in_ref[95-i];  // Apply data_in bit (MSB first)
                #20;                           // Wait for one clock cycle
            end
            prbs_Valid_in=0;
            #40;
        end
        $stop;
    end
endmodule
