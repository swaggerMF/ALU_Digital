// Code your testbench here
// or browse Examples


`timescale 1ns / 1ps

module tb_ALU2;

  // Declararea semnalelor
  reg CLk;
  reg [7:0]inbus;
  reg [1:0]op;
  reg Begin;
  reg RST;
  wire [7:0]outbus;

  // Instanțierea modulului testat
  ALU_2 uut (
    .inbus(inbus),
    .op(op),
    .CLk(CLk),
    .Begin(Begin),
    .RST(RST),
    .outbus(outbus)
  );

  // Inițializare și aplicare stimuli
   initial begin
    $dumpfile("dump.vcd"); $dumpvars;
	CLk=0;
   end
  
  always begin
    #10; CLk=~CLk; 
  end
  
  initial begin
   // $display("c_in\tX\t\tY\t\tZ\tc_out");
   //$monitor("%b\t%b\t%b\t%b\t%b",c_in, X, Y, Z, c_out);

    // Inițializare
    //adunarea
   	op=0;
    inbus=24;
	Begin=1;
    RST=0;#20;
    RST=1;#20;
    RST=0;#20;
    inbus=31;
	#150;
    Begin=0;#10;
    //scaderea
    Begin=1;
    RST=0;#20;
    RST=1;#20;
    RST=0;
    inbus=25;#20;
	op=1;
    #20;
    inbus=16;
    #200
    $finish;
  end

endmodule
