`timescale 1ns/1ps
module RISE_EDGE_PULSE_LENGTH_CONVERTER_TB1
#(
	parameter DEEP_PULSE_LENGTH_BITS=5,
	parameter CLOCK_FREQUENCY=50000000
);
localparam PERIOD_IN_CLOCK_NS=1000000000/CLOCK_FREQUENCY;

reg IN_CLOCK, IN_PULSE;
reg [DEEP_PULSE_LENGTH_BITS-1:0] IN_LENGTH_OUTPUT_PULSE_CLKS;
wire OUT_CONVERTED_PULSE;

RISE_EDGE_PULSE_LENGTH_CONVERTER
 #(.DEEP_PULSE_LENGTH_BITS(DEEP_PULSE_LENGTH_BITS)) 
 REPLC
 (IN_CLOCK,IN_LENGTH_OUTPUT_PULSE_CLKS,IN_PULSE,OUT_CONVERTED_PULSE);

initial begin
	IN_CLOCK=0;
	IN_LENGTH_OUTPUT_PULSE_CLKS=0;
	IN_PULSE=0;
end

always 
begin
	#(PERIOD_IN_CLOCK_NS/2)
	IN_CLOCK=!IN_CLOCK;
end

integer original_pulse_length;
integer converted_pulse_length;

localparam original_pulse_length_max=9;
localparam converted_pulse_length_max=8;

reg start_flag;

initial begin
	original_pulse_length=1;
	converted_pulse_length=0;
	start_flag=0;
	#(PERIOD_IN_CLOCK_NS*10)
	start_flag=1;
end

initial
begin
	@(posedge start_flag)
	forever 
	begin
			#(PERIOD_IN_CLOCK_NS*2)
			IN_LENGTH_OUTPUT_PULSE_CLKS=converted_pulse_length;
			#(PERIOD_IN_CLOCK_NS*2)
			IN_PULSE=1;
			#(PERIOD_IN_CLOCK_NS*original_pulse_length)
			IN_PULSE=0;
			#(PERIOD_IN_CLOCK_NS*4)
			
			
			if(original_pulse_length<converted_pulse_length)
			begin
				#(PERIOD_IN_CLOCK_NS*(converted_pulse_length-original_pulse_length+1));
			end
			#(PERIOD_IN_CLOCK_NS*2);
			if(converted_pulse_length==converted_pulse_length_max&&original_pulse_length<original_pulse_length_max)
			begin
				converted_pulse_length=0;
				original_pulse_length=original_pulse_length+2;
			end
			else
			begin
				if(original_pulse_length==original_pulse_length_max&&converted_pulse_length==converted_pulse_length_max)
				begin 
					#(PERIOD_IN_CLOCK_NS*500);
				end
				else
				begin
					converted_pulse_length=converted_pulse_length+2;
				end
			end
	end
end

endmodule
