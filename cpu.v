//Jake Johnson 2016

module cpu(clock,inputs,leds3,leds2,leds1,leds0,setButton,displayButton,LED,LED9,LED0);
	input clock,setButton; //clock and button to set values in each state
	reg lastPush,currentPush;
	initial lastPush = currentPush;
	input displayButton; //press this button to toggle display variable
	input [7:0] inputs; //inputs from switches
	reg [2:0] Q; initial Q = 0; //state variable
	input LED;

	wire [7:0] bytes [7:0]; //8 byte registers (8-bits)
	/*
	assign bytes[0] = 1; //assigning each byte
	assign bytes[1] = 1;
	assign bytes[2] = 1;
	assign bytes[3] = 1;
	assign bytes[4] = 1;
	assign bytes[5] = 1;
	assign bytes[6] = 1;
	assign bytes[7] = 1;*/
	
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
	wire [1:7] display3,display2,display1,display0; //values for displaying reg value
	output reg [1:7] leds3,leds2,leds1,leds0; //the leds mapped to the 7seg display (led3 is left-most 7seg digit)
	
	reg operate;  //set to 1 if operation should be performed
	wire display; //set to true if user wants to display regID1 value
	wire opDone; //variable set to true after operation stage is done
	
	wire [7:0] resultRegs [7:0]; //registers after operations have been performed... these values
	//are the output from the operation module and are set based off the operation and previous state of registers
	
	reg instructionDone=0; //tells instructionMemory module that an instruction is set and needs to be memorized
	output LED9,LED0;

	
	
	always@(posedge !setButton) begin
	
		currentPush = !currentPush;
		
	end
	
	
	always@(posedge clock)begin
	
		
	
		if(!displayButton && (Q==1 || Q==2 || Q==3))begin //if button pressed, and in regID states or operation state
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
		//operate <= 1;
		end
		
		endcase
		end
	end
	
	setOpCodeDisplay op1(clock,opCode,opCodeDisplay3,opCodeDisplay2,opCodeDisplay1,opCodeDisplay0);
	setRegDisplay regDis1(clock,regID1,reg1Display3,reg1Display2,reg1Display1,reg1Display0);
	setRegDisplay regDis2(clock,regID2,reg2Display3,reg2Display2,reg2Display1,reg2Display0);
	setDisplay stage1(clock,Q,regID1,regID2,bytes[0],bytes[1],bytes[2],bytes[3],bytes[4],bytes[5],bytes[6],
		bytes[7],display3,display2,display1,display0);

/*
	operation operate1(clock,regID1,regID2,opCode,operate,
		bytes[0],bytes[1],bytes[2],bytes[3],bytes[4],bytes[5],bytes[6],bytes[7],resultRegs[0],resultRegs[1],resultRegs[2],
		resultRegs[3],resultRegs[4],resultRegs[5],resultRegs[6],resultRegs[7],display,displayButton,opDone,LED); //theres gotta be an easier way to input arrays
		

	updateRegisters update1(resultRegs[0],resultRegs[1],resultRegs[2],resultRegs[3],resultRegs[4],resultRegs[5],
		resultRegs[6],resultRegs[7],bytes[0],bytes[1],bytes[2],bytes[3],bytes[4],bytes[5],bytes[6],bytes[7],clock,opDone,Q);
*/

	instructionFetcher(LED0,clock,inputs,Q,instruction,opCode,regID1,regID2,immValue);
	/*
	instructionMemory(LED9,clock,instruction,instructionDone,Q,instructionMem0,
	instructionMem1,instructionMem2,instructionMem3,instructionMem4,
	instructionMem5,instructionMem6,instructionMem7,instructionMem8,instructionMem9); */
	
	instructionMemory(LED9,clock,instruction,instructionDone,Q,instructionMem0,
instructionMem1,instructionMem2,instructionMem3,instructionMem4,
instructionMem5,instructionMem6,instructionMem7,instructionMem8,instructionMem9);
endmodule



//This module takes in the opCode set by the inputs), then sets some display values accordingly
//the display values are specific for the opCodeDisplay... they will display what operation
//is to be performed...then in state 1 and 2, the user will decide which registers to operate on
//and those registers will have a display module similar to this to display the registerID
//it would be cool if, when in state 1 or 2, you see the registerID, then you could press another
//button to see the value of the register

module setOpCodeDisplay(clock, opCode, display3,display2,display1,display0);
input clock;
input [3:0] opCode;
output reg [1:7] display3,display2,display1,display0;

