//This File contains the modules used to set the display at various points in the circuit


//This module takes in the opCode set by the inputs), then sets some display values accordingly.
//The display values are specific for the opCodeDisplay... they will display what operation
//is to be performed...then in state 1 and 2, the user will decide which registers to operate on
//and those registers will have a display module similar to this to display the registerID
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
	4'b0010 : begin // invert (1's complement)
	display3 <= 7'b1111111; //nothing
	display2 <= 7'b1101111; //i
	display1 <= 7'b1101010; //n
	display0 <= 7'b1100011; //v
	end
	4'b0011 : begin // Logical AND
	display3 <= 7'b1111111; //nothing
	display2 <= 7'b0001000; //A
	display1 <= 7'b1101010; //n
	display0 <= 7'b1000010; //d
	end
	4'b0100 : begin // Logical OR
	display3 <= 7'b1111111; //nothing
	display2 <= 7'b1111111; //nothing
	display1 <= 7'b1100010; //o
	display0 <= 7'b1111010; //r
	end
	4'b0101 : begin // Logical EXOR
	display3 <= 7'b0110000; //E
	display2 <= 7'b1001000; //X
	display1 <= 7'b1100010; //o
	display0 <= 7'b1111010; //r
	end
	4'b0110 : begin // Increment
	display3 <= 7'b1111111; //nothing
	display2 <= 7'b1101111; //i
	display1 <= 7'b1101010; //n
	display0 <= 7'b1110010; //c
	end
	4'b0111 : begin // Logical Shift Right
	display3 <= 7'b1111111; //nothing
	display2 <= 7'b1111111; //nothing
	display1 <= 7'b0100100; //S
	display0 <= 7'b1111010; //r
	end
	4'b1000 : begin // Logical Shift Left
	display3 <= 7'b1111111; //nothing
	display2 <= 7'b1111111; //nothing
	display1 <= 7'b0100100; //S
	display0 <= 7'b1110001; //L
	end
	4'b1001 : begin // Compare
	display3 <= 7'b1111111; //nothing
	display2 <= 7'b1111111; //nothing
	display1 <= 7'b1110010; //c
	display0 <= 7'b0011000; //P
	end
	4'b1010 : begin // Load
	display3 <= 7'b1110001; //L
	display2 <= 7'b0000001; //O
	display1 <= 7'b0001000; //A
	display0 <= 7'b1000010; //d
	end
	4'b1011 : begin // Display
	display3 <= 7'b1111111; //nothing
	display2 <= 7'b1111111; //nothing
	display1 <= 7'b1111111; //nothing
	display0 <= 7'b0010010; //2 (indicates to press 2 while in regID mode to display reg)
	end
	4'b1100 : begin // Move
	display3 <= 7'b1111010; //m
	display2 <= 7'b1101010; //m
	display1 <= 7'b1100010; //o
	display0 <= 7'b1100011; //v
	end
	4'b1101 : begin // Branch if Equal
	display3 <= 7'b1111111; //nothing
	display2 <= 7'b1100000; //b
	display1 <= 7'b1111010; //r
	display0 <= 7'b0110000; //e
	end
	4'b1110 : begin // Branch if greater than
	display3 <= 7'b1111111; //nothing
	display2 <= 7'b1100000; //b
	display1 <= 7'b1111010; //r
	display0 <= 7'b0100000; //g
	end
	4'b1111 : begin // TBD
	display3 <= 7'b1111111; //nothing
	display2 <= 7'b0001111; //T
	display1 <= 7'b1100000; //b
	display0 <= 7'b1000010; //d
	end
	endcase
	
endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

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
	4'b0011 : begin 
	display3 <= 7'b1111010; //r
	display2 <= 7'b0110000; //e
	display1 <= 7'b0000100; //g
	display0 <= 7'b0000110; //3
	end
	4'b0100 : begin 
	display3 <= 7'b1111010; //r
	display2 <= 7'b0110000; //e
	display1 <= 7'b0000100; //g
	display0 <= 7'b1001100; //4
	end
	4'b0101 : begin 
	display3 <= 7'b1111010; //r
	display2 <= 7'b0110000; //e
	display1 <= 7'b0000100; //g
	display0 <= 7'b0100100; //5
	end
	4'b0110 : begin 
	display3 <= 7'b1111010; //r
	display2 <= 7'b0110000; //e
	display1 <= 7'b0000100; //g
	display0 <= 7'b0100000; //6
	end
	4'b0111 : begin 
	display3 <= 7'b1111010; //r
	display2 <= 7'b0110000; //e
	display1 <= 7'b0000100; //g
	display0 <= 7'b0001111; //7
	end

	endcase
	
end
	
endmodule

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

