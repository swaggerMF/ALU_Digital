/*
 * Generated by Digital. Don't modify this file!
 * Any changes will be lost if this file is regenerated.
 */
module RS_FF (
  input R,
  input S,
  output Q,
  output nQ 
);
  wire nQ_temp ;
  wire Q_temp;
  assign Q_temp = ~ (R | nQ_temp );
  assign nQ_temp  = ~ (Q_temp | S);
  assign Q = Q_temp;
  assign nQ  = nQ_temp ;
endmodule

module DIG_JK_FF_AS
#(
    parameter Default = 1'b0
)
(
   input Set,
   input J,
   input C,
   input K,
   input Clr,
   output Q,
   output nQ
);
    reg state;

    assign Q = state;
    assign nQ = ~state;

    always @ (posedge C or posedge Clr or posedge Set) begin
        if (Set)
            state <= 1'b1;
        else if (Clr)
            state <= 1'b0;
        else if (~J & K)
            state <= 1'b0;
        else if (J & ~K)
            state <= 1'b1;
        else if (J & K)
            state <= ~state;
    end

    initial begin
        state = Default;
    end
endmodule

module counter3 (
  input CNT,
  input CLK,
  input RST,
  output [2:0] OUT
);
  wire s0;
  wire s1;
  wire s2;
  wire RST_N;
  wire s3;
  wire s4;
  DIG_JK_FF_AS #(
    .Default(0)
  )
  DIG_JK_FF_AS_i0 (
    .Set( 1'b0 ),
    .J( CNT ),
    .C( CLK ),
    .K( CNT ),
    .Clr( RST_N ),
    .Q( s0 ),
    .nQ ( s3 )
  );
  DIG_JK_FF_AS #(
    .Default(0)
  )
  DIG_JK_FF_AS_i1 (
    .Set( 1'b0 ),
    .J( CNT ),
    .C( s3 ),
    .K( CNT ),
    .Clr( RST_N ),
    .Q( s1 ),
    .nQ ( s4 )
  );
  DIG_JK_FF_AS #(
    .Default(0)
  )
  DIG_JK_FF_AS_i2 (
    .Set( 1'b0 ),
    .J( CNT ),
    .C( s4 ),
    .K( CNT ),
    .Clr( RST_N ),
    .Q( s2 )
  );
  assign RST_N = ((s2 & s1 & ~s0) | RST);
  assign OUT[0] = s0;
  assign OUT[1] = s1;
  assign OUT[2] = s2;
endmodule

module Dec3to5 (
  input [2:0]sel,
  output O0,
  output O1,
  output O2,
  output O3,
  output O4,
  output O5
);
  wire s0;
  wire s1;
  wire s2;
  wire s3;
  wire s4;
  wire s5;
  assign s3 = sel[0];
  assign s4 = sel[1];
  assign s5 = sel[2];
  assign s2 = ~ s5;
  assign s1 = ~ s4;
  assign s0 = ~ s3;
  assign O0 = (s0 & s1 & s2);
  assign O1 = (s2 & s1 & s3);
  assign O2 = (s2 & s4 & s0);
  assign O3 = (s2 & s4 & s3);
  assign O4 = (s5 & s1 & s0);
  assign O5 = (s5 & s1 & s3);
endmodule

module sequnceCNTmod (
  input CLK,
  input BGN,
  input RST,
  input END ,
  output fi0 ,
  output fi1 ,
  output fi2 ,
  output fi3 ,
  output fi4 ,
  output fi5 
);
  wire s0;
  wire s1;
  wire [2:0] s2;
  RS_FF RS_FF_i0 (
    .R( END  ),
    .S( BGN ),
    .Q( s0 )
  );
  assign s1 = (s0 & RST);
  counter3 counter3_i1 (
    .CNT( s0 ),
    .CLK( CLK ),
    .RST( s1 ),
    .OUT( s2 )
  );
  Dec3to5 Dec3to5_i2 (
    .sel( s2 ),
    .O0( fi0  ),
    .O1( fi1  ),
    .O2( fi2  ),
    .O3( fi3  ),
    .O4( fi4  ),
    .O5( fi5  )
  );
endmodule

 module ALU_CU (
  input BGN,
  input RST,
  input CLK,
  input CNT7,
  input Q0,
  input Q_1 ,
  input A7,
  input [1:0] OP,
  output c0,
  output c0_prim ,
  output c1,
  output c2,
  output c3,
  output c4,
  output cR,
  output cL,
  output c5,
  output c7,
  output c8,
  output c6,
  output c7_5 
);
  wire END ;
  wire s0;
  wire s1;
  wire s2;
  wire s3;
  wire s4;
  wire s5;
  wire s6;
  wire s7;
  wire s_C2;
  wire s8;
  wire s9;
  wire C3;
  wire s10;
  wire s11;
  wire s12;
  wire s13;
  wire adun;
  wire scad;
  wire s14;
  wire c3_temp;
  wire s15;
  wire c8_temp;
  wire s16;
  wire s17;
  assign s10 = OP[0];
  assign s11 = OP[1];
  assign s12 = (~ s10 & s11);
  assign s13 = (s10 & s11);
  assign adun = (~ s10 & ~ s11);
  assign scad = (s10 & ~ s11);
  sequnceCNTmod sequnceCNTmod_i0 (
    .CLK( CLK ),
    .BGN( BGN ),
    .RST( RST ),
    .END ( END  ),
    .fi0 ( s0 ),
    .fi1 ( s1 ),
    .fi2 ( s2 ),
    .fi3 ( s3 ),
    .fi4 ( s4 ),
    .fi5 ( s5 )
  );
  assign c0 = (s12 & s0 & s14);
  assign c0_prim  = (s0 & ~ s12 & s14);
  assign c1 = (s14 & (s13 | s12) & s1);
   assign c3_temp = (((adun | scad) & s3) | (s12 & (Q0 ^ Q_1 ) & s0 & s_C2) | (s_C2 & s13 & s3 & A7) | (A7 & C3 & s13 & s0) | (s_C2 & s1 & s13));
   assign c4 = ((c3_temp & scad) | (c3_temp & s12 & Q0 & ~ Q_1 ) | (c3_temp & s1 & s13));
  assign cR = (s12 & s_C2 & ~ CNT7 & s1);
  assign cL = (s13 & s0 & s_C2);
  assign c5 = (s13 & s2 & s_C2);
  assign c7 = (C3 & (adun | (s12 & s0) | (s1 & s13) | scad));
  assign c6 = ((s12 & s2 & ~ CNT7 & s_C2) | (s13 & s4 & ~ CNT7 & s_C2));
  assign c7_5  = (s12 & s1 & C3);
  assign s9 = (((scad | adun) & s5) | (s5 & CNT7));
  assign s16 = (RST | s7);
  assign s6 = (RST | s9);
   assign s8 = (END  | RST);
   assign s17 = (~ s_C2 & ~ C3 & ~ END  & ~ (s5 & BGN));
  RS_FF RS_FF_i1 (
    .R( RST ),
    .S( s15 ),
    .Q( c8_temp )
  );
  RS_FF RS_FF_i2 (
    .R( s8 ),
    .S( s9 ),
    .Q( C3 )
  );
  assign END = c8_temp;
  RS_FF RS_FF_i3 (
    .R( s16 ),
    .S( s17 ),
    .Q( s14 )
  );
  assign c2 = (s14 & s2);
  assign s7 = (s5 & s14);
  assign s15 = (s2 & C3);
  RS_FF RS_FF_i4 (
    .R( s6 ),
    .S( s7 ),
    .Q( s_C2 )
  );
  assign c3 = c3_temp;
  assign c8 = c8_temp;
endmodule


module DriverBus#(
    parameter Bits = 2
)
(
    input [(Bits-1):0] in,
    input sel,
    output [(Bits-1):0] out
);
    assign out = (sel == 1'b1)? in : {Bits{1'bz}};
