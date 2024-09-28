package seq_item_pkg;
	import uvm_pkg::*;
	import parameter_pkg::*;
	
	`include "uvm_macros.svh"

	class seq_item extends uvm_sequence_item; /* base class*/;
		`uvm_object_utils(seq_item)

		rand bit rst_n;
		rand bit rd_en;
		rand bit wr_en;
		rand bit [ADDR_WIDTH-1:0] addr;
		rand bit [DATA_WIDTH-1:0] data_in;
		logic [DATA_WIDTH-1:0] data_out;
		// bit [ADDR_WIDTH-1:0] addr_prev;

		function  new(string name="seq_item");
			super.new(name);
		endfunction 

		constraint c {
			rst_n dist {0:=5 , 1:=95};
		}

		 // Constraints for the memory operations
    constraint addr_range {
        addr inside {[0:DEPTH-1]};     // Address should be within valid memory range
    }
    
    constraint reset_condition {
        // When reset is active, both read and write operations should be disabled
        (rst_n == 0) -> (rd_en == 0 && wr_en == 0);
    }

    constraint mutual_exclusion {
        // rd_en and wr_en should not be active simultaneously
        !(rd_en && wr_en);
    }

    constraint valid_data_input {
        // Generate data within valid range (i.e., 8-bit width or as per DATA_WIDTH)
        data_in inside {[0: (2**DATA_WIDTH) - 1]};
    }

    constraint proper_operation {
        // At least one of rd_en or wr_en should be 1 unless it's reset
        (rst_n == 1) -> (rd_en || wr_en);
    }
    
    // Prevent simultaneous read and write at the same address in the same cycle
    constraint unique_access {
        // If read is enabled, write is disabled and vice versa
        (rd_en == 1) -> (wr_en == 0);
        (wr_en == 1) -> (rd_en == 0);
    }
	endclass : seq_item
endpackage 