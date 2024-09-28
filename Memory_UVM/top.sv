import parameter_pkg::*;
module top();

import uvm_pkg::*;
import test_pkg::*;
`include "uvm_macros.svh"

bit clk;
initial begin
	clk = 0;
	forever #2 clk = ~clk;
end
mem_if mem_interface(clk);
memory #(.DATA_WIDTH(DATA_WIDTH),.DEPTH(DEPTH)) 
												DUT (
														.clk     (mem_interface.clk),
														.rst_n   (mem_interface.rst_n),
														.wr_en 	 (mem_interface.wr_en),
														.rd_en 	 (mem_interface.rd_en),
														.data_in (mem_interface.data_in),
														.addr    (mem_interface.addr),
														.data_out(mem_interface.data_out)
														);

initial begin
	uvm_config_db#(virtual mem_if)::set(null, "uvm_test_top", "mem_if",mem_interface); // null we are inside module not a class
	run_test("test");
end
endmodule