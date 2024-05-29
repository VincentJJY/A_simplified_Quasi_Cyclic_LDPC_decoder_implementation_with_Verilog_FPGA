`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/19 21:53:23
// Design Name: 
// Module Name: VariableNodeProcessingUnit
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
//delay : 2 cycles

module VariableNodeProcessingUnit ( 
    input        clk, 
    input        rst,                         
    input  [15:0] I1 ,            
    input  [15:0] I2 ,            
    input  [15:0] I3 ,            
    input  [15:0] I4 ,            
    input  [15:0] Z  ,            
    output [15:0] L1 ,            
    output [15:0] L2 ,            
    output [15:0] L3 ,            
    output [15:0] L4 ,            
    output       C                
);

    wire [15:0] lut_b_out1 ;
    wire [15:0] lut_b_out2 ; 
    wire [15:0] lut_b_out3 ; 
    wire [15:0] lut_b_out4 ;
    reg  [15:0] stage1_out1; 
    reg  [15:0] stage1_out2; 
    reg  [15:0] stage1_out3; 
    reg  [15:0] stage1_out4;
    reg  [15:0] Z1         ;
    reg  [15:0] stage2_out1;
    reg  [15:0] stage2_out2; 
    reg  [15:0] stage2_out3; 
    reg  [15:0] stage2_out4;
    reg         r_c        ;

    //to delay 2 more cycles
    reg  [15:0] stage2_out1_1d;
    reg  [15:0] stage2_out2_1d; 
    reg  [15:0] stage2_out3_1d; 
    reg  [15:0] stage2_out4_1d;
    reg         r_c_1d        ;
    reg  [15:0] stage2_out1_2d;
    reg  [15:0] stage2_out2_2d; 
    reg  [15:0] stage2_out3_2d; 
    reg  [15:0] stage2_out4_2d;
    reg         r_c_2d        ;

    //to delay 3 more cycles
    reg  [15:0] stage2_out1_3d;
    reg  [15:0] stage2_out2_3d; 
    reg  [15:0] stage2_out3_3d; 
    reg  [15:0] stage2_out4_3d;
    reg         r_c_3d        ;


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_out1 <= 16'b0;
            stage1_out2 <= 16'b0;
            stage1_out3 <= 16'b0;
            stage1_out4 <= 16'b0;
            Z1          <= 16'b0;
        end else begin
            stage1_out1 <= I1;
            stage1_out2 <= I2;
            stage1_out3 <= I3;
            stage1_out4 <= I4;
            Z1          <= ~Z+1;
        end
    end

LUT_A lut_b1 (  .x(stage1_out1), 
                .phi_x(lut_b_out1)
    );

LUT_A lut_b2 (  .x(stage1_out2), 
                .phi_x(lut_b_out2)
    );

LUT_A lut_b3 (  .x(stage1_out3), 
                .phi_x(lut_b_out3)
    );

LUT_A lut_b4 (  .x(stage1_out4), 
                .phi_x(lut_b_out4)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage2_out1 <= 16'b0;
            stage2_out2 <= 16'b0;
            stage2_out3 <= 16'b0;
            stage2_out4 <= 16'b0;
            r_c         <= 1'b0;
        end else begin
            stage2_out1 <= lut_b_out1 + Z1;
            stage2_out2 <= lut_b_out2 + Z1;
            stage2_out3 <= lut_b_out3 + Z1;
            stage2_out4 <= lut_b_out4 + Z1;
            r_c         <= Z1[15]         ;
        end
    end

    //1 cycle delay
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage2_out1_1d <= 16'b0;
            stage2_out2_1d <= 16'b0;
            stage2_out3_1d <= 16'b0;
            stage2_out4_1d <= 16'b0;
            r_c_1d         <= 1'b0;
        end else begin
            stage2_out1_1d <= stage2_out1;
            stage2_out2_1d <= stage2_out2;
            stage2_out3_1d <= stage2_out3;
            stage2_out4_1d <= stage2_out4;
            r_c_1d         <= r_c        ;
        end
    end

        //2 cycle delay
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage2_out1_3d  <= 16'b0;
            stage2_out2_3d  <= 16'b0;
            stage2_out3_3d  <= 16'b0;
            stage2_out4_3d  <= 16'b0;
            r_c_3d          <= 1'b0;
        end else begin
            stage2_out1_3d  <= stage2_out1_1d ;
            stage2_out2_3d  <= stage2_out2_1d ;
            stage2_out3_3d  <= stage2_out3_1d ;
            stage2_out4_3d  <= stage2_out4_1d ;
            r_c_3d          <= r_c_1d         ;
        end
    end

    //2 cycle delay
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage2_out1_2d  <= 16'b0;
            stage2_out2_2d  <= 16'b0;
            stage2_out3_2d  <= 16'b0;
            stage2_out4_2d  <= 16'b0;
            r_c_2d          <= 1'b0;
        end else begin
            stage2_out1_2d  <= stage2_out1_3d ;
            stage2_out2_2d  <= stage2_out2_3d ;
            stage2_out3_2d  <= stage2_out3_3d ;
            stage2_out4_2d  <= stage2_out4_3d ;
            r_c_2d          <= r_c_3d         ;
        end
    end

    assign L1 = stage2_out1_2d ;
    assign L2 = stage2_out2_2d ;
    assign L3 = stage2_out3_2d ;
    assign L4 = stage2_out4_2d ;
    assign C  = r_c_2d         ;


endmodule
