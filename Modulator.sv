module Modulator(
    input clk,
    input rstn, 
    input logic Valid_in,
    input logic Data_in,
    input logic Ready_out,

    output logic Ready_in,
    output logic Valid_out,
    output logic [15:0] I,
    output logic [15:0] Q
);
    logic [1:0] Mem [95:0]; // Declare Mem as an array of 2-bit elements
    logic j;
    
    int i; 
    logic sig_valid;
    // Storing the data in the memory
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            i <= 0;
            j <= 0;
            Ready_in<=0;
        end else begin
            Ready_in<=1;
         if (Valid_in) begin

            if (  i < 96) begin
                    Mem[i][j]   <= Data_in;
                    j <= j + 1;
                    
                end else 
                    i<=0;
         end else 
             i<=0;

        if (j == 1) begin
            sig_valid <= 1;
            i <= i+1;
        end else 
            sig_valid <= 0;
    end 
    end

        

     logic [1:0] memx ;

     assign memx =  Mem [i-1];

   
    // Taking values from the array
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin 
            Valid_out <= 0;
        end else if (Ready_out) begin
        if (sig_valid) begin 
            
            case (memx)
                2'b00: begin
                    I <= 16'b0101_1010_0111_1111;
                    Q <= 16'b0101_1010_0111_1111;
                end
                2'b10: begin
                    I <= 16'b0101_1010_0111_1111;
                    Q <= 16'b1010_0101_1000_0001; // 16-bit binary of -0.707
                end
                2'b11: begin
                    I <= 16'b1010_0101_1000_0001; // 16-bit binary of -0.707
                    Q <= 16'b1010_0101_1000_0001; // 16-bit binary of -0.707
                end
                2'b01: begin
                    I <= 16'b1010_0101_1000_0001;
                    Q <= 16'b0101_1010_0111_1111;
                end
            endcase

            Valid_out <= 1;
        end end else if (! Ready_out)begin
            Valid_out <= 0;
        end
        
    end

endmodule
    