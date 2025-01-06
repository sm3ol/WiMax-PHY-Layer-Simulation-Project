module WiMax(
    // Input declarations
    input logic rst_n,
    input logic clk,
    
    // Output declarations
    output logic inter_compare,
    output logic prps_compare,
    output logic fec_compare, 
    output  logic modulator_compare
   
);
    logic [15:0] I_top;
    logic [15:0] Q_top;
   
    logic ready_in;
    logic load_int; 
    logic [15:1] seed;
    logic Valid_top_int;

    logic data_in;
    PLL pll_inst(
        .refclk(clk),           //  refclk.clk
		.rst(reset_n),          //  reset.reset
		.outclk_0(clk50),       //  outclk0.clk
		.outclk_1(clk100),      //  outclk1.clk
		.locked()        //  locked.export
    );

    // Intermediate signals
    logic fec_out;
    logic fec_ready_out;
    logic fec_valid_out;
    logic inter_in;
    logic inter_valid;
    logic temp, validtemp, validtempsync;
    
    integer fec_counter, inter_counter, modulator_counter,i;
    logic [9:0] ii;
    logic [6:0] input_counter;
    
    // Input data 
    reg [95:0] data_in_ref = 96'hACBCD2114DAE1577C6DBF4C9; 

    // prbs expected data output  
    reg [95:0] Prps_data_out_expected = 96'h55_8A_C4_A5_3A_17_24_E1_63_AC_2B_F9;
    
    // expected encoded output 
    logic [191:0] expected_encoded_data = 192'h2833E48D392026D5B6DC5E4AF47ADD29494B6C89151348CA;

    // interleaver expected output 
    logic [191:0] inter_expected_output = 192'h4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E;

    // modulator expected output 
    logic  [191:0]mod_expected_outputs = 192'h4B047DFA42F2A5D5F61C021A5851E9A309A24FD58086BD1E;


    // Instantiate the prbsfec module
    prbsfec prbsfec_inst (
        .clk(clk50), 
        .clk1(clk100),            // Assuming clk1 is same as clk; if different, connect as needed
        .reset_n(rst_n),
        .load(load_int ),      // You can adjust the load signal as necessary
        .seed(seed),    // You can modify this depending on how you want to use the input data
        .prbs_data_in(data_in ),
        .prbs_Valid_in(Valid_top_int),
        .fec_out(fec_out),
        .fec_ready_out(fec_ready_out),
        .fec_valid_out(fec_valid_out),
        .pr_out (pr_out),
        .pr_val (pr_val)
    );

// temp Handling
    always_ff @( negedge clk100 or negedge rst_n) begin
        if (!rst_n) begin
            temp<= 0;
        end 
        else if (fec_valid_out||inter_valid) begin
            temp<= fec_out;
        end 
        else  begin
            temp<=0;
        end
    end 


// Data_in Handling
    always_ff @( posedge clk100 or negedge rst_n) begin
        if (!rst_n) begin
            inter_in<= 0;
        end 
        else if (inter_valid) begin
            inter_in<= temp;
        end 
        else  begin
            inter_in <=0;
        end
    end 
