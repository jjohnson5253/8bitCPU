/*
module alu(clock,execute,operate,instructionMem0,instructionMem1,instructionMem2,instructionMem3,instructionMem4,
instructionMem5,instructionMem6,instructionMem7,instructionMem8,instructionMem9
,reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,i);

input [17:0] instructionMem0,instructionMem1,instructionMem2,instructionMem3,instructionMem4,
instructionMem5,instructionMem6,instructionMem7,instructionMem8,instructionMem9;
input [7:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7;
input clock,execute;

wire opDone;

reg operate = 0;

reg [17:0] instructionMemArray [0:9];


//initialize an array to hold the instruction memories because verilog is stupid and won't let me pass arrays around modules
initial instructionMemArray[0] = instructionMem0; initial instructionMemArray[1] = instructionMem1;
initial instructionMemArray[2] = instructionMem2; initial instructionMemArray[3] = instructionMem3;
initial instructionMemArray[4] = instructionMem4; initial instructionMemArray[5] = instructionMem5;
initial instructionMemArray[6] = instructionMem6; initial instructionMemArray[7] = instructionMem7;
initial instructionMemArray[8] = instructionMem8; initial instructionMemArray[9] = instructionMem9;

input [3:0] i;
reg [3:0] j;
reg [3:0] memories = i - 1; //All instructionMem up to this number were set. i counts everytime an instruction is set.
//so if i = 2 then instructionMem0 and instructionMem1 were set... so subtracting one, gives us the last instructionMem index
//that was set

always@(posedge execute)begin

		operations op0(clock,operate,opDone,reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,instructionMem0);


end




endmodule*/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

