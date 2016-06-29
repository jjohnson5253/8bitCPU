
module cpu(clock,switches,executeBut,setBut,7seg3,7seg2,7seg1,7seg0);
	input clock; //clock to synchronize processing
	input [7:0] switches; //switches to set instructions
	input executeBut,setBut; //'execute button' to execute instructions, 'set button' to iterate 
	//through instructions
	reg [2:0] state; //state variables
	initial state = 0; //initialize to state 0

	always@(posedge clock)begin
		
		if(!setBut)begin //if set button is pressed, change state

			case(state)

				0 : begin //set opcode and go to state 1
					state <= 1;
				end
				1 : begin //set regid1 and go to state 2
					state <= 2;
				end
				2 : begin//set regid2 and go to state 3
					state <= 3;
				end
				3 : begin//set immediate value and go back to stage 0
					state <= 0;
				end

			endcase
			




		end


	end





endmodule

module instructionFetcher(clock,switches,state);
input [7:0] switches;
input clock,state;
output reg [16:0] instruction;

	always@(posedge clock)begin

		
		case(state)

			0 : begin //set opcode for instruction
				
			end
			1 : begin //set regid1 for instruction
				
			end
			2 : begin//set regid2 for instruction
				
			end
			3 : begin//set immediate value for instruction

			end

		endcase



	end


endmodule

module instructionMemory(clock,instruction,instructionMem,instructionDone,state);
input clock;
input [2:0] state;
input[16:0]instruction;
input instructionDone;
integer i = 0;
output reg[9:0]instructionMem;

always@(posedge instructionDone)begin
		
		instructionMem[i] <= instruction;
		i = i + 1;

end



endmodule