endmodule

module Mux_4x1_NBits #(
    parameter Bits = 2
)
(
    input [1:0] sel,
    input [(Bits - 1):0] in_0,
    input [(Bits - 1):0] in_1,
    input [(Bits - 1):0] in_2,
    input [(Bits - 1):0] in_3,
    output reg [(Bits - 1):0] out
);
    always @ (*) begin
        case (sel)
            2'h0: out = in_0;
            2'h1: out = in_1;
            2'h2: out = in_2;
            2'h3: out = in_3;
            default:
                out = 'h0;
        endcase
    end
endmodule


module DIG_Counter_Nbit
#(
    parameter Bits = 2
)
(
    output [(Bits-1):0] out,
    output ovf,
    input C,
    input en,
    input clr
);
    reg [(Bits-1):0] count;

    always @ (posedge C) begin
        if (clr)
          count <= 'h0;
        else if (en)
          count <= count + 1'b1;
    end

    assign out = count;
    assign ovf = en? &count : 1'b0;

    initial begin
        count = 'h0;
    end
endmodule


module D_FF (
  input D,
  input CLK,
  input R,
  output Q,
  output nQ 
);
  wire s0;
  wire s1;
  wire s2;
  wire s3;
  wire nQ_temp ;
  wire Q_temp;
  assign s2 = ~ R;
  assign s1 = ~ (~ (s0 & s1) & CLK & s2);
  assign s3 = ~ (s1 & CLK & s0);
  assign s0 = ~ (s3 & D & s2);
  assign nQ_temp  = ~ (Q_temp & s3 & s2);
  assign Q_temp = ~ (s1 & nQ_temp );
  assign Q = Q_temp;
  assign nQ  = nQ_temp ;
