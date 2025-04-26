
module RS_FF (
  input R,
  input S,
  output Q,
  output nQ 
);
  wire nQ_temp;
  wire Q_temp;

  assign Q_temp = ~(R | nQ_temp); // setare/resetare
  assign nQ_temp = ~(Q_temp | S);

  assign Q = Q_temp;
  assign nQ = nQ_temp;
endmodule

// JK Flip-Flop asincron cu preset si clear 
module JK_FF_AS #(parameter Default = 1'b0)(
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
            state <= 1'b1; // Q = 1 la set
        else if (Clr)
            state <= 1'b0; // Q = 0 la reset
        else if (~J & K)
            state <= 1'b0;
        else if (J & ~K)
            state <= 1'b1;
        else if (J & K)
            state <= ~state; // toggle
    end

    initial begin
        state = Default;
    end
endmodule

// JK Flip-Flop sincron, fara Set/Clr
module JK_FF #(parameter Default = 1'b0)(
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

// D Flip-Flop cu reset asincron
module D_FF ( 
  input D,
  input CLK,
  input R,
  output Q,
  output nQ 
);
  wire s0, s1, s2, s3;
  wire nQ_temp, Q_temp;

  assign s2 = ~R;
  assign s1 = ~(~(s0 & s1) & CLK & s2);
  assign s3 = ~(s1 & CLK & s0);
  assign s0 = ~(s3 & D & s2);
  assign nQ_temp = ~(Q_temp & s3 & s2);
  assign Q_temp = ~(s1 & nQ_temp);

  assign Q = Q_temp;
  assign nQ = nQ_temp;
endmodule


module Mux_4to1 #(parameter Bits = 2)(
    input [1:0] sel,
    input [(Bits-1):0] in_0,
    input [(Bits-1):0] in_1,
    input [(Bits-1):0] in_2,
    input [(Bits-1):0] in_3,
    output reg [(Bits-1):0] out
);
    always @ (*) begin
        case (sel)
            2'h0: out = in_0;
            2'h1: out = in_1;
            2'h2: out = in_2;
            2'h3: out = in_3;
            default: out = 'h0; // valoare implicita
        endcase
    end
endmodule


module Mux_2to1(
    input [0:0] sel,
    input in_0,
    input in_1,
    output reg out
);
    always @ (*) begin
        case (sel)
            1'h0: out = in_0;
            1'h1: out = in_1;
            default: out = 'h0;
        endcase
    end
endmodule


module counter_nbit #(parameter N = 4, parameter INIT = 0)(
  input CNT,
  input CLK,
  input RST,
  output [N-1:0] OUT
);
  wire [N-1:0] s, nQ;
  wire RST_N;

  genvar i;
  generate
    for (i = 0; i < N; i = i + 1) begin : v_counter
      wire enable;
      if (i == 0)
        assign enable = CNT;
      else
        assign enable = CNT & (&s[i-1:0]); // Toate precedentele pe 1

      JK_FF_AS #(.Default(INIT)) JK_FF_AS_i (
        .Set(1'b0),
        .J(enable),
        .C(CLK),
        .K(enable),
        .Clr(RST_N),
        .Q(s[i]),
        .nQ(nQ[i])
      );
    end
  endgenerate

  assign RST_N = (&s) | RST; // reset cand toti sunt 1 sau manual
  assign OUT = s;
endmodule

// Driver pentru magistrală
module DriverBus#(parameter Bits = 2)(
    input [(Bits-1):0] in,
    input sel,
    output [(Bits-1):0] out
);
	assign out = (sel == 1'b1)? in : {Bits{1'bz}};
endmodule


