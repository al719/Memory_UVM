module memory #(parameter DATA_WIDTH = 8 , DEPTH = 8)
				(
					input wire rd_en,
					input wire wr_en,
					input wire [$clog2(DATA_WIDTH)-1:0] addr,
					input wire [DATA_WIDTH-1:0] data_in,
					input wire clk,
					input wire rst_n,
					///////////////////////////
					output reg [DATA_WIDTH-1:0] data_out
				);

reg [DATA_WIDTH-1:0] mem [DEPTH];

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		data_out <= 8'b0;
	end else if(wr_en)
		mem[addr] <= data_in;
	else if(rd_en)
		data_out <= mem[addr];
end

endmodule