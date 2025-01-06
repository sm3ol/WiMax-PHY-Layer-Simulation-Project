module Modulator_tb;

    // Inputs
    logic clk;
    logic rstn;
    logic Valid_in;
    logic Data_in;
    logic Ready_out=0;



    // Outputs
    logic Valid_out;
    logic [15:0] I;
    logic [15:0] Q;
    logic Ready_in;
    // Instantiate the Modulator
    
    integer Error_count=0;
    integer Correct_count=0;


    Modulator uut (
        .clk(clk),
        .rstn(rstn),
        .Valid_in(Valid_in),
        .Ready_in(Ready_in),
        .Ready_out(Ready_out),
        .Data_in(Data_in),
        .Valid_out(Valid_out),
        .I(I),
        .Q(Q)
    );

    // ROM for input data (from in_data_rom)
    logic [191:0] in_data_rom = 192'h4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E;

    // Constants for Q15 format values
    const logic [15:0] POS_707 = 16'b0101_1010_0111_1111;  // 0.707
    const logic [15:0] NEG_707 = 16'b1010_0101_1000_0001;  // -0.707


// Expected output sequence
const logic [15:0] expected_outputs[] = '{
    POS_707,NEG_707,
    POS_707,POS_707,
    NEG_707,POS_707,
    NEG_707,NEG_707,
    POS_707,POS_707,
    POS_707,POS_707,
    POS_707,NEG_707,
    POS_707,POS_707,
    POS_707,NEG_707,
    NEG_707,NEG_707,
    NEG_707,NEG_707,
    POS_707,NEG_707,
    NEG_707,NEG_707,
    NEG_707,NEG_707,
    NEG_707,POS_707,
    NEG_707,POS_707,
    POS_707,NEG_707,
    POS_707,POS_707,
    POS_707,POS_707,
    NEG_707,POS_707,
    NEG_707,NEG_707,
    NEG_707,NEG_707,
    POS_707,POS_707,
    NEG_707,POS_707,
    NEG_707,POS_707,
    NEG_707,POS_707,
    POS_707,NEG_707,
    POS_707,NEG_707,
    NEG_707,NEG_707,
    POS_707,NEG_707,
    POS_707,NEG_707,
    POS_707,NEG_707,
    NEG_707,NEG_707,
    NEG_707,NEG_707,
    POS_707,NEG_707,
    NEG_707,POS_707,
    POS_707,POS_707,
    POS_707,NEG_707,
    NEG_707,NEG_707,
    POS_707,POS_707,
    POS_707,POS_707,
    POS_707,POS_707,
    POS_707,POS_707,
    NEG_707,POS_707,
    POS_707,POS_707,
    POS_707,NEG_707,
    NEG_707,POS_707,
    NEG_707,POS_707,
    POS_707,NEG_707,
    POS_707,NEG_707,
    NEG_707,POS_707,
    POS_707,POS_707,
    POS_707,NEG_707,
    POS_707,NEG_707,
    POS_707,POS_707,
    POS_707,NEG_707,
    NEG_707,NEG_707,
    NEG_707,POS_707,
    NEG_707,POS_707,
    POS_707,NEG_707,
    NEG_707,POS_707,
    NEG_707,POS_707,
    POS_707,POS_707,
    NEG_707,NEG_707,
    POS_707,POS_707,
    POS_707,POS_707,
    NEG_707,POS_707,
    POS_707,NEG_707,
    NEG_707,POS_707,
    NEG_707,POS_707,
    POS_707,POS_707,
    NEG_707,POS_707,
    POS_707,NEG_707,
    POS_707,POS_707,
    NEG_707,NEG_707,
    NEG_707,NEG_707,
    NEG_707,NEG_707,
    POS_707,NEG_707,
    POS_707,NEG_707,
    POS_707,NEG_707,
    NEG_707,POS_707,
    POS_707,POS_707,
    POS_707,POS_707,
    POS_707,POS_707,
    NEG_707,POS_707,
    POS_707,POS_707,
    POS_707,NEG_707,
    NEG_707,POS_707,
    NEG_707,POS_707,
    NEG_707,NEG_707,
    NEG_707,NEG_707,
    POS_707,NEG_707,
    POS_707,POS_707,
    POS_707,NEG_707,
    NEG_707,NEG_707,
    NEG_707,POS_707
};




    integer i = 0; // To index in the expected outputs
    integer j = 0;
    integer k=0;
    integer z =0;
    integer bit_index = 191; // Index for bits in in_data_rom
    // Clock generation
    always begin
        clk = 1;
        forever #5 clk = ~clk;
    end








    // Test procedure
    initial begin
        // Initialize inputs
        rstn = 0;
        Valid_in = 0;
        Data_in = 0;

        // Reset the design
        #10 rstn = 1;

        // Apply stimulus from in_data_rom and compare output to expected values
        #10 Valid_in = 1;
        Ready_out =1;

              // Loop through bits in in_data_rom and expected_outputs
        for (i = 0; i < expected_outputs.size(); i = i + 1) begin
            Data_in = in_data_rom[bit_index];
            bit_index = bit_index - 1;
        
            @(posedge clk);        // Wait one clock cycle


        end

        // set input , Block 2
        data_input();
       
        // set input , Block 2
        data_input();

        #20;

        display_test_results();


        $finish;
 
          end

    // test for the first set of inputs 
    initial begin

            #50;

            check_outputs(); 
    end

        // test for the second set of ouputs 
    initial begin
         // wait till the beaging of the 3rd set

            #1980;
            check_outputs();
    end

    // test for the third test of outputs 
    initial begin
            // wait till the beaging of the 3rd set
            #3910;
        check_outputs();
           
    end







// task to  drive the input 
task data_input;
   
    begin
        Valid_in = 0;
        #10;
        bit_index = 191; 
        Valid_in = 1;

        // Wait for some time
        #10;

        // Loop through bits in in_data_rom and expected_outputs
        for (i = 0; i < expected_outputs.size(); i = i + 1) begin
            Data_in = in_data_rom[bit_index];
            bit_index = bit_index - 1;
        
            @(posedge clk); // Wait for one clock cycle
        end
    end
endtask



// task for result display 
task display_test_results;
    begin
        // Display Comprehensive Test Results
        $display("\n///////////////////////////////////////////////////////////////");
        $display("//                   Modulator Test Results                   //");
        $display("///////////////////////////////////////////////////////////////");
        $display("// no sets for streaming  : %0d", 3);
        $display("// Total Bits Tested      : %0d", 288);
        $display("// Errors Detected        : %0d", Error_count);
        $display("// Correct Bits           : %0d", Correct_count);
        if (Error_count == 0)
            $display("// Test Status         : PASS");
        else
            $display("// Test Status         : FAIL");
        $display("///////////////////////////////////////////////////////////////\n");
    end
endtask

// task for cheking the outputs 
task check_outputs;
    begin
        for (j = 0; j < expected_outputs.size(); j = j + 2) begin
            if (I !== expected_outputs[j] || Q !== expected_outputs[j + 1]) begin
                $display("Mismatch at index %0d: Expected I=%16b Q=%16b, Got I=%16b Q=%16b",
                         j, expected_outputs[j], expected_outputs[j + 1], I, Q);
                Error_count = Error_count + 1;
            end else begin
                $display("Match at index %0d: I=%h, Q=%h", j, I, Q);
                Correct_count = Correct_count + 1;
            end
            #20; // delay to simulate time between checks
        end
    end
endtask




endmodule