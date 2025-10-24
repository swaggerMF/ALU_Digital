// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module tb_counter3;

  // Declararea semnalelor
  reg CNT;
  reg CLK;
  reg RST;
  wire [2:0] OUT;

  // Instanțierea modulului testat
  counter3 uut (
    .CNT(CNT),
    .CLK(CLK),
    .RST(RST),
    .OUT(OUT)
  );

  // Inițializare și aplicare stimuli
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    $display("Time\tCNT\tCLK\tRST\tOUT");
    $monitor("%g\t%b\t%b\t%b\t%b", $time, CNT, CLK, RST, OUT);

    // Inițializare
    CNT=1; #10;
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
    


    $finish;
  end

endmodule