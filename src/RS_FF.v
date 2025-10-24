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