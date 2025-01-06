module interleaver(
    input logic clk,
    input logic rstn,
    input logic Ready_in,
    input logic Valid_in,
    input logic Data_in,
    output logic Ready_out,
    output logic Data_out,
    output logic Valid_out
);

typedef enum { Idle, WrA_Rd_B, WrB_RdA } State;
State current_state, Next_state;

logic Switch_Flag;
logic [8:0] wr_a_count, wr_b_count, rd_a_count, rd_b_count;
// logic read_ready;

logic [8:0] address_a_sig;  // Address signals
logic [8:0] address_b_sig;

logic clock_sig;

logic data_a_sig;    // Data signals
logic data_b_sig;

logic rden_a_sig;
logic rden_b_sig;
logic wren_a_sig;
logic wren_b_sig;

logic q_a_sig;       // Output data signals
logic q_b_sig;

// Declare the array to store data corresponding to DPR memory addresses
logic data_array [0:383];

always_ff @(posedge clk ) begin
    current_state <= Next_state;
end

assign clock_sig = clk;

// Next state logic
always_comb begin
    if (!rstn) begin
        Next_state = Idle;
    end else if (!Switch_Flag) begin
        Next_state = WrA_Rd_B;
    end else begin
        Next_state = WrB_RdA;
    end
end


// Sequential Logic: Counters and Switch_Flag
always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        Ready_out<=0;
        // Reset state variables
        Switch_Flag <= 0;
        wr_a_count <= 0;
        rd_a_count <= 1;
        wr_b_count <= 192;
        rd_b_count <= 192;
        Valid_out<=0;
        // Removed Valid_out and Data_out from sequential logic
    end else begin
        Ready_out<=1;
        // Counters and Switch_Flag updates
        if (Valid_in == 1) begin
            Valid_out<=1;
            if (current_state == WrA_Rd_B) begin
                wr_b_count <= 0;
                rd_a_count <= 0;
                wr_a_count <= wr_a_count + 1'b1;

                if  (Ready_in) begin
                    rd_b_count <= rd_b_count + 1'b1;
                end

                if (wr_a_count == 191) begin
                    Switch_Flag <= Switch_Flag + 1;
                end
            end else if (current_state == WrB_RdA) begin
                wr_a_count <= 0;
                rd_b_count <= 0;
                wr_b_count <= wr_b_count + 1'b1;

                if (Ready_in) begin
                    rd_a_count <= rd_a_count + 1'b1;
                end

                if (wr_b_count == 191) begin
                    Switch_Flag <= Switch_Flag + 1'b1;
                end
            end
        end else  begin
            Valid_out<=0;
        end
    end
end


// Combinational Logic: Assignments based on current_state and inputs
always_comb begin
    // Default assignments to prevent latches
    address_a_sig = 0;
    address_b_sig = 0;
    data_a_sig = 0;
    data_b_sig = 0;
    wren_a_sig = 0;
    wren_b_sig = 0;
    rden_a_sig = 0;
    rden_b_sig = 0;
    Data_out = 0;
    

    case (current_state)
        Idle: begin
            // Data_out and Valid_out remain at default values
        end

        WrA_Rd_B: begin
            // Writing scenario to buffer A
            if  (wr_a_count==192)begin
            address_a_sig=0;
            end else begin
            address_a_sig = 9'd12 * (wr_a_count % 16) + (wr_a_count / 16);
            end

            data_a_sig = Data_in;
            wren_a_sig = 1;
            wren_b_sig = 0;

            // Reading scenario from buffer B
            if (Ready_in) begin
                address_b_sig = rd_b_count + 192;
                rden_b_sig = 1;
                rden_a_sig = 0;
                Data_out = q_b_sig;
                
            end else begin
                rden_b_sig = 0;
                rden_a_sig = 0;
                Data_out = 0;
                
            end
        end

        WrB_RdA: begin
            // Writing scenario to buffer B
            address_b_sig = (9'd12 * (wr_b_count % 16) + (wr_b_count / 16)) + 192;
            data_b_sig = Data_in;
            wren_b_sig = 1;
            wren_a_sig = 0;

            // Reading scenario from buffer A
            if (Ready_in) begin
                address_a_sig = rd_a_count;
                rden_a_sig = 1;
                rden_b_sig = 0;
                
                if (rd_a_count==1)
                    Data_out = 0;
                else begin
                Data_out = q_a_sig;
                end
            end else begin
                rden_a_sig = 0;
                rden_b_sig = 0;
                Data_out = 0;
            end
        end

        default: begin
            // Default assignments if needed
        end
    endcase
end























// Instantiation of DPR memory
DPR Dpr1_inst (
    .address_a(address_a_sig),
    .address_b(address_b_sig),
    .clock(clock_sig),
    .data_a(data_a_sig),
    .data_b(data_b_sig),
    .rden_a(rden_a_sig),
    .rden_b(rden_b_sig),
    .wren_a(wren_a_sig),
    .wren_b(wren_b_sig),
    .q_a(q_a_sig),
    .q_b(q_b_sig)
);

endmodule