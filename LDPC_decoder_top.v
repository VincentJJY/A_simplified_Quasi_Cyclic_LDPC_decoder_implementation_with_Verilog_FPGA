`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/21 00:21:23
// Design Name: 
// Module Name: LDPC_decoder_top
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

// 8176 = 511*16
// assume that a data frame is 8176 bit, it will be stored by 16 memories, 
// each could store 512 bits, each memory has two in port and two out port, every port is 16 bits,
// to minimize the input ports of the whole system so it could be implement in fpga, we only use one port for each memory
// so 16 cycles is needed to input signal to the ram, and 16 cycles is needed to output the result
// first 2 cycles row read, than 2 cycles column read , than 2 cycles row write ,than 2cycles column read

module LDPC_decoder_top(
    input           clk         ,
    input           rst         ,

    //input 
    input   [15:0]  data_in_0   ,
    input   [15:0]  data_in_1   ,
    input   [15:0]  data_in_2   ,
    input   [15:0]  data_in_3   ,
    input   [15:0]  data_in_4   ,
    input   [15:0]  data_in_5   ,
    input   [15:0]  data_in_6   ,
    input   [15:0]  data_in_7   ,
    input   [15:0]  data_in_8   ,
    input   [15:0]  data_in_9   ,
    input   [15:0]  data_in_10  ,
    input   [15:0]  data_in_11  ,
    input   [15:0]  data_in_12  ,
    input   [15:0]  data_in_13  ,
    input   [15:0]  data_in_14  ,
    input   [15:0]  data_in_15  ,
    input   [15:0]  data_in_16  ,
    input   [15:0]  data_in_17  ,
    input   [15:0]  data_in_18  ,
    input   [15:0]  data_in_19  ,
    input   [15:0]  data_in_20  ,
    input   [15:0]  data_in_21  ,
    input   [15:0]  data_in_22  ,
    input   [15:0]  data_in_23  ,
    input   [15:0]  data_in_24  ,
    input   [15:0]  data_in_25  ,
    input   [15:0]  data_in_26  ,
    input   [15:0]  data_in_27  ,
    input   [15:0]  data_in_28  ,
    input   [15:0]  data_in_29  ,
    input   [15:0]  data_in_30  ,
    input   [15:0]  data_in_31  ,
    input           i_valid     ,//active high with the data_in package
    input   [15:0]  i_z         ,

    //output
    output  [15:0]  data_out_0   ,
    output  [15:0]  data_out_1   ,
    output  [15:0]  data_out_2   ,
    output  [15:0]  data_out_3   ,
    output  [15:0]  data_out_4   ,
    output  [15:0]  data_out_5   ,
    output  [15:0]  data_out_6   ,
    output  [15:0]  data_out_7   ,
    output  [15:0]  data_out_8   ,
    output  [15:0]  data_out_9   ,
    output  [15:0]  data_out_10  ,
    output  [15:0]  data_out_11  ,
    output  [15:0]  data_out_12  ,
    output  [15:0]  data_out_13  ,
    output  [15:0]  data_out_14  ,
    output  [15:0]  data_out_15  ,
    output  [15:0]  data_out_16  ,
    output  [15:0]  data_out_17  ,
    output  [15:0]  data_out_18  ,
    output  [15:0]  data_out_19  ,
    output  [15:0]  data_out_20  ,
    output  [15:0]  data_out_21  ,
    output  [15:0]  data_out_22  ,
    output  [15:0]  data_out_23  ,
    output  [15:0]  data_out_24  ,
    output  [15:0]  data_out_25  ,
    output  [15:0]  data_out_26  ,
    output  [15:0]  data_out_27  ,
    output  [15:0]  data_out_28  ,
    output  [15:0]  data_out_29  ,
    output  [15:0]  data_out_30  ,
    output  [15:0]  data_out_31  ,
    output          o_valid      //active high
);

/***************function**************/
integer i;
reg         r_i_valid       ;//put it here to satisfy the need of modelsim

/***************parameter*************/

/***************port******************/             

/***************mechine***************/

//states
localparam  S_idle         =  0,
            S_initial      =  1,
            S_read         =  2, //  read from memory
            S_write        =  3, // write memory
            S_done         =  4;

//state reg
reg [3:0]   r_current_state ;    
reg [3:0]   r_next_state    ;

//state cnt reg
reg [5:0]   r_state_cnt     ;

//iteration cnt reg, the max iteration times
reg [7:0]   r_i_cnt         ;

//state move with time
always @(posedge clk or posedge rst) 
    begin
    if(rst)
        r_current_state <= S_idle ;
    else
        r_current_state <= r_next_state ;    
    end

//state transfor logic
always@(*)
    begin
        case(r_current_state)
            S_idle             : r_next_state = i_valid ? S_initial : S_idle;   
            S_initial          : r_next_state = ((r_state_cnt=='d16) || (!r_i_valid)) ? S_read : S_initial;  
            S_read             : r_next_state = (r_i_cnt==8'd120) ? S_done : ((r_state_cnt=='d4) ? S_write : S_read );
            S_write            : r_next_state = (r_state_cnt=='d8) ? S_read : S_write ;
            S_done             : r_next_state = (r_state_cnt=='d16) ? S_idle : S_done;
        default   : r_next_state = S_idle ;
        endcase
    end

//state cnt logic,it could avoid stay in one state for long
always@(posedge clk or posedge rst)
begin
    if(rst)
        r_state_cnt<= 'b0;
    else if((r_current_state!=r_next_state)||r_state_cnt=='d16)
        r_state_cnt<= 'b0;
    else
        r_state_cnt<= r_state_cnt+1; 
end

//cnt the interation time r_i_cnt
always@(posedge clk or posedge rst)
begin
    if(rst)
        r_i_cnt<= 'b0;
    else if(r_i_cnt==8'd120)//8 for one interation, 15 interations
        r_i_cnt<= 'b0;
    else if((r_current_state==S_write) && (r_next_state ==S_read))
        r_i_cnt<= r_i_cnt + 1;
    else
        r_i_cnt<= r_i_cnt; 
end

/***************reg*******************/
//input register
reg  [15:0] r_data_in [0:31];

reg  [15:0] r_z       [0:15];

//reg done signal 
reg         r_done          ;

//reg of write and read enable for memory
reg         r_we            ;
reg         r_re            ;
    
//reg  to write memory, 32 memory, 2 signal, 0 even 1 odd
reg  [15:0] r_w_m     [0:31][0:1];

//reg of input to cnpu  cnpu 0,1 signal 32 
reg  [15:0] r_i_c     [0:1][0:31];

//reg of vnpu in, vnpu 16, signal 4 
reg  [15:0] r_i_v     [0:15][0:3];

//reg for output valid
reg         r_valid ;
/***************wire******************/
//wire to read from memory, 32 m, 2 s, 0 even 1 odd
wire [15:0] w_r_m     [0:31][0:1]; 

//wire of cnpu out, cnpu 0,1 signal 32
wire  [15:0] w_o_c     [0:1][0:31];

//wire of vnpu out, vnpu 16, signal 4 
wire  [15:0] w_o_v     [0:15][0:3];

//wire to output the result
wire  [15:0] w_d_o     [0:31];

//c is for vnpu
wire  [15:0] w_c;
/***************component*************/

genvar j;
generate
for (j = 0; j < 32; j = j + 1) begin : Mij_instances
    M_ij m_ij (
        .clk         ( clk             ),
        .rst         ( rst             ),
        .data_in_o   ( r_w_m[j][1]     ),
        .data_in_e   ( r_w_m[j][0]     ),
        .we          ( r_we            ),
        .re          ( r_re            ),
        .data_out_o  ( w_r_m[j][1]     ),
        .data_out_e  ( w_r_m[j][0]     ),
        .data_initial( r_i_valid       ),
        .data_i_i    ( r_data_in[j]    ),
        .done        ( r_done          ),  
        .data_o_d    ( w_d_o[j]        )   
    );
end
endgenerate

genvar k;
generate
for (k = 0; k < 2; k = k + 1) begin : cnpu_instances
    CheckNodeProcessingUnit cnpu(    
        .clk                ( clk         ),
        .rst                ( rst         ),
        .Lcn_0              ( r_i_c[k][0 ]),           
        .Lcn_1              ( r_i_c[k][1 ]),           
        .Lcn_2              ( r_i_c[k][2 ]),           
        .Lcn_3              ( r_i_c[k][3 ]),          
        .Lcn_4              ( r_i_c[k][4 ]),           
        .Lcn_5              ( r_i_c[k][5 ]),           
        .Lcn_6              ( r_i_c[k][6 ]),           
        .Lcn_7              ( r_i_c[k][7 ]),          
        .Lcn_8              ( r_i_c[k][8 ]),           
        .Lcn_9              ( r_i_c[k][9 ]),           
        .Lcn_10             ( r_i_c[k][10]), 
        .Lcn_11             ( r_i_c[k][11]),
        .Lcn_12             ( r_i_c[k][12]), 
        .Lcn_13             ( r_i_c[k][13]), 
        .Lcn_14             ( r_i_c[k][14]), 
        .Lcn_15             ( r_i_c[k][15]),
        .Lcn_16             ( r_i_c[k][16]), 
        .Lcn_17             ( r_i_c[k][17]), 
        .Lcn_18             ( r_i_c[k][18]), 
        .Lcn_19             ( r_i_c[k][19]),
        .Lcn_20             ( r_i_c[k][20]), 
        .Lcn_21             ( r_i_c[k][21]), 
        .Lcn_22             ( r_i_c[k][22]), 
        .Lcn_23             ( r_i_c[k][23]),
        .Lcn_24             ( r_i_c[k][24]), 
        .Lcn_25             ( r_i_c[k][25]), 
        .Lcn_26             ( r_i_c[k][26]), 
        .Lcn_27             ( r_i_c[k][27]),
        .Lcn_28             ( r_i_c[k][28]), 
        .Lcn_29             ( r_i_c[k][29]), 
        .Lcn_30             ( r_i_c[k][30]), 
        .Lcn_31             ( r_i_c[k][31]),
        .sign_magnitude_0   ( w_o_c[k][0 ]), 
        .sign_magnitude_1   ( w_o_c[k][1 ]), 
        .sign_magnitude_2   ( w_o_c[k][2 ]), 
        .sign_magnitude_3   ( w_o_c[k][3 ]),
        .sign_magnitude_4   ( w_o_c[k][4 ]), 
        .sign_magnitude_5   ( w_o_c[k][5 ]), 
        .sign_magnitude_6   ( w_o_c[k][6 ]), 
        .sign_magnitude_7   ( w_o_c[k][7 ]),
        .sign_magnitude_8   ( w_o_c[k][8 ]), 
        .sign_magnitude_9   ( w_o_c[k][9 ]), 
        .sign_magnitude_10  ( w_o_c[k][10]), 
        .sign_magnitude_11  ( w_o_c[k][11]),
        .sign_magnitude_12  ( w_o_c[k][12]), 
        .sign_magnitude_13  ( w_o_c[k][13]), 
        .sign_magnitude_14  ( w_o_c[k][14]), 
        .sign_magnitude_15  ( w_o_c[k][15]),
        .sign_magnitude_16  ( w_o_c[k][16]), 
        .sign_magnitude_17  ( w_o_c[k][17]), 
        .sign_magnitude_18  ( w_o_c[k][18]), 
        .sign_magnitude_19  ( w_o_c[k][19]),
        .sign_magnitude_20  ( w_o_c[k][20]), 
        .sign_magnitude_21  ( w_o_c[k][21]), 
        .sign_magnitude_22  ( w_o_c[k][22]), 
        .sign_magnitude_23  ( w_o_c[k][23]),
        .sign_magnitude_24  ( w_o_c[k][24]), 
        .sign_magnitude_25  ( w_o_c[k][25]), 
        .sign_magnitude_26  ( w_o_c[k][26]), 
        .sign_magnitude_27  ( w_o_c[k][27]),
        .sign_magnitude_28  ( w_o_c[k][28]), 
        .sign_magnitude_29  ( w_o_c[k][29]), 
        .sign_magnitude_30  ( w_o_c[k][30]), 
        .sign_magnitude_31  ( w_o_c[k][31])  
);
end
endgenerate

genvar l;
generate
for (l = 0; l < 16; l = l + 1) begin : vnpu_instances
    VariableNodeProcessingUnit vnpu ( 
        .clk                ( clk         ), 
        .rst                ( rst         ),                         
        .I1                 ( r_i_v[l][0] ),            
        .I2                 ( r_i_v[l][1] ),            
        .I3                 ( r_i_v[l][2] ),            
        .I4                 ( r_i_v[l][3] ),            
        .Z                  ( r_z[l]      ),            
        .L1                 ( w_o_v[l][0] ),            
        .L2                 ( w_o_v[l][1] ),            
        .L3                 ( w_o_v[l][2] ),            
        .L4                 ( w_o_v[l][3] ),            
        .C                  ( w_c[l]      )              
);
end
endgenerate


/***************assign****************/

assign      data_out_0   = w_d_o[0 ];
assign      data_out_1   = w_d_o[1 ];
assign      data_out_2   = w_d_o[2 ];
assign      data_out_3   = w_d_o[3 ];
assign      data_out_4   = w_d_o[4 ];
assign      data_out_5   = w_d_o[5 ];
assign      data_out_6   = w_d_o[6 ];
assign      data_out_7   = w_d_o[7 ];
assign      data_out_8   = w_d_o[8 ];
assign      data_out_9   = w_d_o[9 ];
assign      data_out_10  = w_d_o[10];
assign      data_out_11  = w_d_o[11];
assign      data_out_12  = w_d_o[12];
assign      data_out_13  = w_d_o[13];
assign      data_out_14  = w_d_o[14];
assign      data_out_15  = w_d_o[15];
assign      data_out_16  = w_d_o[16];
assign      data_out_17  = w_d_o[17];
assign      data_out_18  = w_d_o[18];
assign      data_out_19  = w_d_o[19];
assign      data_out_20  = w_d_o[20];
assign      data_out_21  = w_d_o[21];
assign      data_out_22  = w_d_o[22];
assign      data_out_23  = w_d_o[23];
assign      data_out_24  = w_d_o[24];
assign      data_out_25  = w_d_o[25];
assign      data_out_26  = w_d_o[26];
assign      data_out_27  = w_d_o[27];
assign      data_out_28  = w_d_o[28];
assign      data_out_29  = w_d_o[29];
assign      data_out_30  = w_d_o[30];
assign      data_out_31  = w_d_o[31];

assign      o_valid = r_valid;
/***************always****************/

//register the data for 1 cycle to avoid the idle state
always @(posedge clk or posedge rst) 
begin
    if(rst)begin
        r_data_in[0]   <= 'b0 ;
        r_data_in[1]   <= 'b0 ;
        r_data_in[2]   <= 'b0 ;
        r_data_in[3]   <= 'b0 ;
        r_data_in[4]   <= 'b0 ;
        r_data_in[5]   <= 'b0 ;
        r_data_in[6]   <= 'b0 ;
        r_data_in[7]   <= 'b0 ;
        r_data_in[8]   <= 'b0 ;
        r_data_in[9]   <= 'b0 ;
        r_data_in[10]  <= 'b0 ;
        r_data_in[11]  <= 'b0 ;
        r_data_in[12]  <= 'b0 ;
        r_data_in[13]  <= 'b0 ;
        r_data_in[14]  <= 'b0 ;
        r_data_in[15]  <= 'b0 ;
        r_data_in[16]  <= 'b0 ;
        r_data_in[17]  <= 'b0 ;
        r_data_in[18]  <= 'b0 ;
        r_data_in[19]  <= 'b0 ;
        r_data_in[20]  <= 'b0 ;
        r_data_in[21]  <= 'b0 ;
        r_data_in[22]  <= 'b0 ;
        r_data_in[23]  <= 'b0 ;
        r_data_in[24]  <= 'b0 ;
        r_data_in[25]  <= 'b0 ;
        r_data_in[26]  <= 'b0 ;
        r_data_in[27]  <= 'b0 ;
        r_data_in[28]  <= 'b0 ;
        r_data_in[29]  <= 'b0 ;
        r_data_in[30]  <= 'b0 ;
        r_data_in[31]  <= 'b0 ;
        r_i_valid      <= 'b0 ;
    end else begin
        r_data_in[0]   <= data_in_0  ;
        r_data_in[1]   <= data_in_1  ;
        r_data_in[2]   <= data_in_2  ;
        r_data_in[3]   <= data_in_3  ;
        r_data_in[4]   <= data_in_4  ;
        r_data_in[5]   <= data_in_5  ;
        r_data_in[6]   <= data_in_6  ;
        r_data_in[7]   <= data_in_7  ;
        r_data_in[8]   <= data_in_8  ;
        r_data_in[9]   <= data_in_9  ;
        r_data_in[10]  <= data_in_10 ;
        r_data_in[11]  <= data_in_11 ;
        r_data_in[12]  <= data_in_12 ;
        r_data_in[13]  <= data_in_13 ;
        r_data_in[14]  <= data_in_14 ;
        r_data_in[15]  <= data_in_15 ;
        r_data_in[16]  <= data_in_16 ;
        r_data_in[17]  <= data_in_17 ;
        r_data_in[18]  <= data_in_18 ;
        r_data_in[19]  <= data_in_19 ;
        r_data_in[20]  <= data_in_20 ;
        r_data_in[21]  <= data_in_21 ;
        r_data_in[22]  <= data_in_22 ;
        r_data_in[23]  <= data_in_23 ;
        r_data_in[24]  <= data_in_24 ;
        r_data_in[25]  <= data_in_25 ;
        r_data_in[26]  <= data_in_26 ;
        r_data_in[27]  <= data_in_27 ;
        r_data_in[28]  <= data_in_28 ;
        r_data_in[29]  <= data_in_29 ;
        r_data_in[30]  <= data_in_30 ;
        r_data_in[31]  <= data_in_31 ;
        r_i_valid      <= i_valid    ;  
    end
end

//latch the input  [15:0] r_z       [0:15];
always@(posedge clk or posedge rst)
begin
    if(rst)begin
        for (i = 0; i < 16; i = i + 1) begin
            r_z[i] <= 16'b0; 
        end
    end
    else if(i_valid)
            r_z[r_state_cnt]<=i_z;
    else begin
        for (i = 0; i < 16; i = i + 1) begin
            r_z[i] <= r_z[i]; 
        end
    end
end

//control the write reg of Memory
always @(posedge clk or posedge rst) 
begin
    if(rst)begin
        for (i = 0; i < 32; i = i + 1) begin
            r_w_m[i][0] <= 16'b0;
            r_w_m[i][1] <= 16'b0;  
        end
    end
    else if((r_current_state==S_write) && ( r_state_cnt==3 || r_state_cnt==4 ))begin //transmit data from c to m
        // for (i = 0; i < 16; i = i + 1)begin
        //     r_w_m[i][0] <= w_o_c[0][i];
        //     r_w_m[i][1] <= w_o_c[0][i+16];
        //     r_w_m[i+16][0] <= w_o_c[1][i];
        //     r_w_m[i+16][1] <= w_o_c[1][i+16];
        // end
        r_w_m[0][0] <= w_o_c[0][0];
        r_w_m[0][1] <= w_o_c[0][16];
        r_w_m[16][0] <= w_o_c[1][0];
        r_w_m[16][1] <= w_o_c[1][16];       

        r_w_m[1][0] <= w_o_c[0][1];
        r_w_m[1][1] <= w_o_c[0][17];
        r_w_m[17][0] <= w_o_c[1][1];
        r_w_m[17][1] <= w_o_c[1][17];       

        r_w_m[2][0] <= w_o_c[0][2];
        r_w_m[2][1] <= w_o_c[0][18];
        r_w_m[18][0] <= w_o_c[1][2];
        r_w_m[18][1] <= w_o_c[1][18];       

        r_w_m[3][0] <= w_o_c[0][3];
        r_w_m[3][1] <= w_o_c[0][19];
        r_w_m[19][0] <= w_o_c[1][3];
        r_w_m[19][1] <= w_o_c[1][19];       

        r_w_m[4][0] <= w_o_c[0][4];
        r_w_m[4][1] <= w_o_c[0][20];
        r_w_m[20][0] <= w_o_c[1][4];
        r_w_m[20][1] <= w_o_c[1][20];       

        r_w_m[5][0] <= w_o_c[0][5];
        r_w_m[5][1] <= w_o_c[0][21];
        r_w_m[21][0] <= w_o_c[1][5];
        r_w_m[21][1] <= w_o_c[1][21];       

        r_w_m[6][0] <= w_o_c[0][6];
        r_w_m[6][1] <= w_o_c[0][22];
        r_w_m[22][0] <= w_o_c[1][6];
        r_w_m[22][1] <= w_o_c[1][22];       

        r_w_m[7][0] <= w_o_c[0][7];
        r_w_m[7][1] <= w_o_c[0][23];
        r_w_m[23][0] <= w_o_c[1][7];
        r_w_m[23][1] <= w_o_c[1][23];       

        r_w_m[8][0] <= w_o_c[0][8];
        r_w_m[8][1] <= w_o_c[0][24];
        r_w_m[24][0] <= w_o_c[1][8];
        r_w_m[24][1] <= w_o_c[1][24];       

        r_w_m[9][0] <= w_o_c[0][9];
        r_w_m[9][1] <= w_o_c[0][25];
        r_w_m[25][0] <= w_o_c[1][9];
        r_w_m[25][1] <= w_o_c[1][25];       

        r_w_m[10][0] <= w_o_c[0][10];
        r_w_m[10][1] <= w_o_c[0][26];
        r_w_m[26][0] <= w_o_c[1][10];
        r_w_m[26][1] <= w_o_c[1][26];       

        r_w_m[11][0] <= w_o_c[0][11];
        r_w_m[11][1] <= w_o_c[0][27];
        r_w_m[27][0] <= w_o_c[1][11];
        r_w_m[27][1] <= w_o_c[1][27];       

        r_w_m[12][0] <= w_o_c[0][12];
        r_w_m[12][1] <= w_o_c[0][28];
        r_w_m[28][0] <= w_o_c[1][12];
        r_w_m[28][1] <= w_o_c[1][28];       

        r_w_m[13][0] <= w_o_c[0][13];
        r_w_m[13][1] <= w_o_c[0][29];
        r_w_m[29][0] <= w_o_c[1][13];
        r_w_m[29][1] <= w_o_c[1][29];       

        r_w_m[14][0] <= w_o_c[0][14];
        r_w_m[14][1] <= w_o_c[0][30];
        r_w_m[30][0] <= w_o_c[1][14];
        r_w_m[30][1] <= w_o_c[1][30];       

        r_w_m[15][0] <= w_o_c[0][15];
        r_w_m[15][1] <= w_o_c[0][31];
        r_w_m[31][0] <= w_o_c[1][15];
        r_w_m[31][1] <= w_o_c[1][31];
    end
    else if((r_current_state==S_write) && ( r_state_cnt==5 || r_state_cnt==6 ))begin //transmit data from v to m
        // for (i = 0; i < 16; i = i + 1)begin
        //     r_w_m[i][0] <= w_o_v[i][0];
        //     r_w_m[i][1] <= w_o_v[i][1];
        //     r_w_m[i+16][0] <= w_o_v[i][2];
        //     r_w_m[i+16][1] <= w_o_v[i][3];
        // end
        r_w_m[0][0] <= w_o_v[0][0];
        r_w_m[0][1] <= w_o_v[0][1];
        r_w_m[16][0] <= w_o_v[0][2];
        r_w_m[16][1] <= w_o_v[0][3];

        r_w_m[1][0] <= w_o_v[1][0];
        r_w_m[1][1] <= w_o_v[1][1];
        r_w_m[17][0] <= w_o_v[1][2];
        r_w_m[17][1] <= w_o_v[1][3];

        r_w_m[2][0] <= w_o_v[2][0];
        r_w_m[2][1] <= w_o_v[2][1];
        r_w_m[18][0] <= w_o_v[2][2];
        r_w_m[18][1] <= w_o_v[2][3];

        r_w_m[3][0] <= w_o_v[3][0];
        r_w_m[3][1] <= w_o_v[3][1];
        r_w_m[19][0] <= w_o_v[3][2];
        r_w_m[19][1] <= w_o_v[3][3];

        r_w_m[4][0] <= w_o_v[4][0];
        r_w_m[4][1] <= w_o_v[4][1];
        r_w_m[20][0] <= w_o_v[4][2];
        r_w_m[20][1] <= w_o_v[4][3];

        r_w_m[5][0] <= w_o_v[5][0];
        r_w_m[5][1] <= w_o_v[5][1];
        r_w_m[21][0] <= w_o_v[5][2];
        r_w_m[21][1] <= w_o_v[5][3];

        r_w_m[6][0] <= w_o_v[6][0];
        r_w_m[6][1] <= w_o_v[6][1];
        r_w_m[22][0] <= w_o_v[6][2];
        r_w_m[22][1] <= w_o_v[6][3];

        r_w_m[7][0] <= w_o_v[7][0];
        r_w_m[7][1] <= w_o_v[7][1];
        r_w_m[23][0] <= w_o_v[7][2];
        r_w_m[23][1] <= w_o_v[7][3];

        r_w_m[8][0] <= w_o_v[8][0];
        r_w_m[8][1] <= w_o_v[8][1];
        r_w_m[24][0] <= w_o_v[8][2];
        r_w_m[24][1] <= w_o_v[8][3];

        r_w_m[9][0] <= w_o_v[9][0];
        r_w_m[9][1] <= w_o_v[9][1];
        r_w_m[25][0] <= w_o_v[9][2];
        r_w_m[25][1] <= w_o_v[9][3];

        r_w_m[10][0] <= w_o_v[10][0];
        r_w_m[10][1] <= w_o_v[10][1];
        r_w_m[26][0] <= w_o_v[10][2];
        r_w_m[26][1] <= w_o_v[10][3];

        r_w_m[11][0] <= w_o_v[11][0];
        r_w_m[11][1] <= w_o_v[11][1];
        r_w_m[27][0] <= w_o_v[11][2];
        r_w_m[27][1] <= w_o_v[11][3];

        r_w_m[12][0] <= w_o_v[12][0];
        r_w_m[12][1] <= w_o_v[12][1];
        r_w_m[28][0] <= w_o_v[12][2];
        r_w_m[28][1] <= w_o_v[12][3];

        r_w_m[13][0] <= w_o_v[13][0];
        r_w_m[13][1] <= w_o_v[13][1];
        r_w_m[29][0] <= w_o_v[13][2];
        r_w_m[29][1] <= w_o_v[13][3];

        r_w_m[14][0] <= w_o_v[14][0];
        r_w_m[14][1] <= w_o_v[14][1];
        r_w_m[30][0] <= w_o_v[14][2];
        r_w_m[30][1] <= w_o_v[14][3];

        r_w_m[15][0] <= w_o_v[15][0];
        r_w_m[15][1] <= w_o_v[15][1];
        r_w_m[31][0] <= w_o_v[15][2];
        r_w_m[31][1] <= w_o_v[15][3];
    end
    else begin
        for (i = 0; i < 32; i = i + 1) begin
            r_w_m[i][0] <= 16'b0;
            r_w_m[i][1] <= 16'b0;  
        end
    end
end

//control the reg of write enable for memory
always@(posedge clk or posedge rst)
begin
    if(rst)
        r_we <= 'b0;
    else if( (r_current_state==S_write) && ((r_state_cnt==4) || (r_state_cnt==5) || (r_state_cnt==6) || (r_state_cnt==3))  )
        r_we <= 1'b1;
    else
        r_we <= 'b0;
end

//control the reg of read enable for memory
always@(posedge clk or posedge rst)
begin
    if(rst)
        r_re <='b0;
    else if((r_current_state==S_read) && (r_state_cnt<4)  )
        r_re <= 1'b1;
    else
        r_re <='b0;
end

//control the reg of input to cnpu  cnpu 0,1 signal 32 
always@(posedge clk or posedge rst)
begin
    if(rst)begin
    for (i = 0; i < 32; i = i + 1) begin
        r_i_c[0][i]<=16'b0;
        r_i_c[1][i]<=16'b0;
        end
    end
    else if((r_current_state==S_read) && ( r_state_cnt==3 || r_state_cnt==2))begin
    //here is a two cycle delay from r_re to ric
    // for (i = 0; i < 16; i = i + 1) begin
    //     r_i_c[0][i]   <=w_r_m[i][0];
    //     r_i_c[0][i+16]<=w_r_m[i][1];
    //     r_i_c[1][i]   <=w_r_m[i+16][0];
    //     r_i_c[1][i+16]<=w_r_m[i+16][1];
    //     end
        r_i_c[0][0] <= w_r_m[0][0];
        r_i_c[0][16] <= w_r_m[0][1];
        r_i_c[1][0] <= w_r_m[16][0];
        r_i_c[1][16] <= w_r_m[16][1];

        r_i_c[0][1] <= w_r_m[1][0];
        r_i_c[0][17] <= w_r_m[1][1];
        r_i_c[1][1] <= w_r_m[17][0];
        r_i_c[1][17] <= w_r_m[17][1];

        r_i_c[0][2] <= w_r_m[2][0];
        r_i_c[0][18] <= w_r_m[2][1];
        r_i_c[1][2] <= w_r_m[18][0];
        r_i_c[1][18] <= w_r_m[18][1];

        r_i_c[0][3] <= w_r_m[3][0];
        r_i_c[0][19] <= w_r_m[3][1];
        r_i_c[1][3] <= w_r_m[19][0];
        r_i_c[1][19] <= w_r_m[19][1];

        r_i_c[0][4] <= w_r_m[4][0];
        r_i_c[0][20] <= w_r_m[4][1];
        r_i_c[1][4] <= w_r_m[20][0];
        r_i_c[1][20] <= w_r_m[20][1];

        r_i_c[0][5] <= w_r_m[5][0];
        r_i_c[0][21] <= w_r_m[5][1];
        r_i_c[1][5] <= w_r_m[21][0];
        r_i_c[1][21] <= w_r_m[21][1];

        r_i_c[0][6] <= w_r_m[6][0];
        r_i_c[0][22] <= w_r_m[6][1];
        r_i_c[1][6] <= w_r_m[22][0];
        r_i_c[1][22] <= w_r_m[22][1];

        r_i_c[0][7] <= w_r_m[7][0];
        r_i_c[0][23] <= w_r_m[7][1];
        r_i_c[1][7] <= w_r_m[23][0];
        r_i_c[1][23] <= w_r_m[23][1];

        r_i_c[0][8] <= w_r_m[8][0];
        r_i_c[0][24] <= w_r_m[8][1];
        r_i_c[1][8] <= w_r_m[24][0];
        r_i_c[1][24] <= w_r_m[24][1];

        r_i_c[0][9] <= w_r_m[9][0];
        r_i_c[0][25] <= w_r_m[9][1];
        r_i_c[1][9] <= w_r_m[25][0];
        r_i_c[1][25] <= w_r_m[25][1];

        r_i_c[0][10] <= w_r_m[10][0];
        r_i_c[0][26] <= w_r_m[10][1];
        r_i_c[1][10] <= w_r_m[26][0];
        r_i_c[1][26] <= w_r_m[26][1];

        r_i_c[0][11] <= w_r_m[11][0];
        r_i_c[0][27] <= w_r_m[11][1];
        r_i_c[1][11] <= w_r_m[27][0];
        r_i_c[1][27] <= w_r_m[27][1];

        r_i_c[0][12] <= w_r_m[12][0];
        r_i_c[0][28] <= w_r_m[12][1];
        r_i_c[1][12] <= w_r_m[28][0];
        r_i_c[1][28] <= w_r_m[28][1];

        r_i_c[0][13] <= w_r_m[13][0];
        r_i_c[0][29] <= w_r_m[13][1];
        r_i_c[1][13] <= w_r_m[29][0];
        r_i_c[1][29] <= w_r_m[29][1];

        r_i_c[0][14] <= w_r_m[14][0];
        r_i_c[0][30] <= w_r_m[14][1];
        r_i_c[1][14] <= w_r_m[30][0];
        r_i_c[1][30] <= w_r_m[30][1];

        r_i_c[0][15] <= w_r_m[15][0];
        r_i_c[0][31] <= w_r_m[15][1];
        r_i_c[1][15] <= w_r_m[31][0];
        r_i_c[1][31] <= w_r_m[31][1];
    end
    else begin
    for (i = 0; i < 32; i = i + 1) begin
        r_i_c[0][i]<=16'b0;
        r_i_c[1][i]<=16'b0;
        end
    end
end

//control the reg of vnpu in, vnpu 16, signal 4 
always@(posedge clk or posedge rst)
begin
    if(rst)begin
    for (i = 0; i < 16; i = i + 1) begin
        r_i_v[i][0]<=16'b0;
        r_i_v[i][1]<=16'b0;
        r_i_v[i][2]<=16'b0;
        r_i_v[i][3]<=16'b0;
        end
    end
    else if(((r_current_state==S_write) && ( r_state_cnt==0)) || ((r_current_state==S_read)&&(r_state_cnt==4)))begin
        //here is a two cycle delay from r_re to riv
    // for (i = 0; i < 16; i = i + 1) begin//data from memory to vnpu
    //     r_i_v[i][0]<=w_r_m[i][0];;
    //     r_i_v[i][1]<=w_r_m[i][1];;
    //     r_i_v[i][2]<=w_r_m[i+16][0];;
    //     r_i_v[i][3]<=w_r_m[i+16][1];;
    //     end
        r_i_v[0][0] <= w_r_m[0][0];
        r_i_v[0][1] <= w_r_m[0][1];
        r_i_v[0][2] <= w_r_m[16][0];
        r_i_v[0][3] <= w_r_m[16][1];
        
        r_i_v[1][0] <= w_r_m[1][0];
        r_i_v[1][1] <= w_r_m[1][1];
        r_i_v[1][2] <= w_r_m[17][0];
        r_i_v[1][3] <= w_r_m[17][1];
        
        r_i_v[2][0] <= w_r_m[2][0];
        r_i_v[2][1] <= w_r_m[2][1];
        r_i_v[2][2] <= w_r_m[18][0];
        r_i_v[2][3] <= w_r_m[18][1];
        
        r_i_v[3][0] <= w_r_m[3][0];
        r_i_v[3][1] <= w_r_m[3][1];
        r_i_v[3][2] <= w_r_m[19][0];
        r_i_v[3][3] <= w_r_m[19][1];
        
        r_i_v[4][0] <= w_r_m[4][0];
        r_i_v[4][1] <= w_r_m[4][1];
        r_i_v[4][2] <= w_r_m[20][0];
        r_i_v[4][3] <= w_r_m[20][1];
        
        r_i_v[5][0] <= w_r_m[5][0];
        r_i_v[5][1] <= w_r_m[5][1];
        r_i_v[5][2] <= w_r_m[21][0];
        r_i_v[5][3] <= w_r_m[21][1];
        
        r_i_v[6][0] <= w_r_m[6][0];
        r_i_v[6][1] <= w_r_m[6][1];
        r_i_v[6][2] <= w_r_m[22][0];
        r_i_v[6][3] <= w_r_m[22][1];
        
        r_i_v[7][0] <= w_r_m[7][0];
        r_i_v[7][1] <= w_r_m[7][1];
        r_i_v[7][2] <= w_r_m[23][0];
        r_i_v[7][3] <= w_r_m[23][1];
        
        r_i_v[8][0] <= w_r_m[8][0];
        r_i_v[8][1] <= w_r_m[8][1];
        r_i_v[8][2] <= w_r_m[24][0];
        r_i_v[8][3] <= w_r_m[24][1];
        
        r_i_v[9][0] <= w_r_m[9][0];
        r_i_v[9][1] <= w_r_m[9][1];
        r_i_v[9][2] <= w_r_m[25][0];
        r_i_v[9][3] <= w_r_m[25][1];
        
        r_i_v[10][0] <= w_r_m[10][0];
        r_i_v[10][1] <= w_r_m[10][1];
        r_i_v[10][2] <= w_r_m[26][0];
        r_i_v[10][3] <= w_r_m[26][1];
        
        r_i_v[11][0] <= w_r_m[11][0];
        r_i_v[11][1] <= w_r_m[11][1];
        r_i_v[11][2] <= w_r_m[27][0];
        r_i_v[11][3] <= w_r_m[27][1];
        
        r_i_v[12][0] <= w_r_m[12][0];
        r_i_v[12][1] <= w_r_m[12][1];
        r_i_v[12][2] <= w_r_m[28][0];
        r_i_v[12][3] <= w_r_m[28][1];
        
        r_i_v[13][0] <= w_r_m[13][0];
        r_i_v[13][1] <= w_r_m[13][1];
        r_i_v[13][2] <= w_r_m[29][0];
        r_i_v[13][3] <= w_r_m[29][1];
        
        r_i_v[14][0] <= w_r_m[14][0];
        r_i_v[14][1] <= w_r_m[14][1];
        r_i_v[14][2] <= w_r_m[30][0];
        r_i_v[14][3] <= w_r_m[30][1];
        
        r_i_v[15][0] <= w_r_m[15][0];
        r_i_v[15][1] <= w_r_m[15][1];
        r_i_v[15][2] <= w_r_m[31][0];
        r_i_v[15][3] <= w_r_m[31][1];
    end
    else begin
    for (i = 0; i < 16; i = i + 1) begin
        r_i_v[i][0]<=16'b0;
        r_i_v[i][1]<=16'b0;
        r_i_v[i][2]<=16'b0;
        r_i_v[i][3]<=16'b0;
        end
    end

end

//control the reg done signal 
always@(posedge clk or posedge rst)
begin
    if(rst)
        r_done<=1'b0;
    else if(r_current_state==S_done && r_state_cnt<5'd16)
        r_done<=1'b1;
    else
        r_done<=1'b0;
end

//control the signal r_valid
always@(posedge clk or posedge rst)
begin
    if(rst)
        r_valid<=1'b0;
    else
        r_valid<=r_done;
end

// always@(posedge clk or posedge rst)
// begin
//     if(rst)

//     else if()

//     else if()

//     else

// end

endmodule
