
`timescale 1ns / 1ps

module tb_sequnceCNTmod;

  // Declararea semnalelor
  reg CLK;
  reg BGN;
  reg RST;
  reg CNT7;
  reg Q0;
  reg Q_1;
  reg A7;
  reg [1:0]OP;
  wire c0;
  wire c0_prim;
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
  wire c7_5;

  // Instanțierea modulului testat
  ALU_CU uut (
    .CLK(CLK),
    .BGN(BGN),
    .RST(RST),
    .CNT7(CNT7),
    .Q0(Q0),
    .Q_1(Q_1),
    .A7(A7),
    .OP(OP),
    .c0(c0),
    .c0_prim(c0_prim),
    .c1(c1),
    .c2(c2),
    .c3(c3),
    .c4(c4),
    .cR(cR),
    .cL(cL),
    .c5(c5),
    .c7(c7),
    .c8(c8),
    .c6(c6),
    .c7_5(c7_5)
  );

  // Inițializare și aplicare stimuli
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    CLK=0;
  end
  
  always begin
    #10 CLK=~CLK;
  end
  
  initial begin
   // $display("Time\tCLK\tBGN\tRST\tEND\tfi0\tfi1\tfi2\tfi3\tfi4\tfi5");
   // $monitor("%g\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b\t%b", $time, CLK, BGN, RST, END, fi0, fi1, fi2, fi3, fi4, fi5);

    // Inițializare
    BGN=1; 
    OP=2'b10;
    RST=0;
    CNT7=0;
    A7=0;
    Q0=0;
    Q_1=1;
    #10;
    RST=1;
    #10;
    RST=0;
   	#200;
  	BGN=0;
    #10;
    #50;
//     Q0=1;
//     Q_1=0;
    #50;
    #50;
//     Q0=0;
//     Q_1=1;
    #100;
    CNT7=1;
    #200;



    $finish;
  end

endmodule