endmodule

module DIG_Register_BUS #(
    parameter Bits = 1
)
(
    input C,
    input en,
    input [(Bits - 1):0]D,
    output [(Bits - 1):0]Q
);

    reg [(Bits - 1):0] state = 'h0;

    assign Q = state;

    always @ (posedge C) begin
        if (en)
            state <= D;
   end
endmodule
module DIG_D_FF_1bit
#(
    parameter Default = 0
)
(
   input D,
   input C,
   output Q,
   output nQ
);
    reg state;

    assign Q = state;
    assign nQ = ~state;

    always @ (posedge C) begin
        state <= D;
    end

    initial begin
        state = Default;
    end
endmodule


module FAC (
  input X,
  input Y,
  input C_in,
  output Cout,
  output Z
);
  assign Z = ((X ^ Y) ^ C_in);
  assign Cout = ((X & Y) | (X & C_in) | (Y & C_in));
endmodule

module RCA8 (
  input c_in,
  input [7:0] Y,
  input [7:0] X,
  output c_out,
  output [7:0] Z
);
  wire s0;
  wire s1;
  wire s2;
  wire s3;
  wire s4;
  wire s5;
  wire s6;
  wire s7;
  wire s8;
  wire s9;
  wire s10;
  wire s11;
  wire s12;
  wire s13;
  wire s14;
  wire s15;
  wire s16;
  wire s17;
  wire s18;
  wire s19;
  wire s20;
  wire s21;
  wire s22;
  wire s23;
  wire s24;
  wire s25;
  wire s26;
  wire s27;
  wire s28;
  wire s29;
  wire s30;
  assign s29 = Y[0];
  assign s25 = Y[1];
  assign s21 = Y[2];
  assign s17 = Y[3];
  assign s13 = Y[4];
  assign s9 = Y[5];
  assign s5 = Y[6];
  assign s1 = Y[7];
  assign s28 = X[0];
  assign s24 = X[1];
  assign s20 = X[2];
  assign s16 = X[3];
  assign s12 = X[4];
  assign s8 = X[5];
  assign s4 = X[6];
  assign s0 = X[7];
  FAC FAC_i0 (
    .X( s28 ),
    .Y( s29 ),
    .C_in( c_in ),
    .Cout( s26 ),
    .Z( s30 )
  );
  FAC FAC_i1 (
    .X( s24 ),
    .Y( s25 ),
    .C_in( s26 ),
    .Cout( s22 ),
    .Z( s27 )
  );
  FAC FAC_i2 (
    .X( s20 ),
    .Y( s21 ),
    .C_in( s22 ),
    .Cout( s18 ),
    .Z( s23 )
  );
  FAC FAC_i3 (
    .X( s16 ),
    .Y( s17 ),
    .C_in( s18 ),
    .Cout( s14 ),
    .Z( s19 )
  );
  FAC FAC_i4 (
    .X( s12 ),
    .Y( s13 ),
    .C_in( s14 ),
    .Cout( s10 ),
    .Z( s15 )
  );
  FAC FAC_i5 (
    .X( s8 ),
    .Y( s9 ),
    .C_in( s10 ),
    .Cout( s6 ),
    .Z( s11 )
  );
  FAC FAC_i6 (
    .X( s4 ),
    .Y( s5 ),
    .C_in( s6 ),
    .Cout( s2 ),
    .Z( s7 )
  );
  FAC FAC_i7 (
    .X( s0 ),
    .Y( s1 ),
    .C_in( s2 ),
    .Cout( c_out ),
    .Z( s3 )
  );
  assign Z[0] = s30;
  assign Z[1] = s27;
  assign Z[2] = s23;
  assign Z[3] = s19;
  assign Z[4] = s15;
  assign Z[5] = s11;
  assign Z[6] = s7;
  assign Z[7] = s3;
