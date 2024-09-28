package test_pkg;

	import uvm_pkg::*;
	import env_pkg::*;
	import seq_pkg::*;
	import configdb_pkg::*;
	`include "uvm_macros.svh"


	class test extends uvm_test; /* base class*/;
		
		`uvm_component_utils(test)

		env 	 my_env; //declare environment   object
		mysequence my_seq; //declare mysequence      object
		configdb cfg;	 //declare configuration object

		// virtual mem_if memory_if;

		function new(string name = "test" , uvm_component parent = null);
			super.new(name , parent);
		endfunction

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			my_env = env::type_id::create("my_env",this);
			my_seq = mysequence::type_id::create("my_seq"); // object not a component
			cfg    = configdb::type_id::create("cfg"); // object not a component 
		
			///////////////////////////////////////////////////////////////////////////////////////////////////////
			/////////////////////////getting interface and passing it to smaller classes///////////////////////////
			///////////////////////////////////////////////////////////////////////////////////////////////////////


			if(!uvm_config_db#(virtual mem_if)::get(this,"","mem_if",cfg.memif))
				`uvm_fatal("MY_TEST" , "FATAL PUTTING BFM INTERFACE in CONFIG_DB");

			uvm_config_db#(configdb)::set(this,"*", "cfg_db",cfg);
		endfunction 

		task run_phase(uvm_phase phase);
			super.run_phase(phase);

			phase.raise_objection(this);
			
			my_seq.start(my_env.agt.my_sequencer); // need agent and sequencer
			phase.drop_objection(this);			
		endtask : run_phase



	endclass 
endpackage 