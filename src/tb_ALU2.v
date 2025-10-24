// Code your testbench here
// or browse Examples


`timescale 1ns / 1ps

module tb_RCA8;

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
    op=1;
    RST=0;#20;
    RST=1;#20;
    RST=0;
    inbus=99;#20;
    #20;
    inbus=55;
    #150
    Begin=0;#10;
	//inmultirea
   	Begin=1;
    op=2;
    inbus=32;
    RST=0;#20;
    RST=1;#20;
    RST=0;#30;
    inbus=25;#20;
	#1500;
    Begin=0;#10;
	//impartirea
    Begin=1;  
    op=3;
    RST=0;#20;
    RST=1;#20;
    RST=0;
    inbus=8'b00001001;#10;
    inbus=8'b10011001;#20;
   
    inbus=25;
	#1500;
    $finish;
  end

endmodule
