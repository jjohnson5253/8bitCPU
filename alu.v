//This file contains the ALU module

//This module takes in the instructions and performs those instructions on the registers
module alu(clock,executeButton,instructionsSet,LED8,LED9,reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,instructionMem0,instructionMem1,instructionMem2,instructionMem3,instructionMem4,
instructionMem5,instructionMem6,instructionMem7,instructionMem8,instructionMem9);
input clock,executeButton;
input [17:0] instructionMem0,instructionMem1,instructionMem2,instructionMem3,instructionMem4,
instructionMem5,instructionMem6,instructionMem7,instructionMem8,instructionMem9;

input [3:0] instructionsSet; //number of instructions committed to memory

reg [17:0] instruction = 0;
output reg [7:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7;
//output reg [7:0] result0,result1,result2,result3,result4,result5,result6,result7;
output reg LED8 = 0;
output reg LED9 = 0;

reg execute = 0;

//initialize registers to 0
initial reg0=2;initial reg1=4;initial reg2=44;initial reg3=0;initial reg4=0;initial reg5=0;
initial reg6=0;initial reg7=77;

//operating registers that the instruction will perform on
reg [7:0] opReg1,opReg2;

//counter in the for loop
reg [3:0] j = 0;


reg [3:0] test=0;
reg [3:0] m = 2;


always@(posedge clock)begin

//when you press button, execute is true
if(!executeButton)begin
	execute <= 1;
	//LED8<=1;
end

if(execute)begin

//for loop to perform all the instructions from memory
//can't get this to end at j=instructionsSet for some reason D:<
//for(j=0; j<=1; j=j+1)begin //should increment twice

//Think I'm gonna have to ditch the for loop and do FSM with 10 states or something

	//can't figure out arrays in verilog so have to do this:
	//...instruction for the jth operation is set according to j
	//**for some reason, had to make instruction have non-blocking assignments...
	//..it wouldn't work with blocking assignments (instruction was just always being instructionMem9 I think)
	case(j)
	0 : instruction = instructionMem0;
	1 : instruction = instructionMem1;
	2 : instruction = instructionMem2;
	3 : instruction = instructionMem3;
	4 : instruction = instructionMem4;
	5 : instruction = instructionMem5;
	6 : instruction = instructionMem6;
	7 : instruction = instructionMem7;
	8 : instruction = instructionMem8;
	9 : instruction = instructionMem9;
	endcase


	//set the operating registers according to the regID chosen by user in states 1,2
	case(instruction[13:11])//regID1
	4'b0000 : opReg1 = reg0;
	4'b0001 : opReg1 = reg1;
	4'b0010 : opReg1 = reg2;
	4'b0011 : opReg1 = reg3;
	4'b0100 : opReg1 = reg4;
	4'b0101 : opReg1 = reg5;
	4'b0110 : opReg1 = reg6;
	4'b0111 : opReg1 = reg7;
	endcase
	case(instruction[10:8])//regID2
	4'b0000 : opReg2 = reg0;
	4'b0001 : opReg2 = reg1;
	4'b0010 : opReg2 = reg2;
	4'b0011 : opReg2 = reg3;
	4'b0100 : opReg2 = reg4;
	4'b0101 : opReg2 = reg5;
	4'b0110 : opReg2 = reg6;
	4'b0111 : opReg2 = reg7;
	endcase

/////////////////////////////////////////INSTRUCTIONS/////////////////////////////////////////////////////////////////////

	//perform operations between operating registers according to opCode set by user in state 0
	case(instruction[17:14])//opCode

	//////////////////////////////ADD//////////////
	4'b0000 : begin
		reg7 = opReg1 + opReg2;
	end
	///////////////////////////SUBTRACT///////////////////////////
	4'b0001 : begin
	 	reg7 = opReg1 - opReg2;
	 end
	 
	///////////////////////////INVERT///////////////////////////
	4'b0010 : begin

		opReg1[7] = !opReg1[7]; 
		opReg1[6] = !opReg1[6];
		opReg1[5] = !opReg1[5];
		opReg1[4] = !opReg1[4];
		opReg1[3] = !opReg1[3];
		opReg1[2] = !opReg1[2];
		opReg1[1] = !opReg1[1];
		opReg1[0] = !opReg1[0]; 

	end 
	//////////////////////AND////////////////////////////// *works
	4'b0011 : begin
		reg7[7] = opReg1[7] & opReg2[7];
		reg7[6] = opReg1[6] & opReg2[6];
		reg7[5] = opReg1[5] & opReg2[5];
		reg7[4] = opReg1[4] & opReg2[4];
		reg7[3] = opReg1[3] & opReg2[3];
		reg7[2] = opReg1[2] & opReg2[2];
		reg7[1] = opReg1[1] & opReg2[1];
		reg7[0] = opReg1[0] & opReg2[0];
	end
	/////////////////////OR/////////////////////////////// *works
	4'b0100 : begin
		reg7[7] = opReg1[7] | opReg2[7];
		reg7[6] = opReg1[6] | opReg2[6];
		reg7[5] = opReg1[5] | opReg2[5];
		reg7[4] = opReg1[4] | opReg2[4];
		reg7[3] = opReg1[3] | opReg2[3];
		reg7[2] = opReg1[2] | opReg2[2];
		reg7[1] = opReg1[1] | opReg2[1];
		reg7[0] = opReg1[0] | opReg2[0];
	end
	//////////////////////////EXOR///////////////////////////// *works
	4'b0101 : begin
		reg7[7] = opReg1[7] ^ opReg2[7];
		reg7[6] = opReg1[6] ^ opReg2[6];
		reg7[5] = opReg1[5] ^ opReg2[5];
		reg7[4] = opReg1[4] ^ opReg2[4];
		reg7[3] = opReg1[3] ^ opReg2[3];
		reg7[2] = opReg1[2] ^ opReg2[2];
		reg7[1] = opReg1[1] ^ opReg2[1];
		reg7[0] = opReg1[0] ^ opReg2[0];
	end
	/////////////////////////////INCREMENT//////////////////////// *broken
	4'b0110 : begin //*nothing happens to register
		opReg1 = opReg1 + 1;
	end
	///////////////////////////////Shift Right//////////////////////// *broken
	4'b0111 : begin
	//*nothing happens to register
		opReg1[0] = opReg1[1]; 
		opReg1[1] = opReg1[2];
		opReg1[2] = opReg1[3];
		opReg1[3] = opReg1[4];
		opReg1[4] = opReg1[5];
		opReg1[5] = opReg1[6];
		opReg1[6] = opReg1[7];
		opReg1[7] = 0; 
	end
	/////////////////////////////////Shift Left/////////////////////////// *broken
	//*nothing happens to register
	4'b1000 : begin
		opReg1[7] = opReg1[6]; 
		opReg1[6] = opReg1[5];
		opReg1[5] = opReg1[4];
		opReg1[4] = opReg1[3];
		opReg1[3] = opReg1[2];
		opReg1[2] = opReg1[1];
		opReg1[1] = opReg1[0];
		opReg1[0] = 0; 
	end
	///////////////////////////Compare//////////////////////////
	4'b1001 : ; 
	///////////////////////LOAD//////////////////////////////
	4'b1010 : begin
		
		case(opReg1) //load first reg selected to immValue
		4'b0000 : reg0 = instruction[7:0]; //instruction[7:0] is immValue
		4'b0001 : reg1 = instruction[7:0];
		4'b0010 : reg2 = instruction[7:0];
		4'b0011 : reg3 = instruction[7:0];
		4'b0100 : reg4 = instruction[7:0];
		endcase

	end
	////////////////////////////////////Display/////////////////////////////
	4'b1011 : ;
	/////////////////////////////////Move/////////////////////////////////////
	4'b1100 : begin
		opReg2 = opReg1;
	end
	////////////////////////////////Branch if Equal//////////////////////////
	4'b1101 : ;
	////////////////////////////////Branch if Greater//////////////////////////
	4'b1110 : ;
	///////////////////////////////TBD//////////////////////////////////
	4'b1111 : ;
	
	endcase

///////////////////////////////////////////END INSTRUCTIONS//////////////////////////////////////////////

	//now set registers to output of opRegisters after they have been operated on
	case(instruction[13:11])//regID1
	4'b0000 : reg0 = opReg1;
	4'b0001 : reg1 = opReg1;
	4'b0010 : reg2 = opReg1;
	4'b0011 : reg3 = opReg1;
	4'b0100 : reg4 = opReg1;
	4'b0101 : reg5 = opReg1;
	4'b0110 : reg6 = opReg1;
	4'b0111 : reg7 = opReg1;
	endcase
	case(instruction[10:8])//regID2
	4'b0000 : reg0 = opReg2;
	4'b0001 : reg1 = opReg2;
	4'b0010 : reg2 = opReg2;
	4'b0011 : reg3 = opReg2;
	4'b0100 : reg4 = opReg2;
	4'b0101 : reg5 = opReg2;
	4'b0110 : reg6 = opReg2;
	4'b0111 : reg7 = opReg2;
	endcase




//end //end forloop

LED9<=1; //LED9 turns on when execution is done

end //end if(execute)

end //end always block

endmodule








