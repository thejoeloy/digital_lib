# ----------------------------------------------------------------------------
# Clock Source - Bank 13
# ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN Y9 [get_ports {clk}];  # "GCLK"

# ----------------------------------------------------------------------------
# User Push Buttons - Bank 34
# ---------------------------------------------------------------------------- 
#set_property PACKAGE_PIN P16 [get_ports {btn}];  # "BTNC"

#set_property IOSTANDARD LVCMOS18 [get_ports -of_objects [get_iobanks 34]];
#set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 13]];
#create_clock -period 100.000 [get_pins -hierarchical -filter {NAME =~ *clk*}]
set_property PACKAGE_PIN T22 [get_ports {result[0]}];  # "LD0"
set_property PACKAGE_PIN T21 [get_ports {result[1]}];  # "LD1"
set_property PACKAGE_PIN U22 [get_ports {result[2]}];  # "LD2"
set_property PACKAGE_PIN U21 [get_ports {result[3]}];  # "LD3"
set_property PACKAGE_PIN V22 [get_ports {result[4]}];  # "LD4"
set_property PACKAGE_PIN W22 [get_ports {result[5]}];  # "LD5"
set_property PACKAGE_PIN U19 [get_ports {result[6]}];  # "LD6"
set_property PACKAGE_PIN U14 [get_ports {result[7]}];  # "LD7"
set_property IOSTANDARD LVCMOS33 [get_ports {result[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {result[7]}]
# ----------------------------------------------------------------------------
# Clock Source - Bank 13
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN Y9 [get_ports {clk}];  # Assuming "GCLK" is the correct pin name for the clock
set_property IOSTANDARD LVCMOS33 [get_ports {clk}];  # Assuming the clock is operating at 3.3V

# ----------------------------------------------------------------------------
# User Push Buttons - Bank 34
# ---------------------------------------------------------------------------- 
set_property PACKAGE_PIN P16 [get_ports {btn}];  # Assuming "BTNC" is the correct pin name for the button
set_property IOSTANDARD LVCMOS18 [get_ports {btn}];  # Assuming the button operates at 1.8V


set_property IOSTANDARD LVCMOS33 [get_ports result]
set_property LOC SLICE_X0Y0 [get_ports result[31:0]]

# ----------------------------------------------------------------------------
# Clock Period Constraint
# ----------------------------------------------------------------------------
create_clock -period 100.000 [get_ports clk]

# ----------------------------------------------------------------------------
# Input and Output Delay Constraints (Optional, adjust as needed)
# ----------------------------------------------------------------------------
set_input_delay -clock [get_ports clk] -max 2.000 [get_ports btn]
set_output_delay -clock [get_ports clk] -max 2.000 [get_ports btn]