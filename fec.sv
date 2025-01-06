module fec (
    input  logic          clk, //50MHz Clock
    input  logic          clk1, //100MHz
    input  logic          reset, //reset signal
    input  logic          valid_in, //randomizer signals its data is ready
    input  logic          ready_in, //interleaver says i am ready to receieve the data 
    input  logic          fec_in,
    output logic          fec_out,
    output logic          ready_out, // says to randomizer it is ready to receive
    output logic          valid_out //says to interleaver its data is delivered
);

    // Internal Signals for FSM and Error Correction
    logic [0:5] shift_reg;    // shift register
    logic x, y;                // from FEC convulation
    logic [7:0] address_a, address_b;     // RAM addresses
    // logic rden_a, rden_b, wren_a, wren_b; // RAM read/write enables
    logic q_b;   // RAM outputs
    integer index, index_for_out;
    logic [3:0] data_out;
    logic [95:0] data_in;
    logic wren_a;
    logic [191:0]  fec_out_reg;
    bit toggle;

    // RAM2P instantiation (dual-port RAM)
    RAM2P ram_inst (
        .address_a(address_a),  // location of writing 0-95 bits
        .address_b(address_b),  // location of reading 96-191 bits only needed
        .clock_a(clk),  //clock for writing
        .clock_b(clk),  //clock for reading
        .data_a(fec_in), 
        .data_b(0),  
        .rden_a(0), 
        .rden_b(1),
        .wren_a(wren_a), 
        .wren_b(0),
        .q_a(), 
        .q_b(q_b) //will use this out
    );
    
    // FSM States
    typedef enum logic [2:0] {
        IDLE = 3'b000,
        WAIT_READY = 3'b001,
        PROCESS_DATA = 3'b010,
        RESETTING_VALUES = 3'b011
    } fsm_state_t;

    fsm_state_t current_state, next_state;

    // FSM logic
    always_ff @(posedge clk or negedge reset) 
    begin
        if (!reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    //////////////////// FSM ///////////////////////

    always_comb begin        
        case (current_state)
            IDLE: 
            begin                           
                next_state = WAIT_READY;            
            end

            WAIT_READY:                                     //WAIT_READY STATE: Waiting for green light from interleaver
            begin
                if (ready_in == 1)                           
                    next_state = PROCESS_DATA;
                else
                    next_state = WAIT_READY;
            end

            PROCESS_DATA:                                   //PROCESS_DATA STATE: Green light from interleaver has arrived and fec ready for data
            begin
                if(index == 0) 
                begin
                    next_state = RESETTING_VALUES;          
                end 
                else 
                begin
                    next_state = PROCESS_DATA;
                end
            end

            RESETTING_VALUES:                               //RESETTING_VALUES STATE: Resetting counters & flags
            begin
            begin
                next_state = WAIT_READY;
            end
            end
            default: next_state = IDLE;
        endcase
    end

    //////////////////// FSM ///////////////////////

always_ff@(posedge clk or negedge reset) 
begin
    if(!reset) 
    begin
        shift_reg <=            'b100111;
        data_out <=             4'b0;
        fec_out_reg <=          192'b0;
        index <=                96;
        index_for_out <=        192;
        ready_out <=            0;
        address_a <=            95;     
    end 
    else 
    begin
        if (current_state == PROCESS_DATA) 
        begin
            if(index == 0)
            begin
                ready_out <= 0;
            end
            else
            begin
                ready_out <= 1;
            end
            
            if((q_b == 0 || q_b == 1) && index > 0 && valid_in)
            begin
                shift_reg <= {q_b, shift_reg[0:4]};
            end
            if(index %2 == 0) 
            begin
                data_out[3:2]           <= {x, y};
                fec_out_reg[index_for_out + 0] <= data_out[0];
                fec_out_reg[index_for_out + 1] <= data_out[1];
                fec_out_reg[index_for_out + 2] <= data_out[2];
                fec_out_reg[index_for_out + 3] <= data_out[3];
            end 
            else if(index %2 == 1 || index == -1)
            begin
                data_out[1:0]           <= {x, y};
                index_for_out           <= index_for_out -4;
            end

            if(index != 0 && valid_in)
            begin
                address_a <= address_a - 1;
            end
            if(valid_in)
            begin
                index <= index - 1;
            end
        end
        else if (current_state == RESETTING_VALUES) 
        begin
            index <=            96; 
            index_for_out <=    192;
            ready_out <=        0;
            if(address_a > 191)
            begin
                address_a <= 191;
            end
        end
    end
end

always_ff@(negedge clk or negedge reset) 
begin
    if(!reset) 
    begin
        address_b <=            191;
        wren_a <=               0;
    end 
    else
    begin
        if(current_state == PROCESS_DATA)
        begin
            if(index > 0)
            begin
                data_in <= {data_in[95:0], q_b};
            end
        
            x <= q_b ^ shift_reg[0] ^ shift_reg[1] ^ shift_reg[2] ^ shift_reg[5];
            y <= q_b ^ shift_reg[1] ^ shift_reg[2] ^ shift_reg[4] ^ shift_reg[5];
            
            if(index != 0 && valid_in)
            begin
                address_b <= address_b - 1;
            end
            
            if(index <= 0 || !valid_in)
            begin
                wren_a <= 0;
            end
            else
            begin
                wren_a <= 1;
            end
        end   
        else if (current_state == RESETTING_VALUES) 
        begin
            if(address_b > 192)
            begin
                address_b <= 191;
            end
        end
    end
end

always_ff@(posedge clk1 or negedge reset) 
begin
    if(!reset)
    begin
        toggle <=               0;
    end
    else
    begin
        if (current_state == PROCESS_DATA) 
        begin
            if(!toggle)
            begin
                fec_out <= y;
                toggle =~ toggle;
            end
            else
            begin
                fec_out <= x;
                toggle =~ toggle;
            end
        end
    end
end

always_ff@(posedge clk1 or negedge reset) 
begin
    if(!reset)
    begin   
        valid_out <= 0;
    end
    else
    begin
        if (current_state == PROCESS_DATA && index < 96 && index > 0 && (x == 1 || x == 0) && (y == 1 || y == 0))
        begin
            valid_out <= 1;
        end
        else
            valid_out <= 0;
    end
end
endmodule