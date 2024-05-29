`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/23 23:29:15
// Design Name: 
// Module Name: QC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module LDPC_decoder_top_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [15:0] data_in_0;
    reg [15:0] data_in_1;
    reg [15:0] data_in_2;
    reg [15:0] data_in_3;
    reg [15:0] data_in_4;
    reg [15:0] data_in_5;
    reg [15:0] data_in_6;
    reg [15:0] data_in_7;
    reg [15:0] data_in_8;
    reg [15:0] data_in_9;
    reg [15:0] data_in_10;
    reg [15:0] data_in_11;
    reg [15:0] data_in_12;
    reg [15:0] data_in_13;
    reg [15:0] data_in_14;
    reg [15:0] data_in_15;
    reg [15:0] data_in_16;
    reg [15:0] data_in_17;
    reg [15:0] data_in_18;
    reg [15:0] data_in_19;
    reg [15:0] data_in_20;
    reg [15:0] data_in_21;
    reg [15:0] data_in_22;
    reg [15:0] data_in_23;
    reg [15:0] data_in_24;
    reg [15:0] data_in_25;
    reg [15:0] data_in_26;
    reg [15:0] data_in_27;
    reg [15:0] data_in_28;
    reg [15:0] data_in_29;
    reg [15:0] data_in_30;
    reg [15:0] data_in_31;
    reg i_valid;
    reg [15:0] i_z;

    // Outputs
    wire [15:0] data_out_0;
    wire [15:0] data_out_1;
    wire [15:0] data_out_2;
    wire [15:0] data_out_3;
    wire [15:0] data_out_4;
    wire [15:0] data_out_5;
    wire [15:0] data_out_6;
    wire [15:0] data_out_7;
    wire [15:0] data_out_8;
    wire [15:0] data_out_9;
    wire [15:0] data_out_10;
    wire [15:0] data_out_11;
    wire [15:0] data_out_12;
    wire [15:0] data_out_13;
    wire [15:0] data_out_14;
    wire [15:0] data_out_15;
    wire [15:0] data_out_16;
    wire [15:0] data_out_17;
    wire [15:0] data_out_18;
    wire [15:0] data_out_19;
    wire [15:0] data_out_20;
    wire [15:0] data_out_21;
    wire [15:0] data_out_22;
    wire [15:0] data_out_23;
    wire [15:0] data_out_24;
    wire [15:0] data_out_25;
    wire [15:0] data_out_26;
    wire [15:0] data_out_27;
    wire [15:0] data_out_28;
    wire [15:0] data_out_29;
    wire [15:0] data_out_30;
    wire [15:0] data_out_31;
    wire o_valid;

    // Instantiate the Unit Under Test (UUT)
    LDPC_decoder_top uut (
        .clk(clk), 
        .rst(rst), 
        .data_in_0(data_in_0), 
        .data_in_1(data_in_1), 
        .data_in_2(data_in_2), 
        .data_in_3(data_in_3), 
        .data_in_4(data_in_4), 
        .data_in_5(data_in_5), 
        .data_in_6(data_in_6), 
        .data_in_7(data_in_7), 
        .data_in_8(data_in_8), 
        .data_in_9(data_in_9), 
        .data_in_10(data_in_10), 
        .data_in_11(data_in_11), 
        .data_in_12(data_in_12), 
        .data_in_13(data_in_13), 
        .data_in_14(data_in_14), 
        .data_in_15(data_in_15), 
        .data_in_16(data_in_16), 
        .data_in_17(data_in_17), 
        .data_in_18(data_in_18), 
        .data_in_19(data_in_19), 
        .data_in_20(data_in_20), 
        .data_in_21(data_in_21), 
        .data_in_22(data_in_22), 
        .data_in_23(data_in_23), 
        .data_in_24(data_in_24), 
        .data_in_25(data_in_25), 
        .data_in_26(data_in_26), 
        .data_in_27(data_in_27), 
        .data_in_28(data_in_28), 
        .data_in_29(data_in_29), 
        .data_in_30(data_in_30), 
        .data_in_31(data_in_31), 
        .i_valid(i_valid), 
        .i_z(i_z), 
        .data_out_0(data_out_0), 
        .data_out_1(data_out_1), 
        .data_out_2(data_out_2), 
        .data_out_3(data_out_3), 
        .data_out_4(data_out_4), 
        .data_out_5(data_out_5), 
        .data_out_6(data_out_6), 
        .data_out_7(data_out_7), 
        .data_out_8(data_out_8), 
        .data_out_9(data_out_9), 
        .data_out_10(data_out_10), 
        .data_out_11(data_out_11), 
        .data_out_12(data_out_12), 
        .data_out_13(data_out_13), 
        .data_out_14(data_out_14), 
        .data_out_15(data_out_15), 
        .data_out_16(data_out_16), 
        .data_out_17(data_out_17), 
        .data_out_18(data_out_18), 
        .data_out_19(data_out_19), 
        .data_out_20(data_out_20), 
        .data_out_21(data_out_21), 
        .data_out_22(data_out_22), 
        .data_out_23(data_out_23), 
        .data_out_24(data_out_24), 
        .data_out_25(data_out_25), 
        .data_out_26(data_out_26), 
        .data_out_27(data_out_27), 
        .data_out_28(data_out_28), 
        .data_out_29(data_out_29), 
        .data_out_30(data_out_30), 
        .data_out_31(data_out_31), 
        .o_valid(o_valid)
    );

    `ifdef SDF_FILE
    initial begin
      $sdf_annotate(`SDF_FILE, uut);
end
`endif

    // Clock generation
    always #10 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        data_in_0 = 0;
        data_in_1 = 0;
        data_in_2 = 0;
        data_in_3 = 0;
        data_in_4 = 0;
        data_in_5 = 0;
        data_in_6 = 0;
        data_in_7 = 0;
        data_in_8 = 0;
        data_in_9 = 0;
        data_in_10 = 0;
        data_in_11 = 0;
        data_in_12 = 0;
        data_in_13 = 0;
        data_in_14 = 0;
        data_in_15 = 0;
        data_in_16 = 0;
        data_in_17 = 0;
        data_in_18 = 0;
        data_in_19 = 0;
        data_in_20 = 0;
        data_in_21 = 0;
        data_in_22 = 0;
        data_in_23 = 0;
        data_in_24 = 0;
        data_in_25 = 0;
        data_in_26 = 0;
        data_in_27 = 0;
        data_in_28 = 0;
        data_in_29 = 0;
        data_in_30 = 0;
        data_in_31 = 0;
        i_valid = 0;
        i_z = 0;

        // Wait for 100 ns for global reset to finish
        #100;
        
        // Release reset
        rst = 0;

        repeat(16) begin
        // Provide input stimuli
        i_valid = 1;
        repeat (16) begin
            data_in_0 = $random;
            data_in_1 = $random;
            data_in_2 = $random;
            data_in_3 = $random;
            data_in_4 = $random;
            data_in_5 = $random;
            data_in_6 = $random;
            data_in_7 = $random;
            data_in_8 = $random;
            data_in_9 = $random;
            data_in_10 = $random;
            data_in_11 = $random;
            data_in_12 = $random;
            data_in_13 = $random;
            data_in_14 = $random;
            data_in_15 = $random;
            data_in_16 = $random;
            data_in_17 = $random;
            data_in_18 = $random;
            data_in_19 = $random;
            data_in_20 = $random;
            data_in_21 = $random;
            data_in_22 = $random;
            data_in_23 = $random;
            data_in_24 = $random;
            data_in_25 = $random;
            data_in_26 = $random;
            data_in_27 = $random;
            data_in_28 = $random;
            data_in_29 = $random;
            data_in_30 = $random;
            data_in_31 = $random;
            i_z = $random;
            #20; // Wait for 20 ns
        end
        i_valid = 0;
        data_in_0  = 0 ;
        data_in_1  = 0 ;
        data_in_2  = 0 ;
        data_in_3  = 0 ;
        data_in_4  = 0 ;
        data_in_5  = 0 ;
        data_in_6  = 0 ;
        data_in_7  = 0 ;
        data_in_8  = 0 ;
        data_in_9  = 0 ;
        data_in_10 = 0 ;
        data_in_11 = 0 ;
        data_in_12 = 0 ;
        data_in_13 = 0 ;
        data_in_14 = 0 ;
        data_in_15 = 0 ;
        data_in_16 = 0 ;
        data_in_17 = 0 ;
        data_in_18 = 0 ;
        data_in_19 = 0 ;
        data_in_20 = 0 ;
        data_in_21 = 0 ;
        data_in_22 = 0 ;
        data_in_23 = 0 ;
        data_in_24 = 0 ;
        data_in_25 = 0 ;
        data_in_26 = 0 ;
        data_in_27 = 0 ;
        data_in_28 = 0 ;
        data_in_29 = 0 ;
        data_in_30 = 0 ;
        data_in_31 = 0 ;
        i_z        = 0 ;
        // Wait for the decoder to process the input
        #35000; 
    end

    #100
        // Stop the simulation
        $stop;
    end
      

        // Monitor
    initial begin
        $monitor("At time %0t ns, i_valid = %0d, data_in_0 = %0h, o_valid = %0d, data_out_0 = %0h", $time, i_valid, data_in_0, o_valid, data_out_0);
    end



endmodule
