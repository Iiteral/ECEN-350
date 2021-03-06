`timescale 1ns / 1ps
module ImmGenerator(Imm64, Imm26, Ctrl);
   output reg [63:0] Imm64;
   input [25:0]  Imm26;
   input [2:0]	 Ctrl;


   wire 	 extBit;

   //assign extBit = (Ctrl ? 1'b0 : Imm32[31]);
   //assign Imm32 = {{32{extBit}}, Imm32};

   
   always@(*)
     begin
        if(Ctrl[2:0] == 3'b000) begin  // I-type
	   Imm64 = {52'b0,Imm26[21:10]};
        end
        if(Ctrl[2:0] == 3'b001)begin // Load/Store
           Imm64 = {{55{Imm26[20]}}, Imm26[20:12]};
	end
	if(Ctrl[2:0] == 3'b010)begin // Uncond. Branch
          Imm64 = {{38{Imm26[25]}}, Imm26[25:0]};
	end
	if(Ctrl[2:0] == 3'b011)begin // Cond. Branch
	  Imm64 = {{45{Imm26[23]}}, Imm26[23:5]};
	end
	if(Ctrl[2:0] == 3'b100)begin// IW-Type 
		if(Imm26[22:21] == 2'b00)begin// LSL 0 
		    Imm64 = {48'b0, Imm26[20:5]};
		end
		if(Imm26[22:21] == 2'b01)begin //LSL 16
 		    Imm64 = {32'b0, Imm26[20:5], 16'b0};		
		end
		if(Imm26[22:21] == 2'b10) begin//LSL 32
		    Imm64 = {16'b0, Imm26[20:5], 32'b0};
		end
		if(Imm26[22:21] == 2'b11)begin//LSL 48
		    Imm64 = {Imm26[20:5], 48'b0};
		end
	  //Imm64 = {Imm26[20:5]<<(Imm26[22:21]*16)};
	end
	if(Ctrl[2:0] == 3'bxxx)begin 
          Imm64 = {64'bx};
        end
	
	
      end
   endmodule
