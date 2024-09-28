package env_pkg;
	import uvm_pkg::*;
	import agent_pkg::*;
	import scb_pkg::*;
	import cvg_pkg::*;
	`include "uvm_macros.svh"

	class env extends uvm_env; /* base class*/;
		`uvm_component_utils(env)

		agent agt; 			// declare agent 	   object
		score_board myscb;  // declare score board object
		coverage cvg;		// declare coverage    object


		function new(string name = "env" , uvm_component parent = null);
			super.new(name,parent);
		endfunction 

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			agt  = agent::type_id::create("agt",this);
			myscb= score_board::type_id::create("myscb",this);
			cvg  = coverage::type_id::create("cvg",this);
		endfunction 

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			// connect agent analysis port with score boad export
			agt.agt_pt.connect(myscb.scb_export);
			// connect agent analysis port with coverage   export
			agt.agt_pt.connect(cvg.cvg_export);
		endfunction 
	endclass : env
endpackage : env_pkg