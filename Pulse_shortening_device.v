module Pulse_shortening_device
(
	input IN_CLOCK,
	input IN_PULSE,
	output reg OUT_SHORT_PULSE
);

reg REG_FIRST_CLOCK_WHEN_PULSE_EQUAL_1;
initial begin
	OUT_SHORT_PULSE=0;
	REG_FIRST_CLOCK_WHEN_PULSE_EQUAL_1=0;
end
always @(posedge IN_PULSE or posedge IN_CLOCK)
begin
	if(IN_PULSE)
	begin
		if(!REG_FIRST_CLOCK_WHEN_PULSE_EQUAL_1)
		begin
			OUT_SHORT_PULSE<=1;
			REG_FIRST_CLOCK_WHEN_PULSE_EQUAL_1<=1;
		end 
		else
			OUT_SHORT_PULSE<=0;
	end
	else
	begin
		REG_FIRST_CLOCK_WHEN_PULSE_EQUAL_1<=0;
		OUT_SHORT_PULSE<=0;
	end
end
endmodule