endmodule
module DIG_JK_FF
#(
    parameter Default = 1'b0
)
(
   input J,
   input C,
   input K,
   output Q,
   output nQ
);
    reg state;

    assign Q = state;
    assign nQ = ~state;

    always @ (posedge C) begin
        if (~J & K)
            state <= 1'b0;
         else if (J & ~K)
            state <= 1'b1;
         else if (J & K)
            state <= ~state;
    end

    initial begin
        state = Default;
    end
endmodule


module shf2 (
  input CLK,
  input SR,
  input SL,
  input IN_SR,
  input IN_SL,
  input [7:0] IN,
  input LD,
  output O_sr,
  output O_sl,
  output [7:0] O
);
  wire s0;
  wire s1;
  wire O_sl_temp;
  wire s2;
  wire s3;
  wire s4;
  wire s5;
  wire s6;
  wire s7;
  wire s8;
  wire s9;
  wire s10;
  wire s11;
  wire O_sr_temp;
  wire s12;
  wire s13;
  wire s14;
  wire s15;
  wire s16;
  wire s17;
  wire s18;
  wire s19;
  wire s20;
  wire s21;
  assign s1 = ((IN_SR & SR) | (IN[7] & LD) | (SL & s0));
  assign s3 = ((O_sl_temp & SR) | (IN[6] & LD) | (SL & s2));
  assign s5 = ((s0 & SR) | (IN[5] & LD) | (SL & s4));
  assign s7 = ((s2 & SR) | (IN[4] & LD) | (SL & s6));
  assign s9 = ((s4 & SR) | (IN[3] & LD) | (SL & s8));
  assign s11 = ((s6 & SR) | (IN[2] & LD) | (SL & s10));
  assign s12 = ((s8 & SR) | (IN[1] & LD) | (SL & O_sr_temp));
  assign s13 = ((s10 & SR) | (IN[0] & LD) | (SL & IN_SL));
  assign s14 = ~ s1;
  assign s15 = ~ s3;
  assign s16 = ~ s5;
  assign s17 = ~ s7;
  assign s18 = ~ s9;
  assign s19 = ~ s11;
  assign s20 = ~ s12;
  assign s21 = ~ s13;
  DIG_JK_FF #(
    .Default(0)
  )
  DIG_JK_FF_i0 (
    .J( s1 ),
    .C( CLK ),
    .K( s14 ),
    .Q( O_sl_temp )
  );
  DIG_JK_FF #(
    .Default(0)
  )
  DIG_JK_FF_i1 (
    .J( s3 ),
    .C( CLK ),
    .K( s15 ),
    .Q( s0 )
  );
  DIG_JK_FF #(
    .Default(0)
  )
  DIG_JK_FF_i2 (
    .J( s5 ),
    .C( CLK ),
    .K( s16 ),
    .Q( s2 )
  );
  DIG_JK_FF #(
    .Default(0)
  )
  DIG_JK_FF_i3 (
    .J( s7 ),
    .C( CLK ),
    .K( s17 ),
    .Q( s4 )
  );
  DIG_JK_FF #(
    .Default(0)
  )
  DIG_JK_FF_i4 (
    .J( s9 ),
    .C( CLK ),
    .K( s18 ),
    .Q( s6 )
  );
  DIG_JK_FF #(
    .Default(0)
  )
  DIG_JK_FF_i5 (
    .J( s11 ),
    .C( CLK ),
    .K( s19 ),
    .Q( s8 )
  );
  DIG_JK_FF #(
    .Default(0)
  )
  DIG_JK_FF_i6 (
    .J( s12 ),
    .C( CLK ),
    .K( s20 ),
    .Q( s10 )
  );
  DIG_JK_FF #(
    .Default(0)
  )
  DIG_JK_FF_i7 (
    .J( s13 ),
    .C( CLK ),
    .K( s21 ),
    .Q( O_sr_temp )
  );
  assign O[0] = O_sr_temp;
  assign O[1] = s10;
  assign O[2] = s8;
  assign O[3] = s6;
  assign O[4] = s4;
  assign O[5] = s2;
  assign O[6] = s0;
  assign O[7] = O_sl_temp;
  assign O_sr = O_sr_temp;
  assign O_sl = O_sl_temp;