module setImmValueDisplay(clock,Q,immValue,display3,display2,display1,display0);
	//display3,2,1,0 are the values to be displayed on 7seg display

	input clock;
	input [2:0] Q;
	//input [3:0] regID1,regID2;
	//input [7:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7;
	output reg [1:7] display3,display2,display1,display0;

	input [7:0] immValue; //register to be displayed

	reg [3:0] noRem1=0; //value that help out with BCD algorithm (stands for noRemainder1)
	reg [3:0] noRem2=0;
	reg [11:0] BCD = 0; //binary coded decimal values for 3rd,2nd,1st digit of decimal number

	reg [7:0] test=192;

	always@(posedge clock)begin


		//This effectively turns the display value into the appropriate values for each digit (3rd,2nd,1st)
		BCD[3:0] = immValue % 10; //ones (1st digit)
		noRem1 = (immValue-BCD[3:0])/10;
		BCD[7:4] = noRem1 % 10; //tenths (2nd digit)
		noRem2 = (noRem1-BCD[7:4])/10;
		BCD[11:8] = noRem2 % 10; //hundreds (3rd digit)

		display3 = 7'b0000001; //4th digit will always be 0 since highest number is 255

		case(BCD[11:8])  //3rd digit (hundreds)
					  //abcdefg
			0: display2<=7'b0000001;//1111110;
			1: display2<=7'b1001111;//0110000;
			2: display2<=7'b0010010;//1101101;
			3: display2<=7'b0000110;//1111001;
			4: display2<=7'b1001100;//0110011;
			5: display2<=7'b0100100;//1011011;
			6: display2<=7'b0100000;//1011111;
			7: display2<=7'b0001111;//1110000;
			8: display2<=7'b0000000;//1111111;
			9: display2<=7'b0000100;//1111011;
			
		endcase

		case(BCD[7:4])  //2nd digit (tenths)
					  //abcdefg
			0: display1<=7'b0000001;//1111110;
			1: display1<=7'b1001111;//0110000;
			2: display1<=7'b0010010;//1101101;
			3: display1<=7'b0000110;//1111001;
			4: display1<=7'b1001100;//0110011;
			5: display1<=7'b0100100;//1011011;
			6: display1<=7'b0100000;//1011111;
			7: display1<=7'b0001111;//1110000;
			8: display1<=7'b0000000;//1111111;
			9: display1<=7'b0000100;//1111011;
			
		endcase

		case(BCD[3:0])  //3rd digit (hundreds)
					  //abcdefg
			0: display0<=7'b0000001;//1111110;
			1: display0<=7'b1001111;//0110000;
			2: display0<=7'b0010010;//1101101;
			3: display0<=7'b0000110;//1111001;
			4: display0<=7'b1001100;//0110011;
			5: display0<=7'b0100100;//1011011;
			6: display0<=7'b0100000;//1011111;
			7: display0<=7'b0001111;//1110000;
			8: display0<=7'b0000000;//1111111;
			9: display0<=7'b0000100;//1111011;
			
		endcase


	end

endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////

//This sets the display for when the display button is pressed.  It shows the value of a register.
module setDisplay(clock,Q,regID1,regID2,reg0,reg1,reg2,reg3,reg4,
	reg5,reg6,reg7,display3,display2,display1,display0);
	//display3,2,1,0 are the values to be displayed on 7seg display

	input clock;
	input [2:0] Q;
	input [3:0] regID1,regID2;
	input [7:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7;
	output reg [1:7] display3,display2,display1,display0;

	reg [7:0] displayReg=0; //register to be displayed

	reg [3:0] noRem1=0; //value that help out with BCD algorithm (stands for noRemainder1)
	reg [3:0] noRem2=0;
	reg [11:0] BCD = 0; //binary coded decimal values for 3rd,2nd,1st digit of decimal number

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
		//displayReg <= reg0;

		//This effectively turns the display value into the appropriate values for each digit (3rd,2nd,1st)
		BCD[3:0] = displayReg % 10; //ones (1st digit)
		noRem1 = (displayReg-BCD[3:0])/10;
		BCD[7:4] = noRem1 % 10; //tenths (2nd digit)
		noRem2 = (noRem1-BCD[7:4])/10;
		BCD[11:8] = noRem2 % 10; //hundreds (3rd digit)

		display3 = 7'b0000001; //4th digit will always be 0 since highest number is 255

		case(BCD[11:8])  //3rd digit (hundreds)
					  //abcdefg
			0: display2<=7'b0000001;//1111110;
			1: display2<=7'b1001111;//0110000;
			2: display2<=7'b0010010;//1101101;
			3: display2<=7'b0000110;//1111001;
			4: display2<=7'b1001100;//0110011;
			5: display2<=7'b0100100;//1011011;
			6: display2<=7'b0100000;//1011111;
			7: display2<=7'b0001111;//1110000;
			8: display2<=7'b0000000;//1111111;
			9: display2<=7'b0000100;//1111011;
			
		endcase

		case(BCD[7:4])  //2nd digit (tenths)
					  //abcdefg
			0: display1<=7'b0000001;//1111110;
			1: display1<=7'b1001111;//0110000;
			2: display1<=7'b0010010;//1101101;
			3: display1<=7'b0000110;//1111001;
			4: display1<=7'b1001100;//0110011;
			5: display1<=7'b0100100;//1011011;
			6: display1<=7'b0100000;//1011111;
			7: display1<=7'b0001111;//1110000;
			8: display1<=7'b0000000;//1111111;
			9: display1<=7'b0000100;//1111011;
			
		endcase

		case(BCD[3:0])  //3rd digit (hundreds)
					  //abcdefg
			0: display0<=7'b0000001;//1111110;
			1: display0<=7'b1001111;//0110000;
			2: display0<=7'b0010010;//1101101;
			3: display0<=7'b0000110;//1111001;
			4: display0<=7'b1001100;//0110011;
			5: display0<=7'b0100100;//1011011;
			6: display0<=7'b0100000;//1011111;
			7: display0<=7'b0001111;//1110000;
			8: display0<=7'b0000000;//1111111;
			9: display0<=7'b0000100;//1111011;
			
		endcase

	end

endmodule