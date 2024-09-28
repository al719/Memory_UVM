import parameter_pkg::*;

interface mem_if (input bit clk);
	
	logic rd_en , wr_en , rst_n ;
	logic [DATA_WIDTH-1:0] data_in , data_out;
	logic [ADDR_WIDTH-1:0] addr;

endinterface : mem_if