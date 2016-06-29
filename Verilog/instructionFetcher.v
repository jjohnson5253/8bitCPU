//This file contains the modules used to get the instructions from the user and set them to memory


//This module takes in the switches and sets the instructions to those switches depending on the state
module instructionFetcher(LED0,clock,switches,state,instruction,opCode,regID1,regID2,immValue);
input [7:0] switches; //opcode,regids, and immediate value will be set according to switches
input clock; //synchronize functions with clock; set opcode, regids, etc depending on state
input [2:0] state; //set opcode, regids, etc depending on state
output reg [17:0] instruction; //output the instruction... a combo of opcode, regids, and imm. value
output reg [3:0] opCode;
output reg [2:0] regID1,regID2;
output reg [7:0] immValue;
output reg LED0=0;

	always@(posedge clock)begin

		//depending on the state: Opcode, regID1&2, and immValue are set by switches
		case(state)

			0 : begin //set opcode for instruction
				opCode <= switches;
				
			end
			1 : begin //set regid1 for instruction
				regID1 <= switches;
			end
			2 : begin//set regid2 for instruction
				regID2 <= switches;
			end
			3 : begin//set immediate value for instruction
				immValue <= switches;

				if (immValue==192) LED0<=1;
				else LED0<=0;
				
			end

		endcase

			//then the instruction is set based off the opCode,regIDs,and immValue set previously 
			//by the switches
			instruction[17:14] <= opCode;
			instruction[13:11] <= regID1;
			instruction[10:8] <= regID2;
			instruction[7:0] <= immValue;
			
	end


endmodule


///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////


module instructionMemory(clock,instruction,instructionDone,reset,state,instructionMem0,
instructionMem1,instructionMem2,instructionMem3,instructionMem4,
instructionMem5,instructionMem6,instructionMem7,instructionMem8,instructionMem9,instructionsSet);

input clock,reset;
input [2:0] state;
input[17:0]instruction;
input instructionDone;
reg[3:0] i = 0; 

output reg[3:0] instructionsSet = 0; //will give number of instructions set

output reg [17:0] instructionMem0,
instructionMem1,instructionMem2,instructionMem3,instructionMem4,
instructionMem5,instructionMem6,instructionMem7,instructionMem8,instructionMem9;


always@(posedge instructionDone)begin
		
		//This works! depending on i, the instructionMem is set to instruction everytime an instruction
		//has been set
		case(i)
			0 : instructionMem0 <= instruction;
			1 : instructionMem1 <= instruction;
			2 : instructionMem2 <= instruction;
			3 : instructionMem3 <= instruction;
			4 : instructionMem4 <= instruction;
			5 : instructionMem5 <= instruction;
			6 : instructionMem6 <= instruction;
			7 : instructionMem7 <= instruction;
			8 : instructionMem8 <= instruction;
			9 : instructionMem9 <= instruction;
		endcase
		
		instructionsSet = i; //this effectively gives up to which instruction memory has been set

		i = i + 1; //increment i so next time instruction is done, the next memory is set
		
		if(reset) i = 0; //going to have to have reset switch up, and then set an instruction to reset
		//then you will have to undo the reset to start setting memory again


end

endmodule