module Register #(
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
  wire [6:0] carry;

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : v
      if (i == 0) begin
        FAC FAC_i (
          .X(X[i]),
          .Y(Y[i]),
          .C_in(c_in),
          .Cout(carry[i]),
          .Z(Z[i])
        );
      end else if (i == 7) begin
        FAC FAC_i (
          .X(X[i]),
          .Y(Y[i]),
          .C_in(carry[i-1]),
          .Cout(c_out),
          .Z(Z[i])
        );
      end else begin
        FAC FAC_i (
          .X(X[i]),
          .Y(Y[i]),
          .C_in(carry[i-1]),
          .Cout(carry[i]),
          .Z(Z[i])
        );
      end
    end
  endgenerate
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
  
  counter_nbit #(
    .N(3),
    .INIT(0)
  )counter3 (
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
  wire fi0;
  wire fi1;
  wire fi2;
  wire fi3;
  wire fi4;
  wire fi5;
  wire out_Cycle0;
  wire rset_Cycle0;
  wire set_Cycle0;
  wire rset_Cycle_1_8;
  wire set_Cycle_1_8;
  wire out_Cycle_1_8;
  wire rset_Cycle9;
  wire set_Cycle9;
  wire out_Cycle9;
  wire inm;
  wire imp;
  wire adun;
  wire scad;
 
  wire c3_temp;
  wire set_END;
  wire c8_temp;
 

   assign inm = (~ OP[0] & OP[1]);
   assign imp = (OP[0] & OP[1]);
   assign adun = (~ OP[0] & ~ OP[1]);
   assign scad = (OP[0] & ~ OP[1]);
  sequnceCNTmod sequnceCNTmod_i0 (
    .CLK( CLK ),
    .BGN( BGN ),
    .RST( RST ),
    .END ( END  ),
    .fi0 ( fi0 ),
    .fi1 ( fi1 ),
    .fi2 ( fi2 ),
    .fi3 ( fi3 ),
    .fi4 ( fi4 ),
    .fi5 ( fi5 )
  );
   assign c0 = (inm & fi0 & out_Cycle0);
   assign c0_prim  = (fi0 & ~ inm & out_Cycle0);
   assign c1 = (out_Cycle0 & (imp | inm) & fi1);
   assign c3_temp = (((adun | scad) & fi3) | (inm & (Q0 ^ Q_1 ) & fi0 & out_Cycle_1_8) | (out_Cycle_1_8 & imp & fi3 & A7) | (A7 & out_Cycle9 & imp & fi0) | (out_Cycle_1_8 & fi1 & imp));
   assign c4 = ((c3_temp & scad) | (c3_temp & inm & Q0 & ~ Q_1 ) | (c3_temp & fi1 & imp));
   assign cR = (inm & out_Cycle_1_8 & ~ CNT7 & fi1);
   assign cL = (imp & fi0 & out_Cycle_1_8);
   assign c5 = (imp & fi2 & out_Cycle_1_8);
   assign c7 = (out_Cycle9 & (adun | (inm & fi0) | (fi1 & imp) | scad));
   assign c6 = ((inm & fi2 & ~ CNT7 & out_Cycle_1_8) | (imp & fi4 & ~ CNT7 & out_Cycle_1_8));
   assign c7_5  = (inm & fi1 & out_Cycle9);
   assign set_Cycle9 = (((scad | adun) & fi5) | (fi5 & CNT7));
   assign rset_Cycle0 = (RST | set_Cycle_1_8);
   assign rset_Cycle_1_8 = (RST | set_Cycle9);
   assign rset_Cycle9 = (END  | RST);
   assign set_Cycle0 = (~ out_Cycle_1_8 & ~ out_Cycle9 & ~ END  & ~ (fi5 & BGN));
   RS_FF RS_FF_i1 ( //ff care mentine semnalul c8 cat sa se activeze END
    .R( RST ),
    .S( set_END ),
    .Q( c8_temp )
  );
   
  RS_FF RS_FF_i3 ( //ff Cycle 0
    .R( rset_Cycle0 ),
    .S( set_Cycle0 ),
    .Q( out_Cycle0 )
  );
   
   assign c2 = (out_Cycle0 & fi2);
   assign set_Cycle_1_8 = (fi5 & out_Cycle0);
   
   RS_FF RS_FF_i4 ( //ff Cycle 1-8
    .R( rset_Cycle_1_8 ),
    .S( set_Cycle_1_8 ),
    .Q( out_Cycle_1_8 )
  );
   
   assign END = c8_temp;
   RS_FF RS_FF_i2 ( //ff Cycle 9
    .R( rset_Cycle9 ),
    .S( set_Cycle9 ),
     .Q( out_Cycle9 )
  );
   
  assign set_END = (fi2 & out_Cycle9);
  assign c3 = c3_temp;
  assign c8 = c8_temp;
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
  wire [7:0] q;
  wire [7:0] j;
  wire [7:0] k;

  wire [7:0] left_in;
  wire [7:0] right_in;

  // intrari shift left
  assign left_in[0] = IN_SL;
  assign left_in[1] = q[0];
  assign left_in[2] = q[1];
  assign left_in[3] = q[2];
  assign left_in[4] = q[3];
  assign left_in[5] = q[4];
  assign left_in[6] = q[5];
  assign left_in[7] = q[6];

  // intrari shift right
  assign right_in[0] = q[1];
  assign right_in[1] = q[2];
  assign right_in[2] = q[3];
  assign right_in[3] = q[4];
  assign right_in[4] = q[5];
  assign right_in[5] = q[6];
  assign right_in[6] = q[7];
  assign right_in[7] = IN_SR;

  
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : v_shft
      wire sr_part, sl_part, ld_part;

      assign sr_part = SR & right_in[i];
      assign sl_part = SL & left_in[i];
      assign ld_part = LD & IN[i];

      assign j[i] = sr_part | sl_part | ld_part;
      assign k[i] = ~j[i];

      JK_FF #(.Default(0)) FF (
        .J(j[i]),
        .K(k[i]),
        .C(CLK),
        .Q(q[i])
      );
    end
  endgenerate

  assign O = q;
  assign O_sr = q[0];
  assign O_sl = q[7];

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
  wire Q_1 ;
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
  wire [7:0] inbus_A; //input de pe inbus pt A, cand c0 activ e 0, cand nu ia de pe inbus 
  wire [7:0] A; //A din registru
  wire [7:0] inA; //iesire mux A
  wire [7:0] Q; 
  wire [7:0] Q_new; 
  wire [7:0] inQ;  
  wire [7:0] M;	//ce vine de pe inbus in driver 
  wire [7:0] M_reg; //ce vine din driver in registrul M 
  wire [1:0] sel_muxA; //conditie mux A 
  wire [1:0] sel_muxQ; //conditie mux Q 
  wire [7:0] addordif_term; //termenul pt adunare sau scadere
  wire [7:0] sum; //rezultatul dat de parallel adder
  wire [7:0] XOR_mask;
  wire bit_sh_left;
  wire L;
  wire bit_sh_right;
  wire o_sr; //iasa din Q
  wire [3:0] O_cnt; //output counter
  wire out_muxQ_1;
  wire [7:0] en_bus_A;
  
  //control unit
  
  ALU_CU ALU_CU_i0 (
    .BGN( Begin  ),
    .RST( RST ),
    .CLK( CLk ),
    .CNT7( cnt7 ),
    .Q0( Q[0] ),
    .Q_1 ( Q_1  ),
    .A7( A[7]  ),
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
  
  assign L = (~ cR & ~ cL);
  assign shft = (cL | cR);
  
  //A
  
  assign inbus_A = ( ~en_bus_A & inbus);
  assign en_bus_A={c0, c0, c0, c0, c0, c0, c0, c0};
  
  assign sel_muxA[0] = ((c0 | c0_prim ) | c3); 
  assign sel_muxA[1] = c3;
  
   Mux_4to1 #(
    .Bits(8)
  )
  Mux_4to1_A (
    .sel( sel_muxA ),
    .in_0( A ),
    .in_1( inbus_A ),
    .in_2( A ),
    .in_3( sum ),
    .out( inA )
  );
  
  shf2 Reg_A (
    .CLK( CLk ),
    .SR( cR ),
    .SL( cL ),
    .IN_SR( A[7]  ),
    .IN_SL( bit_sh_left ),
    .IN( inA ),
    .LD( L ),
    .O_sr( bit_sh_right ),
    .O( A )
  );
  
  //Q
  
  assign sel_muxQ[0] = (c1 | c5 | c7_5 ); 
  assign sel_muxQ[1] = (c5 | c7_5 );
  
  Mux_4to1 #(
    .Bits(8)
  )
  Mux_4to1_Q (
    .sel( sel_muxQ ),
    .in_0( Q ),
    .in_1( inbus ),
    .in_2( Q ),
    .in_3( Q_new ),
    .out( inQ )
  );
  
   
  shf2 Reg_Q (
    .CLK( CLk ),
    .SR( cR ),
    .SL( cL ),
    .IN_SR( bit_sh_right ),
    .IN_SL( ~A[7] ),
    .IN( inQ ),
    .LD( L ),
    .O_sr( o_sr ),
    .O_sl( bit_sh_left ),
    .O( Q )
  );
 
   assign Q_new={ Q[7], Q[6], Q[5], Q[4],  Q[3], Q[2], Q[1], ~A[7] & c5 };
  
  //Q[-1]
  
    Mux_2to1 Mux_Q_1 (
    .sel( shft | c1 ),
    .in_0( Q_1  ),
    .in_1(o_sr ),
    .out( out_muxQ_1 )
  );
  
  D_FF D_FF_Q_1 (
    .D( out_muxQ_1 ),
    .CLK( CLk ),
    .R( RST ),
    .Q( Q_1  )
  );
  
   //M
  
  DriverBus #(
    .Bits(8)
  )
  DriverBus_M_in (
    .in( inbus ),
    .sel( c2 ),
    .out( M )
  );
  
    Register #(
    .Bits(8)
  )
  Register_M (
    .D( M ),
    .C( CLk ),
    .en( c2 ),
    .Q( M_reg )
  );
  
  //count7
  
  counter_nbit #(
    .N(4),
    .INIT(0)
  )
  counter4 (
    .CNT( c6 ),
    .CLK( CLk ),
    .RST( RST ),
    .OUT( O_cnt )
  );
  
  assign cnt7 = (~ O_cnt[0] & ~ O_cnt[1] & ~ O_cnt[2] & O_cnt[3]); 
  
  // Parallel-Adder
  
  assign XOR_mask={c4, c4, c4, c4, c4, c4, c4, c4};
  assign addordif_term = (XOR_mask ^ M_reg);
  
  RCA8 RCA8_i8 (
    .c_in( c4 ),
    .Y( addordif_term ),
    .X( A ),
    .Z( sum )
  );
 
  //outbus
  
  DriverBus #(
    .Bits(8)
  )
  DriverBus_Q_out (
    .in( Q ),
    .sel( c8 ),
    .out( outbus )
  );
  
  DriverBus #(
    .Bits(8)
  )
  DriverBus_A_out (
    .in( A ),
    .sel( c7 ),
    .out( outbus )
  );
  

endmodule
