package sequencer_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"

	import seq_item_pkg::*;
	class sequencer extends uvm_sequencer #(seq_item); /* base class*/;
		`uvm_component_utils(sequencer)
		function new(string name="sequencer",uvm_component parent = null);
			super.new(name,parent);
		endfunction
	endclass : sequencer
endpackage : sequencer_pkg