package constants_pkg;



    // Declare signals for the WiMax module
    logic        clk;
    logic        clk1;
    logic        rst_n;
    logic        load;
    logic [15:1] seed;
    logic        Valid_top;
    logic        datain;
    logic        ready_mod;
    
    logic [15:0] I_top;
    logic [15:0] Q_top;
    logic        Valid_out_top;
    reg [95:0] data_in_ref = 96'hACBCD2114DAE1577C6DBF4C9; 
    
   
 integer i = 0;
    integer j;
 
    integer Error_count=0;
    integer Correct_count=0;



 // Constants for Q15 format values
    const logic [15:0] POS_VALU = 16'b0101_1010_0111_1111;  // 0.707
    const logic [15:0] NEG_VALU = 16'b1010_0101_1000_0001;  // -0.707


// Expected output sequence
const logic [15:0] expected_outputs[] = '{
    POS_VALU,NEG_VALU,
    POS_VALU,POS_VALU,
    NEG_VALU,POS_VALU,
    NEG_VALU,NEG_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,NEG_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,NEG_VALU,
    NEG_VALU,NEG_VALU,
    NEG_VALU,NEG_VALU,
    POS_VALU,NEG_VALU,
    NEG_VALU,NEG_VALU,
    NEG_VALU,NEG_VALU,
    NEG_VALU,POS_VALU,
    NEG_VALU,POS_VALU,
    POS_VALU,NEG_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,POS_VALU,
    NEG_VALU,POS_VALU,
    NEG_VALU,NEG_VALU,
    NEG_VALU,NEG_VALU,
    POS_VALU,POS_VALU,
    NEG_VALU,POS_VALU,
    NEG_VALU,POS_VALU,
    NEG_VALU,POS_VALU,
    POS_VALU,NEG_VALU,
    POS_VALU,NEG_VALU,
    NEG_VALU,NEG_VALU,
    POS_VALU,NEG_VALU,
    POS_VALU,NEG_VALU,
    POS_VALU,NEG_VALU,
    NEG_VALU,NEG_VALU,
    NEG_VALU,NEG_VALU,
    POS_VALU,NEG_VALU,
    NEG_VALU,POS_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,NEG_VALU,
    NEG_VALU,NEG_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,POS_VALU,
    NEG_VALU,POS_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,NEG_VALU,
    NEG_VALU,POS_VALU,
    NEG_VALU,POS_VALU,
    POS_VALU,NEG_VALU,
    POS_VALU,NEG_VALU,
    NEG_VALU,POS_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,NEG_VALU,
    POS_VALU,NEG_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,NEG_VALU,
    NEG_VALU,NEG_VALU,
    NEG_VALU,POS_VALU,
    NEG_VALU,POS_VALU,
    POS_VALU,NEG_VALU,
    NEG_VALU,POS_VALU,
    NEG_VALU,POS_VALU,
    POS_VALU,POS_VALU,
    NEG_VALU,NEG_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,POS_VALU,
    NEG_VALU,POS_VALU,
    POS_VALU,NEG_VALU,
    NEG_VALU,POS_VALU,
    NEG_VALU,POS_VALU,
    POS_VALU,POS_VALU,
    NEG_VALU,POS_VALU,
    POS_VALU,NEG_VALU,
    POS_VALU,POS_VALU,
    NEG_VALU,NEG_VALU,
    NEG_VALU,NEG_VALU,
    NEG_VALU,NEG_VALU,
    POS_VALU,NEG_VALU,
    POS_VALU,NEG_VALU,
    POS_VALU,NEG_VALU,
    NEG_VALU,POS_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,POS_VALU,
    NEG_VALU,POS_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,NEG_VALU,
    NEG_VALU,POS_VALU,
    NEG_VALU,POS_VALU,
    NEG_VALU,NEG_VALU,
    NEG_VALU,NEG_VALU,
    POS_VALU,NEG_VALU,
    POS_VALU,POS_VALU,
    POS_VALU,NEG_VALU,
    NEG_VALU,NEG_VALU,
    NEG_VALU,POS_VALU
};




endpackage 