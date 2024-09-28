package seq_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"


	import  seq_item_pkg::*;
	
	class mysequence extends uvm_sequence #(seq_item); /* base class*/;
		`uvm_object_utils(mysequence)

		seq_item mytrans;

		function new(string name = "mysequence");
			super.new(name);
		endfunction

		task body();
			repeat(1000) begin
				mytrans = seq_item::type_id::create("mytrans");
				start_item(mytrans);
				assert(mytrans.randomize());
				finish_item(mytrans);
				get_response(mytrans);
			end
		endtask 
	endclass : mysequence
endpackage : seq_pkg