always@(posedge clock)

	case(opCode)
			       //abcdefg
	4'b0000 : begin //add
	display3 <= 7'b1111111; //nothing
	display2 <= 7'b0001000; //A
	display1 <= 7'b1000010; //d
	display0 <= 7'b1000010; //d
	end
	4'b0001 : begin // subtract
	display3 <= 7'b1111111; //nothing
	display2 <= 7'b0100100; //S
	display1 <= 7'b1100011; //u
	display0 <= 7'b1100000; //b
	end
	4'b0010 : display3 <= 7'b0000001;
	4'b0011 : display3 <= 7'b0000001;
	4'b0100 : display3 <= 7'b0000001;
	4'b0101 : display3 <= 7'b0000001;
	4'b0110 : display3 <= 7'b0000001;
	4'b0111 : display3 <= 7'b0000001;
	4'b1000 : display3 <= 7'b0000001;
	4'b1001 : display3 <= 7'b0000001;
	4'b1010 : display3 <= 7'b0000001;
	4'b1011 : display3 <= 7'b0000001;
	4'b1100 : display3 <= 7'b0000001;
	4'b1101 : display3 <= 7'b0000001;
	4'b1110 : display3 <= 7'b0000001;
	4'b1111 : display3 <= 7'b0000001;
	endcase
	
endmodule


module setRegDisplay(clock, regID, display3,display2,display1,display0);
input clock;
input [3:0] regID;
output reg [1:7] display3,display2,display1,display0;

always@(posedge clock)begin

	case(regID)
			       //abcdefg
	4'b0000 : begin //reg0
	display3 <= 7'b1111010; //r
	display2 <= 7'b0110000; //e
	display1 <= 7'b0000100; //g
	display0 <= 7'b0000001; //0
	end
	4'b0001 : begin //reg1
	display3 <= 7'b1111010; //r
	display2 <= 7'b0110000; //e
	display1 <= 7'b0000100; //g
	display0 <= 7'b1001111; //1
	end
	4'b0010 : begin //reg1
	display3 <= 7'b1111010; //r
	display2 <= 7'b0110000; //e
	display1 <= 7'b0000100; //g
	display0 <= 7'b0010010; //2
	end
	4'b0011 : display3 <= 7'b0000001;
	4'b0100 : display3 <= 7'b0000001;
	4'b0101 : display3 <= 7'b0000001;
	4'b0110 : display3 <= 7'b0000001;
	4'b0111 : display3 <= 7'b0000001;
	4'b1000 : display3 <= 7'b0000001;
	4'b1001 : display3 <= 7'b0000001;
	4'b1010 : display3 <= 7'b0000001;
	4'b1011 : display3 <= 7'b0000001;
	4'b1100 : display3 <= 7'b0000001;
	4'b1101 : display3 <= 7'b0000001;
	4'b1110 : display3 <= 7'b0000001;
	4'b1111 : display3 <= 7'b0000001;
	endcase
	
end
	
endmodule


module operation(clock,regID1,regID2,opCode,operate,
	reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,resultRegs0,resultRegs1,resultRegs2,resultRegs3,resultRegs4,
	resultRegs5,resultRegs6,resultRegs7,display,displayButton,opDone,LED); //reg7 is the where result is stored
