// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Mon Jun 28 11:09:12 2021
// Host        : gauss running 64-bit Ubuntu 18.04.5 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/ms4323/vhdl-from-haskell/ip/convolutional-encoder/ip/convolution_0/convolution_0_sim_netlist.v
// Design      : convolution_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7vx485tffg1761-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "convolution_0,convolution_v9_0_13,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "convolution_v9_0_13,Vivado 2018.3" *) 
(* NotValidForBitStream *)
module convolution_0
   (aclk,
    aresetn,
    s_axis_data_tdata,
    s_axis_data_tvalid,
    s_axis_data_tready,
    m_axis_data_tdata,
    m_axis_data_tvalid,
    m_axis_data_tready);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 aclk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME aclk_intf, ASSOCIATED_BUSIF M_AXIS_DATA:S_AXIS_DATA, ASSOCIATED_RESET aresetn, ASSOCIATED_CLKEN aclken, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) input aclk;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 aresetn_intf RST" *) (* x_interface_parameter = "XIL_INTERFACENAME aresetn_intf, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input aresetn;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_DATA TDATA" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXIS_DATA, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0" *) input [7:0]s_axis_data_tdata;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_DATA TVALID" *) input s_axis_data_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 S_AXIS_DATA TREADY" *) output s_axis_data_tready;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_DATA TDATA" *) (* x_interface_parameter = "XIL_INTERFACENAME M_AXIS_DATA, TDATA_NUM_BYTES 1, TDEST_WIDTH 0, TID_WIDTH 0, TUSER_WIDTH 0, HAS_TREADY 1, HAS_TSTRB 0, HAS_TKEEP 0, HAS_TLAST 0, FREQ_HZ 100000000, PHASE 0.000, LAYERED_METADATA undef, INSERT_VIP 0" *) output [7:0]m_axis_data_tdata;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_DATA TVALID" *) output m_axis_data_tvalid;
  (* x_interface_info = "xilinx.com:interface:axis:1.0 M_AXIS_DATA TREADY" *) input m_axis_data_tready;

  wire aclk;
  wire aresetn;
  wire [7:0]m_axis_data_tdata;
  wire m_axis_data_tready;
  wire m_axis_data_tvalid;
  wire [7:0]s_axis_data_tdata;
  wire s_axis_data_tready;
  wire s_axis_data_tvalid;
  wire NLW_U0_event_s_data_tlast_missing_UNCONNECTED;
  wire NLW_U0_event_s_data_tlast_unexpected_UNCONNECTED;
  wire NLW_U0_m_axis_data_tlast_UNCONNECTED;

  (* C_CONVOLUTION_CODE0 = "79" *) 
  (* C_CONVOLUTION_CODE1 = "109" *) 
  (* C_CONVOLUTION_CODE2 = "3" *) 
  (* C_CONVOLUTION_CODE3 = "3" *) 
  (* C_CONVOLUTION_CODE4 = "3" *) 
  (* C_CONVOLUTION_CODE5 = "3" *) 
  (* C_CONVOLUTION_CODE6 = "3" *) 
  (* C_HAS_ACLKEN = "0" *) 
  (* C_HAS_M_AXIS_DATA_TREADY = "1" *) 
  (* C_PUNC_CODE0 = "0" *) 
  (* C_PUNC_CODE1 = "0" *) 
  (* c_constraint_length = "7" *) 
  (* c_dual_channel = "0" *) 
  (* c_output_rate = "2" *) 
  (* c_punc_input_rate = "1" *) 
  (* c_punc_output_rate = "2" *) 
  (* c_punctured = "0" *) 
  (* c_xdevicefamily = "virtex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  convolution_0_convolution_v9_0_13 U0
       (.aclk(aclk),
        .aclken(1'b1),
        .aresetn(aresetn),
        .event_s_data_tlast_missing(NLW_U0_event_s_data_tlast_missing_UNCONNECTED),
        .event_s_data_tlast_unexpected(NLW_U0_event_s_data_tlast_unexpected_UNCONNECTED),
        .m_axis_data_tdata(m_axis_data_tdata),
        .m_axis_data_tlast(NLW_U0_m_axis_data_tlast_UNCONNECTED),
        .m_axis_data_tready(m_axis_data_tready),
        .m_axis_data_tvalid(m_axis_data_tvalid),
        .s_axis_data_tdata(s_axis_data_tdata),
        .s_axis_data_tlast(1'b0),
        .s_axis_data_tready(s_axis_data_tready),
        .s_axis_data_tvalid(s_axis_data_tvalid));
endmodule

(* C_CONSTRAINT_LENGTH = "7" *) (* C_CONVOLUTION_CODE0 = "79" *) (* C_CONVOLUTION_CODE1 = "109" *) 
(* C_CONVOLUTION_CODE2 = "3" *) (* C_CONVOLUTION_CODE3 = "3" *) (* C_CONVOLUTION_CODE4 = "3" *) 
(* C_CONVOLUTION_CODE5 = "3" *) (* C_CONVOLUTION_CODE6 = "3" *) (* C_DUAL_CHANNEL = "0" *) 
(* C_HAS_ACLKEN = "0" *) (* C_HAS_M_AXIS_DATA_TREADY = "1" *) (* C_OUTPUT_RATE = "2" *) 
(* C_PUNCTURED = "0" *) (* C_PUNC_CODE0 = "0" *) (* C_PUNC_CODE1 = "0" *) 
(* C_PUNC_INPUT_RATE = "1" *) (* C_PUNC_OUTPUT_RATE = "2" *) (* C_XDEVICEFAMILY = "virtex7" *) 
(* ORIG_REF_NAME = "convolution_v9_0_13" *) (* downgradeipidentifiedwarnings = "yes" *) 
module convolution_0_convolution_v9_0_13
   (aclk,
    aresetn,
    aclken,
    s_axis_data_tdata,
    s_axis_data_tvalid,
    s_axis_data_tlast,
    s_axis_data_tready,
    m_axis_data_tdata,
    m_axis_data_tvalid,
    m_axis_data_tlast,
    m_axis_data_tready,
    event_s_data_tlast_missing,
    event_s_data_tlast_unexpected);
  input aclk;
  input aresetn;
  input aclken;
  input [7:0]s_axis_data_tdata;
  input s_axis_data_tvalid;
  input s_axis_data_tlast;
  output s_axis_data_tready;
  output [7:0]m_axis_data_tdata;
  output m_axis_data_tvalid;
  output m_axis_data_tlast;
  input m_axis_data_tready;
  output event_s_data_tlast_missing;
  output event_s_data_tlast_unexpected;

  wire \<const0> ;
  wire aclk;
  wire aresetn;
  wire [1:0]\^m_axis_data_tdata ;
  wire m_axis_data_tready;
  wire m_axis_data_tvalid;
  wire [7:0]s_axis_data_tdata;
  wire s_axis_data_tready;
  wire s_axis_data_tvalid;
  wire NLW_a1_event_s_data_tlast_missing_UNCONNECTED;
  wire NLW_a1_event_s_data_tlast_unexpected_UNCONNECTED;
  wire NLW_a1_m_axis_data_tlast_UNCONNECTED;
  wire [7:2]NLW_a1_m_axis_data_tdata_UNCONNECTED;

  assign event_s_data_tlast_missing = \<const0> ;
  assign event_s_data_tlast_unexpected = \<const0> ;
  assign m_axis_data_tdata[7] = \<const0> ;
  assign m_axis_data_tdata[6] = \<const0> ;
  assign m_axis_data_tdata[5] = \<const0> ;
  assign m_axis_data_tdata[4] = \<const0> ;
  assign m_axis_data_tdata[3] = \<const0> ;
  assign m_axis_data_tdata[2] = \<const0> ;
  assign m_axis_data_tdata[1:0] = \^m_axis_data_tdata [1:0];
  assign m_axis_data_tlast = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_CONVOLUTION_CODE0 = "79" *) 
  (* C_CONVOLUTION_CODE1 = "109" *) 
  (* C_CONVOLUTION_CODE2 = "3" *) 
  (* C_CONVOLUTION_CODE3 = "3" *) 
  (* C_CONVOLUTION_CODE4 = "3" *) 
  (* C_CONVOLUTION_CODE5 = "3" *) 
  (* C_CONVOLUTION_CODE6 = "3" *) 
  (* C_HAS_ACLKEN = "0" *) 
  (* C_HAS_M_AXIS_DATA_TREADY = "1" *) 
  (* C_PUNC_CODE0 = "0" *) 
  (* C_PUNC_CODE1 = "0" *) 
  (* c_constraint_length = "7" *) 
  (* c_dual_channel = "0" *) 
  (* c_output_rate = "2" *) 
  (* c_punc_input_rate = "1" *) 
  (* c_punc_output_rate = "2" *) 
  (* c_punctured = "0" *) 
  (* c_xdevicefamily = "virtex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  convolution_0_convolution_v9_0_13_viv a1
       (.aclk(aclk),
        .aclken(1'b0),
        .aresetn(aresetn),
        .event_s_data_tlast_missing(NLW_a1_event_s_data_tlast_missing_UNCONNECTED),
        .event_s_data_tlast_unexpected(NLW_a1_event_s_data_tlast_unexpected_UNCONNECTED),
        .m_axis_data_tdata({NLW_a1_m_axis_data_tdata_UNCONNECTED[7:2],\^m_axis_data_tdata }),
        .m_axis_data_tlast(NLW_a1_m_axis_data_tlast_UNCONNECTED),
        .m_axis_data_tready(m_axis_data_tready),
        .m_axis_data_tvalid(m_axis_data_tvalid),
        .s_axis_data_tdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,s_axis_data_tdata[0]}),
        .s_axis_data_tlast(1'b0),
        .s_axis_data_tready(s_axis_data_tready),
        .s_axis_data_tvalid(s_axis_data_tvalid));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
hv8xwcESjiVfrpUvOIZNCniOc1Y2mgQ4/MKuYifokuE14KN+YQjmdcjLPvBr3aERR7NKUk9RDWpK
qe15T6/nkQ==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
EJOEDUfOFh2DuA71bpqt3ZOjxaWaI6EeAwBFoD3ylIKVDrP+BazQ/Obh+IP3DosF8OCYeM/NzaI2
C5ncuSqXFl35ano+QYaaTHPGmmCkfSloOlAi/ZGgSNTnnb7A4gZip2tnbwyGR+Ru3UmWXzf8GWW3
XF+tg0VBaRzTnI7CLQI=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
NR+onaSNc6IiFFQJj/+5S6puUJZmcvOIMFhoXZpZHB6v4dgpQLq0oYb0Hk3FaTAj3590i4VyGXGC
QomBlbtoQodSE7ADDld+ztYU7hYwyNZs/QTh/B1kP8IrNPAjS257BWryvJdTh6xAqSzuyVFD+Ik8
MVOBG1ZtVv2WUoQX3SnkWAC5rxOi7NZKeC4TPfVN7EfWXrqkANj2J0nrn4WiZD5QgIe2CizhEnx2
sWNXZuWPufu9VIcXZn/h8M7l3ZP492BgcB8KviJZ5D5aSFOc7XNPXWdG5oWYaCPq4jlgNe8Fp1PM
Ftec65SuaZPU2gmBXNp2mSJaghglg0fxBLu1GQ==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Auo5lh25XEBFEdpcs4KzyzJRhbD7fHbHXIlL9GLPDhT2LdSRolh7BD4gFNXfbDaVHvFXUF4F6Ph/
keeLVCbsHk4egA6ndz6l95cSAfa4tvwPo2+rigGZeoX422X/ENA/KRc1EKb6C6HE3kaHLRvwFb3I
86wuVSgF70zcEO+Q0UECE5ZECUrA3iOv2mi6yy7yXmBraSqqz6qpRKdQZsAoHrAFkF0No1aMIZNX
ZtKRJcpZloiXGZq28SeZtu8DvZG1ipBwgxHG3WiOw68K320RvXDQjWHMO3ByGJqgfS3+E2uHYDc5
WtHOeJ4hxnXgByV2rFeq1NOPsZH7iAFcBHuQOA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2017_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
CNkWL+WLdaS/vzF6rG3FN7lJgXtBKmEx8N4CvzFteuxrjG7A40WEz8AhYs0xU1d0O4F7gMmJjZWM
lAakPY2gueRxSpQ+dO69u9wdsMWkfMNqV1RBHbpXsr+D4XG7sNSktm+ucKQ6yYz7fMLjW5Jab6od
LjreGF4Q+Q1CqSCZgGJpKZviRh6zujSR5xVsj1muAqtJw77TQu9b/wmqGgYCYDtTaVBU3P6TPTTg
DytRWonOyhQIX55SLLu0jEzazEZVHT80uG0dxjf89l7nmWSNkQHyzbs82w0o/Upi1vo4jrYbKiWu
7pELfmoQ/11GJqGCa0ghyGX4O4ZpBacZXdMWpg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
NdhY37hErzpj4MVoDK3bGcci7Q3afCKH7lnxYzJJUmDLlZPZbCXSdFOTkLAeFi9q21RgsPHQw8mk
PWoD7fYXtLzj6nYl3jqAr7CcQ7K4tKg16UnLbevaoKvOPJRyV2/JJk036hM7xpp7H8rdOrSlNtWz
CPJK59e5B7pHKdKai48=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
LKHchKGqhWnukeRQ2FKP+/DJbb3sxbl0vQxJVdM3wWXTCPu2a3IbqmD3mphP1+pWzE+IvffB2jok
XDXfOBxetgKbX1oi0wZZlacoel8dIJ/lwrLv7zbksid5ekU0RQ+EJNGzZUhhMi5ufIJ1sFkdOOpT
Lmx4IgXx3CbcC40nS43Jie0veM53cUfDqHMqpFStuBGSnVKQA4wbqM9WX+qBQluJcVzI1D+oNqfE
sIyVrW9OwdhXGsaD0R/9FjZKpWxkVMGh4yd+cI8e1FtWG9kzhLYJ6XKOD4/SZXhKzfFyRnVMJGvr
Jsr8KT5mfRPHYviV0LyxGxdlk0KJ+lHubQebfQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
ASZqRIOq3WkAVE6vrbdjtvEFKr9LgjkFvZG3icJsTWIStCc5qfm3pSa/0GnAB9YEKm48PoXGyYaE
Td4Q/oZlVbuo8zRltnnyfU1GAQianIrhZYp0GIh8ua69TjSsIgZe8W9M+UcfxhZ/n/xtN0v0qg4A
YO0eiyNMWLWG+2otyBP2a5y9sfFibwhIj4sy7NRuErLQfFi0OjA1MyozqSALnRTePpyt/meuiIjT
d0DFoPU9bhPufmgiXExmaZB5Drbi2JvJCmQf6nT5BG9iRD9FmQRGJCw5k7z6Tnh4xXKURRzucgoj
lYkkaGYWxz1JqRL1O4QyhcnS4aHoryZ0RnrzAg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YIJ4uN4f8legkTuFcgspAGLB4+kijRokGfrqpB2IqermXPqW1uE9jVz8xQtKUhTafIGpC10YvTi6
v6cfZcxxKrraeLtiLp3GdPc6Y7YB8LWrpTDtheVfopVtuORRO7qzMWpW7kDXQqDvl2WFctZhhrtZ
3b+oMRJYisql+8kvFpIY2Hn7mAilb82/ug9pomqPvdzK8JYOGPAAMZN5jmUNRKC0qXgoapdeU8Ml
xPHBkjsLftkZ8J5uC51EWHVeDgmS/UXg+PlKSk5Gw+WpnmmI6He7s/yc8UXOPPZNevwhCjalcqGO
tbb4SnhS08pLoRmiDDI3kcgxOJwtn+YWrZMgLQ==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 22352)
`pragma protect data_block
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
4wTOc7Q55Rc=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
