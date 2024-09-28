package monitor_pkg;
	
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	import seq_item_pkg::*;
	class monitor extends uvm_monitor; /* base class*/;
		`uvm_component_utils(monitor);

		virtual mem_if memif;
		seq_item mytrans;
		uvm_analysis_port #(seq_item) mon_pt;

		function new(string name="monitor",uvm_component parent = null);
			super.new(name,parent);
			mon_pt = new("mon_pt",this);
		endfunction 


		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				mytrans = seq_item::type_id::create("mytrans");
				@(negedge memif.clk)
				mytrans.rd_en    = memif.rd_en;    
				mytrans.addr     = memif.addr;    
				mytrans.data_in  = memif.data_in; 
				mytrans.wr_en    = memif.wr_en;   
				mytrans.rst_n    = memif.rst_n;   
				mytrans.data_out = memif.data_out;  
				mon_pt.write(mytrans);
			end
		endtask : run_phase

	endclass : monitor

endpackage : monitor_pkg