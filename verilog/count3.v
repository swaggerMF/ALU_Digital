// Code your design here
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
  assign RST_N = ((~ s0 & s1 & s2) | RST);
  assign OUT[0] = s0;
  assign OUT[1] = s1;
  assign OUT[2] = s2;
endmodule