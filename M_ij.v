`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/20 09:41:45
// Design Name: 
// Module Name: M_ij
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


//256 (2*16*8) bit for each M, it is divided into odd and even, it has for data ports
//as shown in figure 4

module M_ij (
    input                   clk         ,
    input                   rst         ,
    input    [15:0]         data_in_o   ,
    input    [15:0]         data_in_e   ,
    input                   we          ,
    input                   re          ,
    output   [15:0]         data_out_o  ,
    output   [15:0]         data_out_e  ,
    input                   data_initial,
    input    [15:0]         data_i_i    , //data_initial_in
    input                   done        ,
    output   [15:0]         data_o_d      //data_out_done      
);

reg [15:0] mem_o [0:7];    
reg [15:0] mem_e [0:7];
reg [15:0] r_o_o ;
reg [15:0] r_o_e ;
reg [4:0]  r_i_cnt;//initial input cnt
reg [4:0]  r_o_cnt;
reg [15:0] r_o_d;

assign data_out_o = r_o_o ;
assign data_out_e = r_o_e ;
assign data_o_d   = r_o_d ;

always @(posedge clk or posedge rst) begin
    if(rst)
        r_i_cnt <= 'b0;
    else if(r_i_cnt==5'd16)
        r_i_cnt <= 'b0;
    else if(data_initial)
        r_i_cnt <= r_i_cnt + 1 ;
    else
        r_i_cnt <= 'b0;
end

always @(posedge clk or posedge rst) begin
    if(rst)
        r_o_cnt <= 'b0;
    else if(r_i_cnt==5'd16)
        r_o_cnt <= 'b0;
    else if(done)
        r_o_cnt <= r_o_cnt + 1 ;
    else
        r_o_cnt <= 'b0;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        mem_e[0] <= 16'b0;
        mem_e[1] <= 16'b0;
        mem_e[2] <= 16'b0;
        mem_e[3] <= 16'b0;
        mem_e[4] <= 16'b0;
        mem_e[5] <= 16'b0;
        mem_e[6] <= 16'b0;
        mem_e[7] <= 16'b0;
        // mem_e[8] <= 16'b0;
        // mem_e[9] <= 16'b0;
        // mem_e[10] <= 16'b0;
        // mem_e[11] <= 16'b0;
        // mem_e[12] <= 16'b0;
        // mem_e[13] <= 16'b0;
        // mem_e[14] <= 16'b0;
        // mem_e[15] <= 16'b0;
        r_o_e     <= 16'b0;

        mem_o[0] <= 16'b0;
        mem_o[1] <= 16'b0;
        mem_o[2] <= 16'b0;
        mem_o[3] <= 16'b0;
        mem_o[4] <= 16'b0;
        mem_o[5] <= 16'b0;
        mem_o[6] <= 16'b0;
        mem_o[7] <= 16'b0;
        // mem_o[8] <= 16'b0;
        // mem_o[9] <= 16'b0;
        // mem_o[10] <= 16'b0;
        // mem_o[11] <= 16'b0;
        // mem_o[12] <= 16'b0;
        // mem_o[13] <= 16'b0;
        // mem_o[14] <= 16'b0;
        // mem_o[15] <= 16'b0;
        r_o_o     <= 16'b0;
        r_o_d     <= 16'b0;

    end else if(done)begin
        if(r_o_cnt<8)
            r_o_d <= mem_e[r_o_cnt] ;
        else 
            r_o_d <= mem_o[r_o_cnt-8] ;

    end else if(data_initial)begin
        if(r_i_cnt<8)
            mem_e[r_i_cnt] <= data_i_i ;
        else 
            mem_o[r_i_cnt-8] <= data_i_i ;

    end else if(we && (!re)) begin
        // mem_e[0]  <= mem_o[6];
        // mem_e[1]  <= mem_o[7];
        // mem_e[2]  <= mem_e[0];
        // mem_e[3]  <= mem_e[1];
        // mem_e[4]  <= mem_e[2];
        // mem_e[5]  <= mem_e[3];
        // mem_e[6]  <= mem_e[4];
        mem_e[0]  <= mem_o[7];
        mem_e[1]  <= mem_e[0];
        mem_e[2]  <= mem_e[1];
        mem_e[3]  <= mem_e[2];
        mem_e[4]  <= mem_e[3];
        mem_e[5]  <= mem_e[4];
        mem_e[6]  <= mem_e[5];
        mem_e[7]  <= data_in_e;
        r_o_e     <= 'b0;

        // mem_o[0]  <= mem_e[6];
        // mem_o[1]  <= mem_e[7];
        // mem_o[2]  <= mem_o[0];
        // mem_o[3]  <= mem_o[1];
        // mem_o[4]  <= mem_o[2];
        // mem_o[5]  <= mem_o[3];
        // mem_o[6]  <= mem_o[4];
        
        mem_o[0]  <= mem_e[7];
        mem_o[1]  <= data_in_o;
        mem_o[2]  <= mem_o[1];
        mem_o[3]  <= mem_o[2];
        mem_o[4]  <= mem_o[3];
        mem_o[5]  <= mem_o[4];
        mem_o[6]  <= mem_o[5];
        mem_o[7]  <= mem_o[6];
        r_o_o     <= 'b0;

    end else if(re && (!we)) begin
        mem_e[0]  <= mem_o[7];
        mem_e[1]  <= mem_e[0];
        mem_e[2]  <= mem_e[1];
        mem_e[3]  <= mem_e[2];
        mem_e[4]  <= mem_e[3];
        mem_e[5]  <= mem_e[4];
        mem_e[6]  <= mem_e[5];
        mem_e[7]  <= mem_e[6];
        r_o_e     <= mem_e[7];

        mem_o[0]  <= mem_e[7];
        mem_o[1]  <= mem_o[0];
        mem_o[2]  <= mem_o[1];
        mem_o[3]  <= mem_o[2];
        mem_o[4]  <= mem_o[3];
        mem_o[5]  <= mem_o[4];
        mem_o[6]  <= mem_o[5];
        mem_o[7]  <= mem_o[6];
        r_o_o     <= mem_o[1];
    end
//  else if(we_o) begin
//         mem_e[0]  <= mem_o[15];
//         mem_e[1]  <= mem_o[0];
//         mem_e[2]  <= mem_o[1];
//         mem_e[3]  <= mem_o[2];
//         mem_e[4]  <= mem_o[3];
//         mem_e[5]  <= mem_o[4];
//         mem_e[6]  <= mem_o[5];
//         mem_e[7]  <= mem_o[6];
//         mem_e[8]  <= mem_o[7];
//         mem_e[9]  <= mem_o[8];
//         mem_e[10] <= mem_o[9];
//         mem_e[11] <= mem_o[10];
//         mem_e[12] <= mem_o[11];
//         mem_e[13] <= mem_o[12];
//         mem_e[14] <= mem_o[13];
//         mem_e[15] <= mem_o[14];
//         r_o_e     <= mem_e[0];

//         mem_o[0]  <= mem_e[15];
//         mem_o[1]  <= mem_e[0];
//         mem_o[2]  <= mem_e[1];
//         mem_o[3]  <= mem_e[2];
//         mem_o[4]  <= mem_e[3];
//         mem_o[5]  <= mem_e[4];
//         mem_o[6]  <= mem_e[5];
//         mem_o[7]  <= mem_e[6];
//         mem_o[8]  <= mem_e[7];
//         mem_o[9]  <= mem_e[8];
//         mem_o[10] <= mem_e[9];
//         mem_o[11] <= mem_e[10];
//         mem_o[12] <= mem_e[11];
//         mem_o[13] <= mem_e[12];
//         mem_o[14] <= mem_e[13];
//         mem_o[15] <= data_in_o;
//         r_o_o     <= mem_o[0];
//  end 
    else begin
        // mem_e[0]  <= mem_o[7];
        // mem_e[1]  <= mem_e[0];
        // mem_e[2]  <= mem_e[1];
        // mem_e[3]  <= mem_e[2];
        // mem_e[4]  <= mem_e[3];
        // mem_e[5]  <= mem_e[4];
        // mem_e[6]  <= mem_e[5];
        // mem_e[7]  <= mem_e[6];
        r_o_e     <= 'b0;
        // mem_e[8]  <= mem_o[7];
        // mem_e[9]  <= mem_o[8];
        // mem_e[10] <= mem_o[9];
        // mem_e[11] <= mem_o[10];
        // mem_e[12] <= mem_o[11];
        // mem_e[13] <= mem_o[12];
        // mem_e[14] <= mem_o[13];
        // mem_e[15] <= mem_o[14];


        // mem_o[0]  <= mem_e[7];
        // mem_o[1]  <= mem_o[0];
        // mem_o[2]  <= mem_o[1];
        // mem_o[3]  <= mem_o[2];
        // mem_o[4]  <= mem_o[3];
        // mem_o[5]  <= mem_o[4];
        // mem_o[6]  <= mem_o[5];
        // mem_o[7]  <= mem_o[6];
        r_o_o     <= 'b0;
        // mem_o[8]  <= mem_e[7];
        // mem_o[9]  <= mem_e[8];
        // mem_o[10] <= mem_e[9];
        // mem_o[11] <= mem_e[10];
        // mem_o[12] <= mem_e[11];
        // mem_o[13] <= mem_e[12];
        // mem_o[14] <= mem_e[13];
        // mem_o[15] <= mem_e[14];
        r_o_d     <= 'b0;
    end
end


endmodule
