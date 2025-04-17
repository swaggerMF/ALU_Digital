
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