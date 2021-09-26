library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity dummy is
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tready : OUT STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tready : OUT STD_LOGIC;
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tready : IN STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end dummy;

architecture Behavioral of dummy is

COMPONENT div_gen_0
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tready : OUT STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tready : OUT STD_LOGIC;
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tready : IN STD_LOGIC;
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;


begin

your_instance_name : div_gen_0
  PORT MAP (
    aclk => aclk,
    s_axis_divisor_tvalid => s_axis_divisor_tvalid,
    s_axis_divisor_tready => s_axis_divisor_tready,
    s_axis_divisor_tdata => s_axis_divisor_tdata,
    s_axis_dividend_tvalid => s_axis_dividend_tvalid,
    s_axis_dividend_tready => s_axis_dividend_tready,
    s_axis_dividend_tdata => s_axis_dividend_tdata,
    m_axis_dout_tvalid => m_axis_dout_tvalid,
    m_axis_dout_tready => m_axis_dout_tready,
    m_axis_dout_tdata => m_axis_dout_tdata
  );


end Behavioral;
