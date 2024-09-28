package scb_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import parameter_pkg::*;
	import seq_item_pkg::*;

	class score_board extends uvm_scoreboard;  /* base class*/;
		`uvm_component_utils(score_board)

		uvm_analysis_export #(seq_item) scb_export;
		uvm_tlm_analysis_fifo #(seq_item) scb_fifo;
		seq_item mytrans;
		/////////////////////////
		///////////ports/////////
		/////////////////////////

			logic[DATA_WIDTH-1:0] data_out_ref;
			// logic[ADDR_WIDTH-1:0] addr_ref;
			logic[DATA_WIDTH-1:0] mem_ref[DEPTH];
			int error_count = 0;
			int correct_count = 0;
		function new(string name="score_board",uvm_component parent = null);
			super.new(name,parent);
		endfunction	

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			scb_export = new("scb_export");
			scb_fifo   = new("scb_fifo");
		endfunction 

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			scb_export.connect(scb_fifo.analysis_export);
		endfunction 

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				scb_fifo.get(mytrans);
				ref_model(mytrans);
				if(data_out_ref != mytrans.data_out) begin
					error_count++;
					`uvm_info("Score Board","FAIL =====================================",UVM_LOW);
				end else begin
					correct_count++;
					`uvm_info("Score Board","PASS =====================================",UVM_LOW);
				end
			end
		endtask : run_phase

		task ref_model(input seq_item seq_ref);
			if(!seq_ref.rst_n) begin
				data_out_ref <= 8'b0;
			end else if(seq_ref.wr_en) begin
				mem_ref[seq_ref.addr] <= seq_ref.data_in;
			end else if(seq_ref.rd_en) begin
				data_out_ref <= mem_ref[seq_ref.addr];
			end
		endtask
	endclass : score_board
endpackage : scb_pkg