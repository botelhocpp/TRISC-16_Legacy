##Clock signal
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { clk } ];
create_clock -add -name sys_clk_pin -period 20.00 -waveform {0 10} [get_ports { clk } ];

##Optional Adjustments
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_IBUF]
#set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets rst_IBUF]

##LEDs
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { pin_port[0] } ]; #IO_L23P_T3_35 Sch=LED0
set_property -dict { PACKAGE_PIN M15   IOSTANDARD LVCMOS33 } [get_ports { pin_port[1] } ]; #IO_L23N_T3_35 Sch=LED1
set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { pin_port[2] } ]; #IO_0_35=Sch=LED2
set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVCMOS33 } [get_ports { pin_port[3] } ]; #IO_L3N_T0_DQS_AD1N_35 Sch=LED3

##Switches
set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { pin_port[4] } ]; #IO_L19N_T3_VREF_35 Sch=SW0
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { pin_port[5] } ]; #IO_L24P_T3_34 Sch=SW1
set_property -dict { PACKAGE_PIN W13   IOSTANDARD LVCMOS33 } [get_ports { pin_port[6] } ]; #IO_L4N_T0_34 Sch=SW2
set_property -dict { PACKAGE_PIN T16   IOSTANDARD LVCMOS33 } [get_ports { pin_port[7] } ]; #IO_L9P_T1_DQS_34 Sch=SW3

##Buttons
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { rst } ]; #IO_L20N_T3_34 Sch=BTN0
#set_property -dict { PACKAGE_PIN P16   IOSTANDARD LVCMOS33 } [get_ports { pin_port[8] }]; #IO_L24N_T3_34 Sch=BTN1
#set_property -dict { PACKAGE_PIN V16   IOSTANDARD LVCMOS33 } [get_ports { pin_port[9] }]; #IO_L18P_T2_34 Sch=BTN2
#set_property -dict { PACKAGE_PIN Y16   IOSTANDARD LVCMOS33 } [get_ports { pin_port[10] } ]; #IO_L7P_T1_34 Sch=BTN3

##Pmod Header JB
set_property -dict { PACKAGE_PIN T20   IOSTANDARD LVCMOS33 } [get_ports { pin_port[8] }]; #IO_L15P_T2_DQS_34 Sch=JB1_p
set_property -dict { PACKAGE_PIN U20   IOSTANDARD LVCMOS33 } [get_ports { pin_port[9] }]; #IO_L15N_T2_DQS_34 Sch=JB1_N
set_property -dict { PACKAGE_PIN V20   IOSTANDARD LVCMOS33 } [get_ports { pin_port[10] }]; #IO_L16P_T2_34 Sch=JB2_P
set_property -dict { PACKAGE_PIN W20   IOSTANDARD LVCMOS33 } [get_ports { pin_port[11] }]; #IO_L16N_T2_34 Sch=JB2_N
set_property -dict { PACKAGE_PIN Y18   IOSTANDARD LVCMOS33 } [get_ports { pin_port[12] }]; #IO_L17P_T2_34 Sch=JB3_P
set_property -dict { PACKAGE_PIN Y19   IOSTANDARD LVCMOS33 } [get_ports { pin_port[13] }]; #IO_L17N_T2_34 Sch=JB3_N
set_property -dict { PACKAGE_PIN W18   IOSTANDARD LVCMOS33 } [get_ports { pin_port[14] }]; #IO_L22P_T3_34 Sch=JB4_P
set_property -dict { PACKAGE_PIN W19   IOSTANDARD LVCMOS33 } [get_ports { pin_port[15] }]; #IO_L22N_T3_34 Sch=JB4_N

##Pmod Header JB Pull-Down Setup
set_property PULLDOWN TRUE [get_ports pin_port[8]]
set_property PULLDOWN TRUE [get_ports pin_port[9]]
set_property PULLDOWN TRUE [get_ports pin_port[10]]
set_property PULLDOWN TRUE [get_ports pin_port[11]]
set_property PULLDOWN TRUE [get_ports pin_port[12]]
set_property PULLDOWN TRUE [get_ports pin_port[13]]
set_property PULLDOWN TRUE [get_ports pin_port[14]]
set_property PULLDOWN TRUE [get_ports pin_port[15]]
