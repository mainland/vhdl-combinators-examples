// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Mon Jun 28 11:09:12 2021
// Host        : gauss running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/ms4323/vhdl-from-haskell/ip/convolutional-encoder/ip/convolution_0/convolution_0_stub.v
// Design      : convolution_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx485tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "convolution_v9_0_13,Vivado 2018.3" *)
module convolution_0(aclk, aresetn, s_axis_data_tdata, 
  s_axis_data_tvalid, s_axis_data_tready, m_axis_data_tdata, m_axis_data_tvalid, 
  m_axis_data_tready)
/* synthesis syn_black_box black_box_pad_pin="aclk,aresetn,s_axis_data_tdata[7:0],s_axis_data_tvalid,s_axis_data_tready,m_axis_data_tdata[7:0],m_axis_data_tvalid,m_axis_data_tready" */;
  input aclk;
  input aresetn;
  input [7:0]s_axis_data_tdata;
  input s_axis_data_tvalid;
  output s_axis_data_tready;
  output [7:0]m_axis_data_tdata;
  output m_axis_data_tvalid;
  input m_axis_data_tready;
endmodule
