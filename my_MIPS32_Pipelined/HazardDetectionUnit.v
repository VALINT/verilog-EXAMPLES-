module HazardDetectionUnit(
	MemRead,
	FirstRegAddr,
	SecondRegAddr,
	SaveRegAddr,
	ConvertToNOP,
	IF_IDWrite,
	PCWrite
);

	input				MemRead;
	input		[4:0]	FirstRegAddr;
	input		[4:0]	SecondRegAddr;
	input		[4:0]	SaveRegAddr;
	
	output wire			ConvertToNOP;
	output wire			IF_IDWrite;
	output wire			PCWrite; 

	assign	ConvertToNOP = (((FirstRegAddr == SaveRegAddr)|(SecondRegAddr == SaveRegAddr)) & MemRead & SaveRegAddr != 0) ? 1'b1 : 1'b0;
	assign	IF_IDWrite = !ConvertToNOP;
	assign	PCWrite = IF_IDWrite;

endmodule