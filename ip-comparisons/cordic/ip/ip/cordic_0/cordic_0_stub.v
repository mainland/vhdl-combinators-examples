// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Tue Jul 13 21:02:47 2021
// Host        : gauss running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/ms4323/vhdl-from-haskell/ip/cordic/cordic_ip-project_32/ip/cordic_0/cordic_0_stub.v
// Design      : cordic_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx485tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "cordic_v6_0_14,Vivado 2018.3" *)
module cordic_0(aclk, s_axis_phase_tvalid, 
  s_axis_phase_tready, s_axis_phase_tdata, m_axis_dout_tvalid, m_axis_dout_tready, 
  m_axis_dout_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_phase_tvalid,s_axis_phase_tready,s_axis_phase_tdata[31:0],m_axis_dout_tvalid,m_axis_dout_tready,m_axis_dout_tdata[63:0]" */;
  input aclk;
  input s_axis_phase_tvalid;
  output s_axis_phase_tready;
  input [31:0]s_axis_phase_tdata;
  output m_axis_dout_tvalid;
  input m_axis_dout_tready;
  output [63:0]m_axis_dout_tdata;
endmodule
