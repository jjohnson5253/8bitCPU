

module alu(clock,operate,reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,result0,result1,result2,result3,result4,
result5,result6,result7,instruction);
input clock,operate;
input [17:0] instruction;
input [7:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7;
output reg [7:0] result0,result1,result2,result3,result4,result5,result6,result7;

reg [7:0] opReg1,opReg2;


always@(posedge clock)begin

	//set the operating registers according to the regID chosen by user in states 1,2
	case(instruction[13:11])//regID1
	4'b0000 : opReg1 <= reg0;
	4'b0001 : opReg1 <= reg1;
	4'b0010 : opReg1 <= reg2;
	4'b0011 : opReg1 <= reg3;
	4'b0100 : opReg1 <= reg4;
	endcase
	case(instruction[10:8])//regID2
	4'b0000 : opReg2 <= reg0;
	4'b0001 : opReg2 <= reg1;
	4'b0010 : opReg2 <= reg2;
	4'b0011 : opReg2 <= reg3;
	4'b0100 : opReg2 <= reg4;
	endcase

	//perform operations between operating registers according to opCode set by user in state 0
	if(operate)begin
	
		//initialize resultRegisters to values of regs so whichever ones aren't operated on stay the same
		//when outputted
		result0 <= reg0;
		result1 <= reg1;
		result2 <= reg2;
		result3 <= reg3;
		result4 <= reg4;
		result5 <= reg5;
		result6 <= reg6;
		result7 <= reg7;
		
		case(instruction[17:14])//opCode
		4'b0000 : begin //add
			//reg7 <= opReg1 + opReg2;
			result0 <= 2;
			result1 <= 1;
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
		
		//opDone <= 1;

	end

end


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

