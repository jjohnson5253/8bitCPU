//Jake Johnson 2016

module cpu(clock,inputs,leds3,leds2,leds1,leds0,setButton);
	input clock,setButton; //clock and button to set values in each state
	input [3:0] inputs; //inputs from switches
	reg [2:0] Q; initial Q = 0; //state variable

	wire [7:0] bytes [7:0]; //8 byte registers (8-bits)
	assign bytes[0] = 1; //assigning each byte
	assign bytes[1] = 1;
	assign bytes[2] = 1;
	assign bytes[3] = 1;
	assign bytes[4] = 1;
	assign bytes[5] = 1;
	assign bytes[6] = 1;
	assign bytes[7] = 1;
	
	reg [3:0] opCode, registerID; //op code and register id (set by inputs in their respective states)
	wire [1:7] opCodeDisplay3,opCodeDisplay2,opCodeDisplay1,opCodeDisplay0; //values that hold operation display
	//these values are set at each clock pulse, according to the opCode
	//leds are set to this when in state 0
	output reg [1:7] leds3,leds2,leds1,leds0; //the leds mapped to the 7seg display (led3 is left-most 7seg digit)
	
	
	
	always@(posedge !setButton) begin
		case(Q)
		0 : begin
		//opCode <= inputs; 
		Q <= 1; 
		end
		1 : begin 
		registerID <= inputs;
		Q <= 2; 
		end
		2 : begin
		registerID <= inputs;
		Q <= 3;
		end
		
		endcase
	end
	
	
	always@(posedge clock)begin
	
		case(Q)
		0 : begin //state 0: set operation
		opCode <= inputs; //set op code to the inputs
		leds3 <= opCodeDisplay3; //set leds to display operation
		leds2 <= opCodeDisplay2;
		leds1 <= opCodeDisplay1;
		leds0 <= opCodeDisplay0;
		end
		endcase
	end
	
	setOpCodeDisplay op1(clock,opCode,opCodeDisplay3,opCodeDisplay2,opCodeDisplay1,opCodeDisplay0);
	
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

/*
module getOpCode(inputs,opCode);
	input inputs;
	output reg [3:0] opCode;
	
	case(inputs)
	4'b0000 :;
	4'b0001 :;
	4'b0010 :;
	4'b0011 :;
	4'b0100 :;
	4'b0101 :;
	4'b0110 :;
	4'b0111 :;
	4'b1000 :;
	4'b1001 :;
	4'b1010 :;
	4'b1011 :;
	4'b1100 :;
	4'b1101 :;
	4'b1110 :;
	4'b1111 :;
	
	endcase


endmodule*/


module setBytes(bytes);
	//input bytes;
	output reg bytes;
	
	//initial bytes[0] = 1;
/*
	case(register)
	4'b0000 : byte <= 12; //reg 1
	4'b0001 : byte <= 35;
	4'b0010 : byte <= -25;
	4'b0011 : byte <= 8;
	4'b0100 : byte <= -8;
	4'b0101 :;
	4'b0110 :;
	4'b0111 :;


	endcase*/

endmodule











