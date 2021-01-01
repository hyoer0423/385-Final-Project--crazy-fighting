transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {lab8_7_1200mv_85c_slow.vo}

vlog -sv -work work +incdir+D:/100/Lab8_provided {D:/100/Lab8_provided/testbench.sv}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 10000 ns
