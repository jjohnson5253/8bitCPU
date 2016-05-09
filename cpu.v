//Jake Johnson 2016

module cpu(clock,inputs,leds3,leds2,leds1,leds0,setButton,displayButton,executeButton,reset,LED4,LED9,LED0,LED8);
	input clock,setButton,executeButton,reset; //clock and button to set values in each state; execute instructions
	reg lastPush,currentPush;
	initial lastPush = currentPush;
	input displayButton; //press this button to toggle display variable
	input [7:0] inputs; //inputs from switches
	reg [2:0] Q; initial Q = 0; //state variable
	output reg LED4=0;
	
	wire execute;

	wire [7:0] bytes [7:0]; //8 byte registers (8-bits)
	
	wire [3:0] opCode; //op code and register ids (set by inputs in their respective states)
	wire [2:0] regID1,regID2;
	wire [7:0] immValue;
	wire [17:0] instruction;
	//wire [17:0] instructionMem [0:9];
	wire [17:0] instructionMem0,instructionMem1,instructionMem2,instructionMem3,instructionMem4,
instructionMem5,instructionMem6,instructionMem7,instructionMem8,instructionMem9; //can store 10 instructions
	
	wire [1:7] opCodeDisplay3,opCodeDisplay2,opCodeDisplay1,opCodeDisplay0; //values that hold operation display
	//these values are set at each clock pulse, according to the opCode
	//leds are set to this when in state 0
	wire [1:7] reg1Display3,reg1Display2,reg1Display1,reg1Display0; //values for displaying first selected register ID
	wire [1:7] reg2Display3,reg2Display2,reg2Display1,reg2Display0; //values for displaying second selected register ID
	wire [1:7] immDisplay3,immDisplay2,immDisplay1,immDisplay0;
	wire [1:7] display3,display2,display1,display0; //values for displaying reg value
	output reg [1:7] leds3,leds2,leds1,leds0; //the leds mapped to the 7seg display (led3 is left-most 7seg digit)
	
	reg operate;  //set to 1 if operation should be performed
	wire display; //set to true if user wants to display regID1 value
	wire opDone; //variable set to true after operation stage is done
	
	wire [7:0] resultRegs [7:0]; //registers after operations have been performed... these values
	//are the output from the operation module and are set based off the operation and previous state of registers
	
	reg instructionDone=0; //tells instructionMemory module that an instruction is set and needs to be memorized
	output LED9,LED0,LED8;

	wire executionDone;

	wire [3:0] instructionsSet; //number of instructions set to memory before execution

	
	
	always@(posedge !setButton) begin
	
		currentPush = !currentPush;
		
	end
	
	
	always@(posedge clock)begin
		
		if(bytes[0]==0) LED4<=1;
		else LED4 <= 0;

		
	
		if(!displayButton)begin //if button pressed, and in regID states or operation state
			leds3 <= display3;
			leds2 <= display2;
			leds1 <= display1;
			leds0 <= display0;
		end
		
		else if(lastPush!=currentPush)begin
			case(Q)
				0 : begin //set opCode
				Q <= 1; 
				end
				1 : begin  //set regid1
				Q <= 2; 
				end
				2 : begin //set regid2
				Q <= 3;
				end
				3 : begin //set imm value and set instruction
				instructionDone <= 1;
				Q <= 0;
				end	
			endcase
			lastPush = currentPush;
		end
		
		else begin
		
		case(Q)
		0 : begin //state 0: set operation
		operate <= 0; //turn off operate
		leds3 <= opCodeDisplay3; //set leds to display operation
		leds2 <= opCodeDisplay2;
		leds1 <= opCodeDisplay1;
		leds0 <= opCodeDisplay0;
		
		instructionDone <= 0;
		end
		
		1 : begin
		leds3 <= reg1Display3; //set leds to display regID
		leds2 <= reg1Display2;
		leds1 <= reg1Display1;
		leds0 <= reg1Display0;
		end
		
		2 : begin
		leds3 <= reg2Display3; //set leds to display operation
		leds2 <= reg2Display2;
		leds1 <= reg2Display1;
		leds0 <= reg2Display0;
		end
		
		3: begin
		leds3 <= immDisplay3; //set leds to display immValue
		leds2 <= immDisplay2;
		leds1 <= immDisplay1;
		leds0 <= immDisplay0;
		end
		
		endcase
		end
	end
	
	setOpCodeDisplay op1(clock,opCode,opCodeDisplay3,opCodeDisplay2,opCodeDisplay1,opCodeDisplay0);
	setRegDisplay regDis1(clock,regID1,reg1Display3,reg1Display2,reg1Display1,reg1Display0);
	setRegDisplay regDis2(clock,regID2,reg2Display3,reg2Display2,reg2Display1,reg2Display0);
	setImmValueDisplay immDis1(clock,Q,immValue,immDisplay3,immDisplay2,immDisplay1,immDisplay0);

	//This module sets display for when display button is pressed
	//it takes in the registers and displays the register being looked at in stage 1 or 2
	setDisplay stage1(clock,Q,regID1,regID2,bytes[0],bytes[1],bytes[2],bytes[3],bytes[4],bytes[5],bytes[6],
		bytes[7],display3,display2,display1,display0);


	instructionFetcher(LED0,clock,inputs,Q,instruction,opCode,regID1,regID2,immValue);

	
	instructionMemory(clock,instruction,instructionDone,reset,Q,instructionMem0,
		instructionMem1,instructionMem2,instructionMem3,instructionMem4,
		instructionMem5,instructionMem6,instructionMem7,instructionMem8,instructionMem9,instructionsSet);

	alu(clock,executeButton,instructionsSet,LED8,LED9,bytes[0],bytes[1],bytes[2],bytes[3],bytes[4],bytes[5],bytes[6],bytes[7],
		instructionMem0,instructionMem1,instructionMem2,instructionMem3,instructionMem4,
		instructionMem5,instructionMem6,instructionMem7,instructionMem8,instructionMem9);
	
	
endmodule








