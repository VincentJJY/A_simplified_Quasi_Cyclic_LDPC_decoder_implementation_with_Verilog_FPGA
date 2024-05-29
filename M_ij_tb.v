`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/23 17:15:39
// Design Name: 
// Module Name: M_ij_tb
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


`timescale 1ns / 1ps

module M_ij_tb;

    // Inputs
    reg clk;
    reg rst;
    reg [15:0] data_in_o;
    reg [15:0] data_in_e;
    reg we;
    reg re;
    reg data_initial;
    reg [15:0] data_i_i;
    reg done;

    // Outputs
    wire [15:0] data_out_o;
    wire [15:0] data_out_e;
    wire [15:0] data_o_d;

    // Instantiate the Unit Under Test (UUT)
    M_ij uut (
        .clk(clk), 
        .rst(rst), 
        .data_in_o(data_in_o), 
        .data_in_e(data_in_e), 
        .we(we), 
        .re(re), 
        .data_out_o(data_out_o), 
        .data_out_e(data_out_e), 
        .data_initial(data_initial), 
        .data_i_i(data_i_i),
        .done(done),
        .data_o_d(data_o_d)
    );

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        data_in_o = 16'b0;
        data_in_e = 16'b0;
        we = 0;
        re = 0;
        data_initial = 0;
        data_i_i = 16'b0;
        done = 0;

        // Wait for the reset
        #10 rst = 0;

        // Test the data_initial functionality
        data_initial = 1;
        #10 data_i_i = 16'hAAAA;  // Load value into initial data
        #10 data_i_i = 16'hBBBB;
        #10 data_i_i = 16'hCCCC;
        #10 data_i_i = 16'hDDDD;
        #10 data_i_i = 16'hEEEE;
        #10 data_i_i = 16'hFFFF;
        #10 data_i_i = 16'h1111;
        #10 data_i_i = 16'h2222;
        #10 data_i_i = 16'h3333;
        #10 data_i_i = 16'h4444;
        #10 data_i_i = 16'h5555;
        #10 data_i_i = 16'h6666;
        #10 data_i_i = 16'h7777;
        #10 data_i_i = 16'h8888;
        #10 data_i_i = 16'h9999;
        #10 data_i_i = 16'hAAAA;
        #10 data_initial = 0;

        // Wait a few cycles
        #50;

        // Test the write functionality
        we = 1;
        data_in_o = 16'h1234;
        data_in_e = 16'h5678;
        #10 we = 0;

        // Wait a few cycles
        #50;

        // Test the read functionality
        re = 1;
        #10 re = 0;

        // Wait a few cycles
        #50;

        // Test the done functionality
        done = 1;
        #10 done = 0;

        // Wait a few cycles
        #50;

        // Test edge cases
        we = 1;
        #10 we = 0; re = 1;  // Ensure done and data_initial are not high
        #10 re = 0; data_initial = 1;
        #10 data_initial = 0; done = 1;
        #10 done = 0;

        // Add additional stimulus here
        $stop;
    end
    
    always #5 clk = ~clk;

endmodule