module alu(clock,executeButton,instructionsSet,LED8,LED9,reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7/*,result0,result1,result2,result3,result4,
result5,result6,result7,*/,instructionMem0,instructionMem1,instructionMem2,instructionMem3,instructionMem4,
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

reg [17:0] instructionMemArray [0:9];

reg execute = 0;

initial reg0=2;initial reg1=4;initial reg2=44;initial reg3=0;initial reg4=0;initial reg5=0;
initial reg6=0;initial reg7=0;

//initialize an array to hold the instruction memories because verilog is stupid and won't let me pass arrays around modules
initial instructionMemArray[0] = instructionMem0; initial instructionMemArray[1] = instructionMem1;
initial instructionMemArray[2] = instructionMem2; initial instructionMemArray[3] = instructionMem3;
initial instructionMemArray[4] = instructionMem4; initial instructionMemArray[5] = instructionMem5;
initial instructionMemArray[6] = instructionMem6; initial instructionMemArray[7] = instructionMem7;
initial instructionMemArray[8] = instructionMem8; initial instructionMemArray[9] = instructionMem9;

reg [7:0] opReg1,opReg2;
reg [3:0] j = 0;
reg [3:0] test=0;
reg [3:0] m = 2;


always@(posedge clock)begin

//if(instructionMem0==18'b000100000000000000) LED8<=1;

if(!executeButton)begin//when u press button, execute is true
	execute <= 1;
	//LED8<=1;
end

if(execute)begin

//if(instructionsSet==0) LED8<=1;

//for loop to perform all the instructions from memory
//can't get this to end at j=instructionsSet for some reason D:<
for(j=0; j<=0; j=j+1)begin

	test <= test + 1;

	//can't figure out damn arrays in verilog so have to do this:
	//...instruction for the jth operation is set according to j
	//**for some reason, had to make instruction have non-blocking assignments...
	//..it wouldn't work with blocking assignments (instruction was just always being instructionMem9 I think)
	case(j)
	0 : begin 
	instruction = instructionMem0;
	end
	1 : instruction = instructionMem1;
	2 : begin
	instruction = instructionMem2;
	end
	3 : instruction = instructionMem3;
	4 : instruction = instructionMem4;
	5 : instruction = instructionMem5;
	6 : instruction = instructionMem6;
	7 : instruction = instructionMem7;
	8 : instruction = instructionMem8;
	9 : instruction = instructionMem9;
	endcase

	//instruction<=18'b000100000000000000;

	if(instructionMem0==18'b000100000000000000) LED9<=1;
	else LED9<=0;

	//if(instruction==18'b000100000000000000) LED8=1;
	//else LED8=0;

	


	//if(instruction==18'b000100000000000000) LED8<=1;
	//else LED8<=0;
	//if(j==6) LED8<=1;

	//set the operating registers according to the regID chosen by user in states 1,2
	case(instruction[13:11])//regID1
	4'b0000 : opReg1 = reg0;
	4'b0001 : opReg1 = reg1;
	4'b0010 : opReg1 = reg2;
	4'b0011 : opReg1 = reg3;
	4'b0100 : opReg1 = reg4;
	endcase
	case(instruction[10:8])//regID2
	4'b0000 : opReg2 = reg0;
	4'b0001 : opReg2 = reg1;
	4'b0010 : opReg2 = reg2;
	4'b0011 : opReg2 = reg3;
	4'b0100 : opReg2 = reg4;
	endcase

	//perform operations between operating registers according to opCode set by user in state 0
	//if(operate)begin
	
		//initialize resultRegisters to values of regs so whichever ones aren't operated on stay the same
		//when outputted
		/*result0 <= reg0;
		result1 <= reg1;
		result2 <= reg2;
		result3 <= reg3;
		result4 <= reg4;
		result5 <= reg5;
		result6 <= reg6;
		result7 <= reg7;*/
	
	case(instruction[17:14])//opCode
	///ADD//////////////////////////////////////////////////////
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
/*
		case(opReg1) 
		4'b0000 : begin //inverts all the bits of the register selected
		reg0[7] <= !reg0[7]; 
		reg0[6] <= !reg0[6];
		reg0[5] <= !reg0[5];
		reg0[4] <= !reg0[4];
		reg0[3] <= !reg0[3];
		reg0[2] <= !reg0[2];
		reg0[1] <= !reg0[1];
		reg0[0] <= !reg0[0];
		end
		4'b0001 : begin
		reg1[7] <= !reg1[7]; 
		reg1[6] <= !reg1[6];
		reg1[5] <= !reg1[5];
		reg1[4] <= !reg1[4];
		reg1[3] <= !reg1[3];
		reg1[2] <= !reg1[2];
		reg1[1] <= !reg1[1];
		reg1[0] <= !reg1[0];
		end
		4'b0010 : begin
		reg2[7] <= !reg2[7]; 
		reg2[6] <= !reg2[6];
		reg2[5] <= !reg2[5];
		reg2[4] <= !reg2[4];
		reg2[3] <= !reg2[3];
		reg2[2] <= !reg2[2];
		reg2[1] <= !reg2[1];
		reg2[0] <= !reg2[0];
		end
		4'b0011 : begin
		reg3[7] <= !reg3[7]; 
		reg3[6] <= !reg3[6];
		reg3[5] <= !reg3[5];
		reg3[4] <= !reg3[4];
		reg3[3] <= !reg3[3];
		reg3[2] <= !reg3[2];
		reg3[1] <= !reg3[1];
		reg3[0] <= !reg3[0];
		end
		4'b0100 : begin
		reg4[7] <= !reg4[7]; 
		reg4[6] <= !reg4[6];
		reg4[5] <= !reg4[5];
		reg4[4] <= !reg4[4];
		reg4[3] <= !reg4[3];
		reg4[2] <= !reg4[2];
		reg4[1] <= !reg4[1];
		reg4[0] <= !reg4[0];
		end
		endcase
*/


	end 
	//////////////////////AND//////////////////////////////
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
	/////////////////////OR///////////////////////////////
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
	//////////////////////////EXOR/////////////////////////////
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
	/////////////////////////////INCREMENT////////////////////////
	4'b0110 : begin
		opReg1 = opReg1 + 1;
	end
	///////////////////////////////Shift Right////////////////////////
	4'b0111 : begin
		opReg1[0] = opReg1[1]; 
		opReg1[1] = opReg1[2];
		opReg1[2] = opReg1[3];
		opReg1[3] = opReg1[4];
		opReg1[4] = opReg1[5];
		opReg1[5] = opReg1[6];
		opReg1[6] = opReg1[7];
		opReg1[7] = 0; 
	end
	/////////////////////////////////Shift Left///////////////////////////
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

	//now set registers to output of opRegisters after they have been operated on
	case(instruction[13:11])//regID1
	4'b0000 : reg0 = opReg1;
	4'b0001 : reg1 = opReg1;
	4'b0010 : reg2 = opReg1;
	4'b0011 : reg3 = opReg1;
	4'b0100 : reg4 = opReg1;
	endcase
	case(instruction[10:8])//regID2
	4'b0000 : reg0 = opReg2;
	4'b0001 : reg1 = opReg2;
	4'b0010 : reg2 = opReg2;
	4'b0011 : reg3 = opReg2;
	4'b0100 : reg4 = opReg2;
	endcase


end //end forloop

	//execute <= 0; //set execute back to 0 when operations are all done (forloop ends)
	//if(test==9)LED8<=1;
	//reg0<=4;

end //end if(execute)

end //end always block


endmodule


/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
/*
module decoder(instructionMem0,
instructionMem1,instructionMem2,instructionMem3,instructionMem4,
instructionMem5,instructionMem6,instructionMem7,instructionMem8,instructionMem9);

input instructionMem0,
instructionMem1,instructionMem2,instructionMem3,instructionMem4,
instructionMem5,instructionMem6,instructionMem7,instructionMem8,instructionMem9;

wire [3:0] opCode [0:9];
wire [2:0] regID1 [0:9];
wire [2:0] regID2 [0:9];
wire [7:0] immValue [0:9];

reg [3:0] tempOpCode; //temp opCode 
reg [2:0] tempRegID1,tempRegID2;
reg [7:0] tempImmValue;

reg [3:0] i = 0; //use to increment through instruction memories

//decode the instruction memories
instructionDecoder mem0(instructionMem0,opCode[0],regID1[0],regID2[0],immValue[0]);
instructionDecoder mem1(instructionMem1,opCode[1],regID1[1],regID2[1],immValue[1]);
instructionDecoder mem2(instructionMem2,opCode[2],regID1[2],regID2[2],immValue[2]);
instructionDecoder mem3(instructionMem3,opCode[3],regID1[3],regID2[3],immValue[3]);
instructionDecoder mem4(instructionMem4,opCode[4],regID1[4],regID2[4],immValue[4]);
instructionDecoder mem5(instructionMem5,opCode[5],regID1[5],regID2[5],immValue[5]);
instructionDecoder mem6(instructionMem6,opCode[6],regID1[6],regID2[6],immValue[6]);
instructionDecoder mem7(instructionMem7,opCode[7],regID1[7],regID2[7],immValue[7]);
instructionDecoder mem8(instructionMem8,opCode[8],regID1[8],regID2[8],immValue[8]);
instructionDecoder mem9(instructionMem9,opCode[9],regID1[9],regID2[9],immValue[9]);




case(i)
	0: begin
		tempOpCode <= opCode[0];
		tempRegID1 <= regID1[0];
		tempRegID2 <= regID2[0];
		tempImmValue <= immValue
	end
	0: begin
	
	end
	0: begin
	
	end
	0: begin
	
	end
	0: begin
	
	end
	0: begin
	
	end
	0: begin
	
	end
	0: begin
	
	end
	0: begin
	
	end
	0: begin
	
	end

endcase


endmodule

*/

/*

module instructionDecoder(instruction,opCode,regID1,regID2,immValue);

input [17:0] instruction;
output reg [3:0] opCode;
output reg [2:0] regID1,regID2;
output reg [7:0] immValue;

endmodule
*/




//TO DO:
//need to initialize registers to 0

