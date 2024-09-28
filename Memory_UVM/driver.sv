package driver_pkg;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	import seq_item_pkg::*;
	class driver extends uvm_driver #(seq_item);  /* base class*/;
		
		`uvm_component_utils(driver);
		virtual mem_if memif;
		seq_item mytrans;

		function new(string name="driver",uvm_component parent = null);
			super.new(name,parent);
		endfunction 

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				mytrans = seq_item::type_id::create("mytrans");
				seq_item_port.get_next_item(mytrans);
				@(negedge memif.clk)
				memif.rd_en   = mytrans.rd_en; 
				memif.addr    = mytrans.addr;
				memif.data_in = mytrans.data_in;
				memif.wr_en   = mytrans.wr_en;
				memif.rst_n   = mytrans.rst_n;	
				seq_item_port.item_done(mytrans);
			end
		endtask : run_phase
	endclass : driver

endpackage : driver_pkg