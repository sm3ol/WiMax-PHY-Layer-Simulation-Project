
module prbs(
    input  logic        clk,
    input  logic        reset_n,     // Active-low reset
    input  logic        load,
    input  logic        Ready_in,    // Renamed from 'en' to 'Ready_in'
    input  logic [15:1] seed,
    input  logic        data_in,
    input  logic        Valid_in,
    output logic        data_out,
    output logic        Ready_out,   // Renamed from 'Ready' to 'Ready_out'
    output logic        Valid_out    // New signal to indicate when output starts
);

    // Internal signals
    logic XOR_1out;
    logic [15:1] ireg;       // Initialized register
    logic [15:1] nextreg;
    logic data_out_reg;      // Registered version of data_out
    logic valid_out_reg;     // Registered version of Valid_out

    // Synchronous logic with active-low reset
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Reset all registers
            ireg          <= 'b0;      // Clear internal register
            Ready_out     <= 1'b0;     // Ready_out is low during reset
            data_out_reg  <= 1'b0;     // Clear data_out
            valid_out_reg <= 1'b0;     // Clear Valid_out
        end
        else begin
            // `Ready_out` remains high when not in reset
            Ready_out <= 1'b1;

            if (load) begin
                // Load seed into internal register
                ireg          <= seed;
            end
            else if (Ready_in) begin
                // Update internal register only when Ready_in is high
                ireg          <= nextreg; // Shift register
                valid_out_reg <= 1'b1;    // Assert Valid_out when Ready_in is active
            end
            else begin
              
                 valid_out_reg <= 1'b0;
            end

            // Update the registered data_out only when Ready_in is high or during load
            if (load || Ready_in) begin
                data_out_reg  <= XOR_1out ^ data_in;
            end
            // Else, keep data_out_reg unchanged
        end   
    end

    // Combinational assignments
    assign XOR_1out  = ireg[14] ^ ireg[15];
    assign data_out  = data_out_reg;
    assign nextreg   = {ireg[14:1], XOR_1out};
    assign Valid_out = valid_out_reg; // Assign the registered Valid_out

endmodule