// Valid Handling
    always_comb 
    begin
        if (!rst_n) 
        begin
            validtemp =0;
        end 
        else
        begin
            if (fec_valid_out) 
            begin
                validtemp = 1;
            end 
            else 
            begin
                validtemp = 0;
            end 
        end    
    end 

    always_ff @(posedge clk100 or negedge rst_n) begin
        if (!rst_n) begin
            validtempsync  <=0;
        end else if (fec_valid_out) begin
            validtempsync <= 1;
        end else if (!fec_ready_out) begin
            validtempsync <=0;
        end 
    end

    assign inter_valid = (validtemp||validtempsync);
    
    // Instantiate the Top module
    Top top_inst (
        .rst_n(rst_n),
        .clk(clk100),
        .Valid_top(inter_valid),    // Connect the valid output from prbsfec
        .datain(inter_in),             // Connect fec_out from prbsfec to datain of Top
        .ready_mod(ready_in),
        .I_top(I_top),
        .Q_top(Q_top),
        .Valid_out_top(Valid_out_top),
        .inter_out(inter_out),
        .inter_valid(inter_validd)

    );


    
    always_ff @ (posedge clk or negedge rst_n) begin 
        if ( ! rst_n )begin 
            prps_compare<= 0;
            i<=0; 
        end else if (pr_val && i < 96 ) begin
            if ( pr_out== Prps_data_out_expected[95-i]) begin
                prps_compare<=1;
                i=i+1;
            end 
            else begin 
                prps_compare<=0;
                i=i+1;
            end 
        end 
    end 

    always_ff @ (posedge clk100 or negedge rst_n) begin 
        if ( ! rst_n )begin 
            fec_compare<= 0;
            fec_counter<=1;
        end else if (fec_valid_out && ii > 200 ) begin
            if (fec_out == expected_encoded_data[191-fec_counter] ) begin
                fec_compare<=1;
                fec_counter<=fec_counter+1;
            end else begin
                fec_compare<=0;
                fec_counter<=1;
        end 
        end else begin 
            fec_counter<=1;
        end 
    end 
    
    always_ff@(posedge clk100 or negedge rst_n) 
    begin
        if (!rst_n)
            ii <= 0;
        else if(ii < 12'h3f2)
            ii <= ii + 1;
    end 



    always_ff @ (posedge clk100 or negedge rst_n) begin 
        if ( ! rst_n )begin 
            inter_compare<= 0;
            inter_counter<=0;
        end else if (inter_validd && ii > 412 ) begin
            if (inter_out == inter_expected_output[191-inter_counter] ) begin
                inter_compare<=1; 
                inter_counter<=inter_counter+1;
            end else begin
                inter_compare<=0;
                inter_counter<=0;
            end 
        end else begin 
            inter_counter<=0;
        end 
    end 
 


always_ff @ (posedge clk50 or negedge rst_n) 
begin 
    if ( ! rst_n )
    begin 
        modulator_compare<= 0;
        modulator_counter<=0;
    end 
    else if (Valid_out_top && ii > 415 ) 
    begin
        if(modulator_counter % 2 == 0)
        begin
            if(I_top[15] == mod_expected_outputs[modulator_counter])
            begin
                modulator_compare <= 1; 
                modulator_counter <= modulator_counter + 1;
            end
        end
        else
        begin
            if(Q_top[15] == mod_expected_outputs[modulator_counter])
            begin
                modulator_compare<=1; 
                modulator_counter<=modulator_counter + 1;
            end
        end
    end 
    else 
    begin 
        modulator_counter <= 0;
    end 
end 


    // // load dirve 
    // always_ff @(negedge clk100 or negedge rst_n ) begin
    //     if (!rst_n)begin
    //         load_int <=0;
    //     end else 
    //     begin
    //         if (ii == 2 || ii == 204 || ii == 406 || ii == 608 || ii == 810 )
    //         begin
    //             load_int <=1;
    //         end 
    //         else if (ii == 5|| ii == 206||ii == 408||ii == 610||ii == 812 ) begin
    //             load_int <=0;
    //         end
    //     end 
    // end 


    //  // Valid top dirve 
    // always_ff @(negedge clk100 or negedge rst_n ) begin
    //     if (!rst_n)begin
    //         Valid_top_int <=0;
    //     end else 
    //     begin
    //         if (ii == 2 || ii == 204 || ii == 406 || ii == 608 || ii == 810 )
    //         begin
    //             Valid_top_int <=1;
    //         end 
    //         else if (ii== 198 || ii== 400||ii== 602||ii== 804||ii== 1006 ) begin
    //             Valid_top_int <=0;
    //         end
    //     end 

    // end 


// load drive 
always_ff @(negedge clk100 or negedge rst_n) begin
    if (!rst_n) begin
        load_int <= 0;
    end else begin
        case (ii)
            2, 204, 406, 608, 810: load_int <= 1;
            5, 206, 408, 610, 812: load_int <= 0;
            default: load_int <= load_int; // Maintain current state for other values
        endcase
    end
end

// Valid top drive 
always_ff @(negedge clk100 or negedge rst_n) begin
    if (!rst_n) begin
        Valid_top_int <= 0;
    end else begin
        case (ii)
            2, 204, 406, 608, 810: Valid_top_int <= 1;
            198, 400, 602, 804, 1006: Valid_top_int <= 0;
            default: Valid_top_int <= Valid_top_int; // Maintain current state for other values
        endcase
    end
end


    always_ff @(negedge clk100 or negedge rst_n) begin
    if (!rst_n) begin
        data_in <= 0;
    end else begin
        case (1'b1) // Use a case with true conditions for ranges
            (ii >= 6 && ii <= 198): begin
                data_in <= data_in_ref[95 - input_counter];
            end
            (ii >= 208 && ii <= 400): begin
                data_in <= data_in_ref[95 - input_counter];
            end
            (ii >= 410 && ii <= 602): begin
                data_in <= data_in_ref[95 - input_counter];
            end
            (ii >= 612 && ii <= 804): begin
                data_in <= data_in_ref[95 - input_counter];
            end
            (ii >= 814 && ii <= 1006): begin
                data_in <= data_in_ref[95 - input_counter];
            end
            default: begin
                data_in <= 0;
            end
        endcase
    end
end

logic [9:0] ii_ranges; 

always_ff @(posedge clk50 or negedge rst_n) begin
    if (!rst_n) begin
        ii_ranges <= 10'b0;
    end else begin
        ii_ranges[0] <= (ii >= 6   && ii <= 198);
        ii_ranges[1] <= (ii >= 208 && ii <= 400);
        ii_ranges[2] <= (ii >= 410 && ii <= 602);
        ii_ranges[3] <= (ii >= 612 && ii <= 804);
        ii_ranges[4] <= (ii >= 814 && ii <= 1006);
    end
end

always_ff @(negedge clk50 or negedge rst_n) begin
    if (!rst_n) begin
        input_counter <= 0;
    end else begin
        if (|ii_ranges[4:0]) begin // Check if any range is valid
            input_counter <= input_counter + 1;
        end else begin
            input_counter <= 0;
        end
    end
end


    // input counter
    // always_ff @( negedge clk50 or negedge rst_n)begin
    //     if (!rst_n) begin
    //         input_counter<=0;
    //     end else begin
    //            case (1'b1) // Use a case with true conditions for ranges
    //     (ii >= 6 && ii <= 198): begin
    //         input_counter = input_counter + 1;
    //     end
    //     (ii >= 208 && ii <= 400): begin
    //         input_counter = input_counter + 1;
    //     end
    //     (ii >= 410 && ii <= 602): begin
    //         input_counter = input_counter + 1;
    //     end
    //     (ii >= 612 && ii <= 804): begin
    //         input_counter = input_counter + 1;
    //     end
    //     (ii >= 814 && ii <= 1006): begin
    //         input_counter = input_counter + 1;
    //     end
    //     default: begin
    //         input_counter = 0;
    //     end
    // endcase
    // end 

    //end
    


     // ready_in dirve 
    always_ff @(posedge clk100 or negedge rst_n ) begin
        if (!rst_n)begin
            ready_in <=0;
        end else 
        begin
            if (ii == 414 || ii == 617 )
            begin
                ready_in <=1;
            end 
            else if (ii== 608 ) begin
                ready_in <=0;
            end
        end 

    end 




    //seed dirve 
    always_ff @(posedge clk100 or negedge rst_n ) begin
      
            if(!rst_n )
            begin
                seed= 15'b000000000000000;
            end 
            else 
            begin
                if (ii<2) 
                begin
                    seed= 15'b000000000000000;
                end 
                else 
                begin
                    seed=15'b101010001110110;
                end 
            end 
    end
    


endmodule