endmodule

module Mux_2x1
(
    input [0:0] sel,
    input in_0,
    input in_1,
    output reg out
);
    always @ (*) begin
        case (sel)
            1'h0: out = in_0;
            1'h1: out = in_1;
            default:
                out = 'h0;
        endcase
    end
endmodule


module ALU_2 (
  input [7:0] inbus,
  input [1:0] op,
  input CLk,
  input Begin ,
  input RST,
  output [7:0] outbus
);
  wire cnt7;
  wire Q_0 ;
  wire Q_1 ;
  wire A7 ;
  wire c0;
  wire c0_prim ;
  wire c1;
  wire c2;
  wire c3;
  wire c4;
  wire cR;
  wire cL;
  wire c5;
  wire c7;
  wire c8;
  wire c6;
  wire c7_5 ;
  wire [7:0] s0;
  wire [7:0] O_A;
  wire [7:0] add;
  wire [7:0] s1;
  wire [7:0] s2;
  wire [7:0] s3;
  wire [1:0] s4;
  wire [7:0] s5;
  wire [7:0] inA;
  wire [1:0] s6;
  wire [7:0] O_Q;
  wire [7:0] s7;
  wire [7:0] inQ;
  wire [6:0] s8;
  wire [6:0] s9;
  wire s10;
  wire s11;
  wire s12;
  wire L;
  wire s13;
  wire s14;
  wire s15;
  wire s16;
  wire s17;
  wire shft;
  wire O_SR;
  wire s18;
  wire s19;
  wire [3:0] s20;
  wire [1:0] s21;
  wire s22;
  wire [7:0] s23;
  ALU_CU ALU_CU_i0 (
    .BGN( Begin  ),
    .RST( RST ),
    .CLK( CLk ),
    .CNT7( cnt7 ),
    .Q0( Q_0  ),
    .Q_1 ( Q_1  ),
    .A7( A7  ),
    .OP( op ),
    .c0( c0 ),
    .c0_prim ( c0_prim  ),
    .c1( c1 ),
    .c2( c2 ),
    .c3( c3 ),
    .c4( c4 ),
    .cR( cR ),
    .cL( cL ),
    .c5( c5 ),
    .c7( c7 ),
    .c8( c8 ),
    .c6( c6 ),
    .c7_5 ( c7_5  )
  );
  DriverBus #(
    .Bits(8)
  )
  DriverBus_i1 (
    .in( inbus ),
    .sel( c2 ),
    .out( s1 )
  );
  Mux_4x1_NBits #(
    .Bits(8)
  )
  Mux_4x1_NBits_i2 (
    .sel( s6 ),
    .in_0( O_Q ),
    .in_1( inbus ),
    .in_2( O_Q ),
    .in_3( s7 ),
    .out( inQ )
  );
  DIG_Counter_Nbit #(
    .Bits(4)
  )
  DIG_Counter_Nbit_i3 (
    .en( c6 ),
    .C( CLk ),
    .clr( RST ),
    .out( s20 )
  );
  D_FF D_FF_i4 (
    .D( s22 ),
    .CLK( CLk ),
    .R( RST ),
    .Q( Q_1  )
  );
  assign s5 = (~ s23 & inbus);
  // M
  DIG_Register_BUS #(
    .Bits(8)
  )
  DIG_Register_BUS_i5 (
    .D( s1 ),
    .C( CLk ),
    .en( c2 ),
    .Q( s2 )
  );
  assign s3[0] = c4;
  assign s3[1] = c4;
  assign s3[2] = c4;
  assign s3[3] = c4;
  assign s3[4] = c4;
  assign s3[5] = c4;
  assign s3[6] = c4;
  assign s3[7] = c4;
  assign L = (~ cR & ~ cL);
  assign shft = (cL | cR);
  assign cnt7 = (~ s20[0] & ~ s20[1] & ~ s20[2] & s20[3]);
  assign s21[0] = c7;
  assign s21[1] = c8;
  assign s18 = (c5 | c7_5 );
  assign s23[0] = c0;
  assign s23[1] = c0;
  assign s23[2] = c0;
  assign s23[3] = c0;
  assign s23[4] = c0;
  assign s23[5] = c0;
  assign s23[6] = c0;
  assign s23[7] = c0;
  assign s0 = (s3 ^ s2);
  DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i6 (
    .D( shft ),
    .C( CLk ),
    .Q( s17 )
  );
  DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i7 (
    .D( shft ),
    .C( CLk ),
    .Q( s10 )
  );
  assign s4[0] = ((c0 | c0_prim ) | c3);
  assign s4[1] = (s17 | c3);
  assign s11 = (c1 | s10);
  assign s6[0] = (c1 | s18);
  assign s6[1] = (s18 | s10);
  // Parallel-Adder
  RCA8 RCA8_i8 (
    .c_in( c4 ),
    .Y( s0 ),
    .X( O_A ),
    .Z( add )
  );
  Mux_4x1_NBits #(
    .Bits(8)
  )
  Mux_4x1_NBits_i9 (
    .sel( s4 ),
    .in_0( O_A ),
    .in_1( s5 ),
    .in_2( O_A ),
    .in_3( add ),
    .out( inA )
  );
  shf2 shf2_i10 (
    .CLK( CLk ),
    .SR( cR ),
    .SL( cL ),
    .IN_SR( A7  ),
    .IN_SL( s12 ),
    .IN( inA ),
    .LD( L ),
    .O_sr( s13 ),
    .O_sl( s14 ),
    .O( O_A )
  );
  shf2 shf2_i11 (
    .CLK( CLk ),
    .SR( cR ),
    .SL( cL ),
    .IN_SR( s13 ),
    .IN_SL( s15 ),
    .IN( inQ ),
    .LD( L ),
    .O_sr( s16 ),
    .O_sl( s12 ),
    .O( O_Q )
  );
  assign s7[0] = (~ c7_5  & ~ A7  & c5);
  assign s7[1] = O_Q[1];
  assign s7[2] = O_Q[2];
  assign s7[3] = O_Q[3];
  assign s7[4] = O_Q[4];
  assign s7[5] = O_Q[5];
  assign s7[6] = O_Q[6];
  assign s7[7] = O_Q[7];
  Mux_4x1_NBits #(
    .Bits(8)
  )
  Mux_4x1_NBits_i12 (
    .sel( s21 ),
    .in_0( 8'b0 ),
    .in_1( O_Q ),
    .in_2( O_A ),
    .in_3( 8'b0 ),
    .out( outbus )
  );
  Mux_2x1 Mux_2x1_i13 (
    .sel( s11 ),
    .in_0( Q_1  ),
    .in_1( O_SR ),
    .out( s22 )
  );
  DIG_D_FF_1bit #(
    .Default(0)
  )
  DIG_D_FF_1bit_i14 (
    .D( s16 ),
    .C( CLk ),
    .Q( O_SR )
  );
  assign Q_0  = O_Q[0];
  assign s8 = O_Q[7:1];
  assign s9 = O_A[6:0];
  assign A7  = O_A[7];
  assign s19 = O_Q[0];
  assign s15 = ~ A7 ;
endmodule
