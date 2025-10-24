

`timescale 1ns / 1ps

module tb_ALU;

  reg CLk;
  reg [7:0]inbus;
  reg [1:0]op;
  reg Begin;
  reg RST;
  wire [7:0]outbus;

  ALU_2 uut (
    .inbus(inbus),
    .op(op),
    .CLk(CLk),
    .Begin(Begin),
    .RST(RST),
    .outbus(outbus)
  );

   initial begin
    $dumpfile("dump.vcd"); $dumpvars;
	CLk=0;
   end
  
  always begin
    #10; CLk=~CLk; 
  end
  
  initial begin
 
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
    inbus=-20;
	Begin=1;
    RST=0;#20;
    RST=1;#20;
    RST=0;#20;
    inbus=-12;
	#150;
    inbus=-20;
	Begin=1;
    RST=0;#20;
    RST=1;#20;
    RST=0;#20;
    inbus=12;
	#150;
    inbus=200;
	Begin=1;
    RST=0;#20;
    RST=1;#20;
    RST=0;#20;
    inbus=56;
	#150;
    Begin=0;#10;
    inbus=200;
	Begin=1;
    RST=0;#20;
    RST=1;#20;
    RST=0;#20;
    inbus=75;
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
    
    Begin=1;
    RST=0;#20;
    RST=1;#20;
    RST=0;
    inbus=-128;#20;
    #20;
    inbus=-1;
    #150
    Begin=0;#10;
    
    Begin=1;
    RST=0;#20;
    RST=1;#20;
    RST=0;
    inbus=-20;#20;
    #20;
    inbus=10;
    #150
    Begin=0;#10;
    
    Begin=1;
    RST=0;#20;
    RST=1;#20;
    RST=0;
    inbus=-128;#20;
    #20;
    inbus=1;
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
    
    Begin=1;
    inbus=32;
    RST=0;#20;
    RST=1;#20;
    RST=0;#30;
    inbus=-25;#20;
	#1500;
    Begin=0;#10;
    
    Begin=1;
    inbus=-32;
    RST=0;#20;
    RST=1;#20;
    RST=0;#30;
    inbus=-25;#20;
	#1500;
    Begin=0;#10;
	//impartirea
    Begin=1;  
    op=3;
    RST=0;#20;
    RST=1;#20;
    RST=0;
//     inbus=8'b00001001;#10;
//     inbus=8'b10011001;#20;
    inbus=8'b11110000;#10;
    inbus=8'b01100000;#20;
   
    inbus=20;
	#1500;
    $finish;
  end

endmodule


