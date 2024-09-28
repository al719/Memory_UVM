package configdb_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class configdb extends uvm_object; /* base class*/;
		`uvm_object_utils(configdb)

		virtual mem_if memif;

		function new(string name = "configdb");
			super.new(name);
		endfunction 
	endclass : configdb
endpackage 