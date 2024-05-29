`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/19 09:20:10
// Design Name: 
// Module Name: CheckNodeProcessingUnit
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


module CheckNodeProcessingUnit(   //Rcv = sign* sign *sign...*sign * [fie (Lcn)] 
    input       clk  ,
    input       rst  ,
    input [15:0] Lcn_0, 
    input [15:0] Lcn_1, 
    input [15:0] Lcn_2, 
    input [15:0] Lcn_3,
    input [15:0] Lcn_4, 
    input [15:0] Lcn_5, 
    input [15:0] Lcn_6, 
    input [15:0] Lcn_7,
    input [15:0] Lcn_8, 
    input [15:0] Lcn_9, 
    input [15:0] Lcn_10, 
    input [15:0] Lcn_11,
    input [15:0] Lcn_12, 
    input [15:0] Lcn_13, 
    input [15:0] Lcn_14, 
    input [15:0] Lcn_15,
    input [15:0] Lcn_16, 
    input [15:0] Lcn_17, 
    input [15:0] Lcn_18, 
    input [15:0] Lcn_19,
    input [15:0] Lcn_20, 
    input [15:0] Lcn_21, 
    input [15:0] Lcn_22, 
    input [15:0] Lcn_23,
    input [15:0] Lcn_24, 
    input [15:0] Lcn_25, 
    input [15:0] Lcn_26, 
    input [15:0] Lcn_27,
    input [15:0] Lcn_28, 
    input [15:0] Lcn_29, 
    input [15:0] Lcn_30, 
    input [15:0] Lcn_31,
    output [15:0] sign_magnitude_0, 
    output [15:0] sign_magnitude_1, 
    output [15:0] sign_magnitude_2, 
    output [15:0] sign_magnitude_3,
    output [15:0] sign_magnitude_4, 
    output [15:0] sign_magnitude_5, 
    output [15:0] sign_magnitude_6, 
    output [15:0] sign_magnitude_7,
    output [15:0] sign_magnitude_8, 
    output [15:0] sign_magnitude_9, 
    output [15:0] sign_magnitude_10, 
    output [15:0] sign_magnitude_11,
    output [15:0] sign_magnitude_12, 
    output [15:0] sign_magnitude_13, 
    output [15:0] sign_magnitude_14, 
    output [15:0] sign_magnitude_15,
    output [15:0] sign_magnitude_16, 
    output [15:0] sign_magnitude_17, 
    output [15:0] sign_magnitude_18, 
    output [15:0] sign_magnitude_19,
    output [15:0] sign_magnitude_20, 
    output [15:0] sign_magnitude_21, 
    output [15:0] sign_magnitude_22, 
    output [15:0] sign_magnitude_23,
    output [15:0] sign_magnitude_24, 
    output [15:0] sign_magnitude_25, 
    output [15:0] sign_magnitude_26, 
    output [15:0] sign_magnitude_27,
    output [15:0] sign_magnitude_28, 
    output [15:0] sign_magnitude_29, 
    output [15:0] sign_magnitude_30, 
    output [15:0] sign_magnitude_31  
);


wire [15:0] phi_Lcn [0:31];  
reg [15:0] Lcn [0:31];
reg [15:0] stage1 [0:7];    
reg [15:0] stage2 [0:1];    
reg [15:0] stage4;          
reg sign_bit;              
reg sign_bit1;
reg sign_bit2;
reg sign_bit3;
reg [8:0] high_sum;
reg [8:0] low_sum;
integer i;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        Lcn[0] <='b0; 
        Lcn[1] <='b0; 
        Lcn[2] <='b0; 
        Lcn[3] <='b0; 
        Lcn[4] <='b0; 
        Lcn[5] <='b0; 
        Lcn[6] <='b0; 
        Lcn[7] <='b0; 
        Lcn[8] <='b0; 
        Lcn[9] <='b0; 
        Lcn[10]<='b0; 
        Lcn[11]<='b0; 
        Lcn[12]<='b0; 
        Lcn[13]<='b0; 
        Lcn[14]<='b0; 
        Lcn[15]<='b0; 
        Lcn[16]<='b0; 
        Lcn[17]<='b0; 
        Lcn[18]<='b0; 
        Lcn[19]<='b0; 
        Lcn[20]<='b0; 
        Lcn[21]<='b0; 
        Lcn[22]<='b0; 
        Lcn[23]<='b0; 
        Lcn[24]<='b0; 
        Lcn[25]<='b0; 
        Lcn[26]<='b0; 
        Lcn[27]<='b0; 
        Lcn[28]<='b0; 
        Lcn[29]<='b0; 
        Lcn[30]<='b0; 
        Lcn[31]<='b0; 
    end
    else
    begin
        Lcn[0] <=Lcn_0;
        Lcn[1] <=Lcn_1;
        Lcn[2] <=Lcn_2;
        Lcn[3] <=Lcn_3;
        Lcn[4] <=Lcn_4;
        Lcn[5] <=Lcn_5;
        Lcn[6] <=Lcn_6;
        Lcn[7] <=Lcn_7;
        Lcn[8] <=Lcn_8;
        Lcn[9] <=Lcn_9;
        Lcn[10]<=Lcn_10;
        Lcn[11]<=Lcn_11;
        Lcn[12]<=Lcn_12;
        Lcn[13]<=Lcn_13;
        Lcn[14]<=Lcn_14;
        Lcn[15]<=Lcn_15;
        Lcn[16]<=Lcn_16;
        Lcn[17]<=Lcn_17;
        Lcn[18]<=Lcn_18;
        Lcn[19]<=Lcn_19;
        Lcn[20]<=Lcn_20;
        Lcn[21]<=Lcn_21;
        Lcn[22]<=Lcn_22;
        Lcn[23]<=Lcn_23;
        Lcn[24]<=Lcn_24;
        Lcn[25]<=Lcn_25;
        Lcn[26]<=Lcn_26;
        Lcn[27]<=Lcn_27;
        Lcn[28]<=Lcn_28;
        Lcn[29]<=Lcn_29;
        Lcn[30]<=Lcn_30;
        Lcn[31]<=Lcn_31;
    end
end

genvar j;
generate
    for (j = 0; j < 32; j = j + 1) begin : lut_a_instances
        LUT_A lut_a (
            .x(Lcn[j]),
            .phi_x(phi_Lcn[j])
        );
    end
endgenerate

always @(posedge clk or posedge rst) begin
    if(rst) begin
        sign_bit1 <= 'b0;    
    begin
        for (i = 0; i < 8; i = i + 1) begin
            stage1[i] <= 'b0;
        end
    end
    end
    else begin
    begin
        for (i = 0; i < 32; i = i + 1) begin
            sign_bit1 <= sign_bit1 ^ Lcn[i][15];  
        end
    end
    begin
        for (i = 0; i < 8; i = i + 1) begin
            stage1[i] <= phi_Lcn[i*4] + phi_Lcn[i*4+1] + phi_Lcn[i*4+2] + phi_Lcn[i*4+3];
        end
    end
    end
end


always @(posedge clk or posedge rst) begin
    if(rst)begin
        stage2[0] <= 'b0 ;
        stage2[1] <= 'b0 ;
        sign_bit2 <= 'b0 ;        
    end
    else begin
        stage2[0] <= stage1[0] + stage1[1] + stage1[2] + stage1[3];
        stage2[1] <= stage1[4] + stage1[5] + stage1[6] + stage1[7];
        sign_bit2 <= sign_bit1 ; 
end
end

always @(posedge clk or posedge rst) begin
    if(rst)begin
        sign_bit3 <= 'b0 ;
        high_sum  <= 'b0 ;
        low_sum   <= 'b0 ;
    end
    else begin
        high_sum  <= {1'b0,stage2[0][15:8]} + {1'b0,stage2[1][15:8]} ;
        low_sum   <= {1'b0,stage2[0][7:0]} + {1'b0,stage2[1][2:0]} ;
        sign_bit3 <= sign_bit2 ; 
    end
end

//saturation logic
always @(posedge clk or posedge rst) begin
    if(rst)begin
        stage4   <= 'b0;
        sign_bit <= 'b0;
    end
    else if({high_sum[7:0], low_sum[7:0]}>='d65535)begin
        stage4   <= 16'd65535;
        sign_bit <= sign_bit3;
    end
    else begin
        stage4 <= {high_sum[7:0], low_sum[7:0]};
        sign_bit <= sign_bit3;
    end
end


assign  sign_magnitude_0  = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_1  = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_2  = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_3  = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_4  = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_5  = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_6  = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_7  = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_8  = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_9  = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_10 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_11 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_12 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_13 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_14 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_15 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_16 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_17 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_18 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_19 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_20 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_21 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_22 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_23 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_24 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_25 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_26 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_27 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_28 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_29 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_30 = {sign_bit , stage4[14:0]} ;
assign  sign_magnitude_31 = {sign_bit , stage4[14:0]} ;

endmodule