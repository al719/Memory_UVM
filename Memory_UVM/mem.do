vlib work
vlog *.sv +cover -covercells
vsim -voptargs=+accs work.top -cover -classdebug -uvmcontrol=all
# -debugDB
add wave top/DUT/*
run 0
add wave sim:/uvm_root/uvm_test_top/my_env/myscb/data_out_ref
add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/my_env/myscb/correct_count \
sim:/uvm_root/uvm_test_top/my_env/myscb/error_count

add wave -position insertpoint  \
sim:/uvm_root/uvm_test_top/my_env/agt/my_sequencer/my_seq

coverage save tob.ucdb -onexit -du memory
run -all
#quit -sim
#vcover report tob.ucdb -annotate -details -all -output memory_rpt.txt