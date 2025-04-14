// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_sequnceCNTmod;

  // Declararea semnalelor
  reg CLK;
  reg BGN;
  reg RST;
  reg END;
  wire fi0;
  wire fi1;
  wire fi2;
  wire fi3;
  wire fi4;
  wire fi5;

  // Instanțierea modulului testat
  sequnceCNTmod uut (
    .CLK(CLK),
    .BGN(BGN),
    .RST(RST),
    .END(END),
    .fi0(fi0),
    .fi1(fi1),
    .fi2(fi2),
    .fi3(fi3),
    .fi4(fi4),
    .fi5(fi5)
  );

  // Inițializare și aplicare stimuli
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    $display("Time\tCLK\tBGN\tRST\tEND\tfi0\tfi1\tfi2\tfi3\tfi4\tfi5");
    $monitor("%g\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", $time, CLK, BGN, RST, END, fi0, fi1, fi2, fi3, fi4, fi5);

    // Inițializare
    BGN=1; #10;
    CLK=0; #10;
    CLK=1; #10;
  	END=0;
    CLK=0; #10;
    RST=0; 
    CLK=1; #10;
    RST=1;
    CLK=0; #10;
    RST=0;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;
    END=1;
    CLK=0; #10;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;
    CLK=0; #10;
    CLK=1; #10;


    $finish;
  end

endmodule