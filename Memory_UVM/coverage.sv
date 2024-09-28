package cvg_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import parameter_pkg::*;
	import seq_item_pkg::*;

	class coverage extends uvm_component; /* base class*/;
		
		`uvm_component_utils(coverage)
		uvm_analysis_export #(seq_item) cvg_export;
		uvm_tlm_analysis_fifo #(seq_item) cvg_fifo;
		seq_item mytrans;

		

		// Define a covergroup for the memory module
covergroup memory_cg;// @(posedge clk);

    // Coverpoint for reset signal (active low)
    rst_n_cp: coverpoint mytrans.rst_n {
        bins active_low = {0};
        bins active_high = {1};
    }

    // Coverpoint for read enable (rd_en) signal
    rd_en_cp: coverpoint mytrans.rd_en {
        bins read_enabled = {1};
        bins read_disabled = {0};
    }

    // Coverpoint for write enable (wr_en) signal
    wr_en_cp: coverpoint mytrans.wr_en {
        bins write_enabled = {1};
        bins write_disabled = {0};
    }

    // Coverpoint for addresses accessed
    addr_cp: coverpoint mytrans.addr {
        bins all_addresses[] = {[0:DEPTH-1]}; // Cover all possible addresses
    }

    // Coverpoint for data input values
    data_in_cp: coverpoint mytrans.data_in {
        bins all_data_in[] = {[0:(2**DATA_WIDTH)-1]}; // Cover all possible data values
    }

    // Cross coverage for read enable and address
    read_x_addr: cross rd_en_cp, addr_cp {
        ignore_bins ignore_rd = binsof(rd_en_cp) intersect {0}; // Ignore read when read_enable is 0
    }

    // Cross coverage for write enable and address
    write_x_addr: cross wr_en_cp, addr_cp {
        ignore_bins ignore_wr = binsof(wr_en_cp) intersect {0}; // Ignore write when write_enable is 0
    }

    // Cross coverage for reset and address
    reset_x_addr: cross rst_n_cp, addr_cp {
        ignore_bins ignore_reset = binsof(rst_n_cp) intersect {1}; // Ignore when reset is high
    }

endgroup



		function new(string name="coverage",uvm_component parent = null);
			super.new(name,parent);
			// create cover group
			// Instantiate the covergroup
			memory_cg = new(); //mem_cg_inst
		endfunction 

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cvg_export = new("cvg_export",this);
			cvg_fifo   = new("cvg_fifo",this);
		endfunction 

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			cvg_export.connect(cvg_fifo.analysis_export);
		endfunction 

		task run_phase(uvm_phase phase);
			super.run_phase(phase);

			forever begin
				cvg_fifo.get(mytrans);
				// cover group sampling
				memory_cg.sample();
			end
		endtask

	endclass : coverage
endpackage : cvg_pkg