input clock,operate,displayButton;
input [3:0] regID1,regID2,opCode;
input [7:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7;

reg [7:0] opReg1,opReg2; //registers to be operated on
output reg [7:0] resultRegs0,resultRegs1,resultRegs2,resultRegs3,resultRegs4,
	resultRegs5,resultRegs6,resultRegs7;
output reg display,LED; //set to true if user wants to display register
output reg opDone; //set to true when operation is done... set to false if operate is set to false
initial display = 0;

//toggle display option
always@(!displayButton)begin
	display <= ~display;
	LED <= 1;
end


always@(posedge clock)begin

	//set the operating registers according to the regID chosen by user in states 1,2
	case(regID1)
	4'b0000 : opReg1 <= reg0;
	4'b0001 : opReg1 <= reg1;
	4'b0010 : opReg1 <= reg2;
	4'b0011 : opReg1 <= reg3;
	4'b0100 : opReg1 <= reg4;
	endcase
	case(regID2)
	4'b0000 : opReg2 <= reg0;
	4'b0001 : opReg2 <= reg1;
	4'b0010 : opReg2 <= reg2;
	4'b0011 : opReg2 <= reg3;
	4'b0100 : opReg2 <= reg4;
	endcase

	//perform operations between operating registers according to opCode set by user in state 0
	if(operate)begin
	
		//initialize resultRegisters to values of regs
		resultRegs0 <= reg0;
		resultRegs1 <= reg1;
		resultRegs2 <= reg2;
		resultRegs3 <= reg3;
		resultRegs4 <= reg4;
		resultRegs5 <= reg5;
		resultRegs6 <= reg6;
		resultRegs7 <= reg7;
		
		case(opCode)
		4'b0000 : begin //add
			//reg7 <= opReg1 + opReg2;
			resultRegs0 <= 2;
			resultRegs1 <= 1;
		end
		4'b0001 : ; //subtract
		4'b0010 : ; 
		4'b0011 : ;
		4'b0100 : ;
		4'b0101 : ;
		4'b0110 : ;
		4'b0111 : ;
		4'b1000 : ;
		4'b1001 : ;
		4'b1010 : ;
		4'b1011 : ; //display
		4'b1100 : ;
		4'b1101 : ;
		4'b1110 : ;
		4'b1111 : ;
		
		endcase
		
		opDone <= 1;

	end
	else begin
		opDone <= 0;
	end

end


endmodule

module setDisplay(clock,Q,regID1,regID2,reg0,reg1,reg2,reg3,reg4,
	reg5,reg6,reg7,display3,display2,display1,display0);
	//display3,2,1,0 are the values to be displayed on 7seg display

	input clock;
	input [2:0] Q;
	input [3:0] regID1,regID2;
	input [7:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7;
	output reg [1:7] display3,display2,display1,display0;

	reg [7:0] displayReg; //register to be displayed

	always@(posedge clock)begin
	 	//depending on state, change displayReg to regID being selected
		//or display 1st chosen reg (if using display operation from op module)
		case(Q)
		0 : ;
		1 : begin //regID1 selecting stage
			case(regID1)
			4'b0000 : displayReg <= reg0;
			4'b0001 : displayReg <= reg1;
			4'b0010 : displayReg <= reg2;
			4'b0011 : displayReg <= reg3;
			4'b0100 : displayReg <= reg4;
			4'b0101 : displayReg <= reg5;
			4'b0110 : displayReg <= reg6;
			4'b0111 : displayReg <= reg7;
			endcase
		end
		2 : begin //regID2 selecting stage
			case(regID2)
			4'b0000 : displayReg <= reg0;
			4'b0001 : displayReg <= reg1;
			4'b0010 : displayReg <= reg2;
			4'b0011 : displayReg <= reg3;
			4'b0100 : displayReg <= reg4;
			4'b0101 : displayReg <= reg5;
			4'b0110 : displayReg <= reg6;
			4'b0111 : displayReg <= reg7;
			endcase
		end
		3 : begin //operation stage
			//displays first selected register
			case(regID1)
			4'b0000 : displayReg <= reg0;
			4'b0001 : displayReg <= reg1;
			4'b0010 : displayReg <= reg2;
			4'b0011 : displayReg <= reg3;
			4'b0100 : displayReg <= reg4;
			4'b0101 : displayReg <= reg5;
			4'b0110 : displayReg <= reg6;
			4'b0111 : displayReg <= reg7;
			endcase
		end
		endcase

		//now set display values according to the reg that needs to
		//be displayed
		case(displayReg)
			0 : begin
				display3 <= 7'b1111111; //nothing
				display2 <= 7'b1111111; //nothing
				display1 <= 7'b1111111; //nothing
				display0 <= 7'b0000001; //0
			end
			1 : begin
				display3 <= 7'b1111111; //nothing
				display2 <= 7'b1111111; //nothing
				display1 <= 7'b1111111; //nothing
				display0 <= 7'b1001111; //1
			end
			2 : begin
				display3 <= 7'b1111111; //nothing
				display2 <= 7'b1111111; //nothing
				display1 <= 7'b1111111; //nothing
				display0 <= 7'b0010010; //2
			end
			3 : begin
				display3 <= 7'b1111111; //nothing
				display2 <= 7'b1111111; //nothing
				display1 <= 7'b1111111; //nothing
				display0 <= 7'b0110000; //3
			end
			4 : begin
				display3 <= 7'b1111111; //nothing
				display2 <= 7'b1111111; //nothing
				display1 <= 7'b1111111; //nothing
				display0 <= 7'b1001100; //4
			end
			5 : begin
				display3 <= 7'b1111111; //nothing
				display2 <= 7'b1111111; //nothing
				display1 <= 7'b1111111; //nothing
				display0 <= 7'b0100100; //5
			end
		endcase

	end

endmodule

module updateRegisters(resultRegs0,resultRegs1,resultRegs2,resultRegs3,resultRegs4,
	resultRegs5,resultRegs6,resultRegs7,bytes0,bytes1,bytes2,bytes3,bytes4,bytes5,bytes6,bytes7,clock,opDone,Q);
	
	input resultRegs0,resultRegs1,resultRegs2,resultRegs3,resultRegs4,
	resultRegs5,resultRegs6,resultRegs7,Q;
	input clock,opDone;
	output reg bytes0,bytes1,bytes2,bytes3,bytes4,bytes5,bytes6,bytes7;
	
	always@(posedge clock)begin //update registers when operation is done
	
		if(Q==1)
			bytes0 <=0;
	
		if(opDone)begin

			bytes0 <= resultRegs0;
			bytes1 <= resultRegs1;
			bytes2 <= resultRegs2;
			bytes3 <= resultRegs3;
			bytes4 <= resultRegs4;
			bytes5 <= resultRegs5;
			bytes6 <= resultRegs6;
			bytes7 <= resultRegs7;
			
		end
	
	end
	
	
endmodule






/*
4'b0000 : ;
4'b0001 : ;
4'b0010 : ;
4'b0011 : ;
4'b0100 : ;
4'b0101 : ;
4'b0110 : ;
4'b0111 : ;
4'b1000 : ;
4'b1001 : ;
4'b1010 : ;
4'b1011 : ;
4'b1100 : ;
4'b1101 : ;
4'b1110 : ;
4'b1111 : ;
*/







