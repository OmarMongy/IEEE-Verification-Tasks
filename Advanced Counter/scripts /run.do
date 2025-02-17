#vsim -c -do "do run.do"
vlib work
vlog AdvancedCounter.sv AdvancedCounter_tb.sv +cover -covercells
vsim -voptargs=+acc work.AdvancedCounter_tb -cover
add wave *
coverage save AdvancedCounter_tb.ucdb -onexit 
run -all
vcover report AdvancedCounter_tb.ucdb -details -annotate -all -output coverage_AdvancedCounter.txt
