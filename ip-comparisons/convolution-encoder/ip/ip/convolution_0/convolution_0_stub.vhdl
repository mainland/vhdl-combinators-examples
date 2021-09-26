-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
-- Date        : Mon Jun 28 11:09:12 2021
-- Host        : gauss running 64-bit Ubuntu 18.04.5 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/ms4323/vhdl-from-haskell/ip/convolutional-encoder/ip/convolution_0/convolution_0_stub.vhdl
-- Design      : convolution_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7vx485tffg1761-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity convolution_0 is
  Port ( 
    aclk : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axis_data_tdata : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axis_data_tvalid : in STD_LOGIC;
    s_axis_data_tready : out STD_LOGIC;
    m_axis_data_tdata : out STD_LOGIC_VECTOR ( 7 downto 0 );
    m_axis_data_tvalid : out STD_LOGIC;
    m_axis_data_tready : in STD_LOGIC
  );

end convolution_0;

architecture stub of convolution_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "aclk,aresetn,s_axis_data_tdata[7:0],s_axis_data_tvalid,s_axis_data_tready,m_axis_data_tdata[7:0],m_axis_data_tvalid,m_axis_data_tready";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "convolution_v9_0_13,Vivado 2018.3";
begin
end;
