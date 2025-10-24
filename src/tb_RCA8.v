// Code your testbench here
// or browse Examples


`timescale 1ns / 1ps

module tb_RCA8;

  // Declararea semnalelor
  reg c_in;
  reg [7:0]Y;
  reg [7:0]X;
  wire c_out;
  wire [7:0]Z;

  // Instanțierea modulului testat
  RCA8 uut (
    .c_in(c_in),
    .X(X),
    .Y(Y),
    .c_out(c_out),
    .Z(Z)
  );

  // Inițializare și aplicare stimuli
 
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    $display("c_in\tX\t\tY\t\tZ\tc_out");
    $monitor("%b\t%b\t%b\t%b\t%b",c_in, X, Y, Z, c_out);

    // Inițializare
   c_in=1;
   X=10;
   Y=20;
   #100;



    $finish;
  end

endmodule
