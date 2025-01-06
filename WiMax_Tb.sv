`timescale 1ns / 1ps
import constants_pkg::*;
module WiMax_tb;

    // Declare signals for the WiMax module
    logic        clk;
    logic        rst_n;
   
    reg [95:0] data_in_ref = 96'hACBCD2114DAE1577C6DBF4C9; 

    logic inter_compare;
    logic prps_compare;
    logic fec_compare; 
    logic modulator_compare;

integer i = 0;
    // Instantiate the WiMax module
    WiMax uut (
        .rst_n(rst_n),
        .clk(clk),
        .inter_compare (inter_compare),
        .prps_compare(prps_compare),
        .fec_compare(fec_compare),
        .modulator_compare(modulator_compare)
    );

//////////////////////    // Clock Generation
    always 
    begin
        #10 clk = ~clk;  // Clock cycle 20ns (50MHz)
    end

    // Testbench Stimulus
    // Testbench Stimulus
    initial begin
        clk=0;
        #5 rst_n = 0;
        
        #40 rst_n = 1;
        
       
        
        #10096;


        $stop;
    end

  



// Task to send data with specified parameters
task send_data;

    begin
        repeat (5) begin
            #20; // Wait for 20 time units (e.g., 20ns)

            // Initialize control signals
            Valid_top = 1;
            load      = 1'b1; // Assert load
            seed      = 15'b101010001110110; // Example Seed value

            #20; // Hold load for 20 time units (1 clock cycle)

            #20; // Wait for another 20 time units

            // Apply data_in bits (MSB first)
            for (i = 0; i < 96; i = i + 1) begin
                #20; // Wait for one clock cycle per bit
            end

            // Deactivate Valid_top after sending data
            Valid_top = 0;
            #40; // Wait for 40 time units before the next repetition
        end
    end
endtask







   










endmodule
