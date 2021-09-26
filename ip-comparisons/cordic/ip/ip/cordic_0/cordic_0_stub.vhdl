-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
-- Date        : Tue Jul 13 21:02:47 2021
-- Host        : gauss running 64-bit Ubuntu 18.04.5 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/ms4323/vhdl-from-haskell/ip/cordic/cordic_ip-project_32/ip/cordic_0/cordic_0_stub.vhdl
-- Design      : cordic_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7vx485tffg1761-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cordic_0 is
  Port ( 
    aclk : in STD_LOGIC;
    s_axis_phase_tvalid : in STD_LOGIC;
    s_axis_phase_tready : out STD_LOGIC;
    s_axis_phase_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_dout_tvalid : out STD_LOGIC;
    m_axis_dout_tready : in STD_LOGIC;
    m_axis_dout_tdata : out STD_LOGIC_VECTOR ( 63 downto 0 )
  );

end cordic_0;

architecture stub of cordic_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "aclk,s_axis_phase_tvalid,s_axis_phase_tready,s_axis_phase_tdata[31:0],m_axis_dout_tvalid,m_axis_dout_tready,m_axis_dout_tdata[63:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "cordic_v6_0_14,Vivado 2018.3";
begin
end;
