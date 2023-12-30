set_property SRC_FILE_INFO {cfile:/home/thejoey/Projects/rv32i-pipelined-cpu/rv32i-pipelined-cpu.srcs/constrs_1/imports/digilent-xdc/Zedboard-Master.xdc rfile:../../../rv32i-pipelined-cpu.srcs/constrs_1/imports/digilent-xdc/Zedboard-Master.xdc id:1} [current_design]
set_property src_info {type:XDC file:1 line:14 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T22 [get_ports {result[0]}];  # "LD0"
set_property src_info {type:XDC file:1 line:15 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN T21 [get_ports {result[1]}];  # "LD1"
set_property src_info {type:XDC file:1 line:16 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U22 [get_ports {result[2]}];  # "LD2"
set_property src_info {type:XDC file:1 line:17 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U21 [get_ports {result[3]}];  # "LD3"
set_property src_info {type:XDC file:1 line:18 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN V22 [get_ports {result[4]}];  # "LD4"
set_property src_info {type:XDC file:1 line:19 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN W22 [get_ports {result[5]}];  # "LD5"
set_property src_info {type:XDC file:1 line:20 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U19 [get_ports {result[6]}];  # "LD6"
set_property src_info {type:XDC file:1 line:21 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN U14 [get_ports {result[7]}];  # "LD7"
set_property src_info {type:XDC file:1 line:33 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN Y9 [get_ports {clk}];  # Assuming "GCLK" is the correct pin name for the clock
set_property src_info {type:XDC file:1 line:39 export:INPUT save:INPUT read:READ} [current_design]
set_property PACKAGE_PIN P16 [get_ports {btn}];  # Assuming "BTNC" is the correct pin name for the button
set_property src_info {type:XDC file:1 line:44 export:INPUT save:INPUT read:READ} [current_design]
set_property LOC SLICE_X0Y0 [get_ports result[31:0]]
set_property src_info {type:XDC file:1 line:54 export:INPUT save:INPUT read:READ} [current_design]
set_input_delay -clock [get_ports clk] -max 2.000 [get_ports btn]
set_property src_info {type:XDC file:1 line:55 export:INPUT save:INPUT read:READ} [current_design]
set_output_delay -clock [get_ports clk] -max 2.000 [get_ports btn]
