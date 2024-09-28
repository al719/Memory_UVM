package agent_pkg;
	

	import uvm_pkg::*;
	`include "uvm_macros.svh"
	//////////////////////////////////
	/////agent 3-main component///////
	//////////////////////////////////
	import driver_pkg::*;
	import sequencer_pkg::*;
	import monitor_pkg::*;

	import configdb_pkg::*;
	import seq_item_pkg::*;

	class agent extends uvm_agent; /* base class*/;
		
		`uvm_component_utils(agent)
		driver my_drive;
		monitor my_mon;
		sequencer my_sequencer;
		configdb cfg;
		uvm_analysis_port #(seq_item) agt_pt;

		function new(string name="agent",uvm_component parent = null);
			super.new(name,parent);
		endfunction 

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			
			if(!uvm_config_db#(configdb)::get(this,"","cfg_db",cfg))
				`uvm_fatal("MY_TEST" , "FATAL PUTTING BFM INTERFACE in CONFIG_DB");

			my_drive 	 = driver::type_id::create("my_drive",this); 
			my_mon	 	 = monitor::type_id::create("my_mon",this);
			my_sequencer = sequencer::type_id::create("my_sequencer",this);
			agt_pt 		 = new("agt_pt",this);
		endfunction 

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			// connect monitor analysis port with agent analysis port
			my_mon.mon_pt.connect(agt_pt);
			// connect driver  analysis port with agent analysis port
			my_drive.seq_item_port.connect(my_sequencer.seq_item_export);
			// connect virtual interface for driver and monitor
			my_drive.memif = cfg.memif;
			my_mon.memif   = cfg.memif;
		endfunction 
	endclass : agent
endpackage : agent_pkg