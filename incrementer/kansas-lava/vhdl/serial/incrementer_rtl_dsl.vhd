library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.lava.all;
use work.all;
entity incrementer is
  port(clk : in std_logic;
       in_x : in std_logic_vector(15 downto 0);
       reset : in std_logic;
       in_valid : in std_logic;
       out_ready : in std_logic;
       out_valid : out std_logic;
       in_ready : out std_logic;
       out_x : out std_logic_vector(15 downto 0));
end entity incrementer;
architecture str of incrementer is
  signal sig_54_o0 : std_logic_vector(15 downto 0);
  signal sig_55_o0 : std_logic_vector(15 downto 0);
  signal sig_52_o0 : std_logic;
  signal sig_53_o0 : std_logic;
  signal sig_2_o0 : std_logic;
  signal sig_3_o0 : std_logic;
  signal sig_4_o0 : std_logic_vector(17 downto 0);
  signal sig_50_o0 : std_logic;
  signal sig_51_o0 : std_logic;
  signal sig_49_o0 : std_logic;
  signal sig_5_o0 : std_logic_vector(15 downto 0);
  signal sig_6_o0 : std_logic_vector(16 downto 0);
  signal sig_48_o0 : std_logic_vector(15 downto 0);
  signal sig_7_o0 : std_logic;
  signal sig_8_o0 : std_logic_vector(16 downto 0);
  signal sig_39_o0 : std_logic_vector(15 downto 0) := "0000000000000000";
  signal sig_40_o0 : std_logic_vector(15 downto 0);
  signal sig_46_o0 : std_logic_vector(15 downto 0);
  signal sig_47_o0 : std_logic_vector(15 downto 0);
  signal sig_44_o0 : std_logic_vector(15 downto 0);
  signal sig_45_o0 : std_logic_vector(15 downto 0);
  signal sig_41_o0 : std_logic;
  signal sig_42_o0 : std_logic;
  signal sig_43_o0 : std_logic;
  signal sig_9_o0 : std_logic;
  signal sig_10_o0 : std_logic;
  signal sig_11_o0 : std_logic_vector(4 downto 0) := "00000";
  signal sig_12_o0 : std_logic_vector(4 downto 0);
  signal sig_14_o0 : std_logic_vector(4 downto 0);
  signal sig_38_o0 : std_logic_vector(4 downto 0);
  signal sig_30_o0 : std_logic_vector(4 downto 0);
  signal sig_31_o0 : std_logic;
  signal sig_35_o0 : std_logic;
  signal sig_37_o0 : std_logic;
  signal sig_36_o0 : std_logic;
  signal sig_32_o0 : std_logic;
  signal sig_33_o0 : std_logic;
  signal sig_34_o0 : std_logic;
  signal sig_15_o0 : std_logic;
  signal sig_18_o0 : std_logic;
  signal sig_23_o0 : std_logic;
  signal sig_25_o0 : std_logic;
  signal sig_26_o0 : std_logic_vector(17 downto 0);
  signal sig_29_o0 : std_logic;
  signal sig_28_o0 : std_logic;
  signal sig_27_o0 : std_logic_vector(15 downto 0);
  signal sig_24_o0 : std_logic;
  signal sig_19_o0 : std_logic;
  signal sig_21_o0 : std_logic;
  signal sig_22_o0 : std_logic_vector(4 downto 0) := "10000";
  signal sig_20_o0 : std_logic;
  signal sig_16_o0 : std_logic;
  signal sig_17_o0 : std_logic;
  signal sig_13_o0 : std_logic;
begin
  sig_54_o0 <= sig_55_o0;
  sig_55_o0 <= sig_4_o0(15 downto 0);
  sig_52_o0 <= sig_53_o0;
  sig_53_o0 <= sig_4_o0(17);
  sig_2_o0 <= sig_3_o0;
  sig_3_o0 <= sig_4_o0(16);
  -- [("i0",16U,(5).o0),("i1",B,(49).o0),("i2",B,(50).o0)];
  sig_4_o0 <= sig_50_o0 & sig_49_o0 & sig_5_o0;
  sig_50_o0 <= '1' when (sig_51_o0 = '1') else
               '0';
  sig_51_o0 <= '1' when (unsigned(sig_11_o0) = to_unsigned(0,5)) else
               '0';
  sig_49_o0 <= sig_6_o0(0);
  sig_5_o0 <= sig_6_o0(16 downto 1);
  -- [("i0",B,(7).o0),("i1",16U,(48).o0)];
  sig_6_o0 <= sig_48_o0 & sig_7_o0;
  sig_48_o0 <= sig_8_o0(16 downto 1);
  sig_7_o0 <= sig_8_o0(0);
  -- [("i0",B,(9).o0),("i1",16U,(39).o0)];
  sig_8_o0 <= sig_39_o0 & sig_9_o0;
  proc72 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_39_o0 <= sig_40_o0;
      end if;
    end if;
  end process proc72;
  sig_40_o0 <= sig_46_o0 when (sig_41_o0 = '1') else
               sig_44_o0;
  sig_46_o0 <= std_logic_vector((unsigned(sig_47_o0) + to_unsigned(1,
                                                                   16)));
  sig_47_o0 <= sig_26_o0(15 downto 0);
  sig_44_o0 <= sig_45_o0 when (sig_15_o0 = '1') else
               sig_39_o0;
  sig_45_o0 <= std_logic_vector((unsigned(sig_39_o0) + to_unsigned(1,
                                                                   16)));
  sig_41_o0 <= (sig_16_o0 and sig_42_o0);
  sig_42_o0 <= (sig_43_o0 and sig_25_o0);
  sig_43_o0 <= '1' when (unsigned(sig_11_o0) = to_unsigned(0,5)) else
               '0';
  sig_9_o0 <= '1' when (sig_10_o0 = '1') else
              '0';
  sig_10_o0 <= '1' when (unsigned(sig_11_o0) = unsigned(sig_22_o0)) else
               '0';
  proc83 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_11_o0 <= sig_12_o0;
      end if;
    end if;
  end process proc83;
  sig_12_o0 <= "00000" when (sig_13_o0 = '1') else
               sig_14_o0;
  sig_14_o0 <= sig_38_o0 when (sig_15_o0 = '1') else
               sig_30_o0;
  sig_38_o0 <= std_logic_vector((unsigned(sig_11_o0) + to_unsigned(1,
                                                                   5)));
  sig_30_o0 <= "00000" when (sig_31_o0 = '1') else
               sig_11_o0;
  sig_31_o0 <= (sig_32_o0 and sig_35_o0);
  sig_35_o0 <= (sig_36_o0 and sig_37_o0);
  sig_37_o0 <= sig_26_o0(17);
  sig_36_o0 <= '1' when (unsigned(sig_11_o0) = unsigned(sig_22_o0)) else
               '0';
  sig_32_o0 <= (sig_16_o0 and sig_33_o0);
  sig_33_o0 <= not(sig_34_o0);
  sig_34_o0 <= (sig_18_o0 or '0');
  sig_15_o0 <= (sig_16_o0 and sig_18_o0);
  sig_18_o0 <= (sig_19_o0 or sig_23_o0);
  sig_23_o0 <= (sig_24_o0 and sig_25_o0);
  sig_25_o0 <= sig_26_o0(16);
  -- [("i0",16U,(27).o0),("i1",B,(28).o0),("i2",B,(29).o0)];
  sig_26_o0 <= sig_29_o0 & sig_28_o0 & sig_27_o0;
  sig_29_o0 <= out_ready;
  sig_28_o0 <= in_valid;
  sig_27_o0 <= in_x;
  sig_24_o0 <= '1' when (unsigned(sig_11_o0) = to_unsigned(0,5)) else
               '0';
  sig_19_o0 <= (sig_20_o0 and sig_21_o0);
  sig_21_o0 <= '1' when (unsigned(sig_11_o0) < unsigned(sig_22_o0)) else
               '0';
  proc107 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_22_o0 <= sig_22_o0;
      end if;
    end if;
  end process proc107;
  sig_20_o0 <= '1' when (unsigned(sig_11_o0) > to_unsigned(0,5)) else
               '0';
  sig_16_o0 <= not(sig_17_o0);
  sig_17_o0 <= (sig_13_o0 or '0');
  sig_13_o0 <= reset;
  out_valid <= sig_2_o0;
  in_ready <= sig_52_o0;
  out_x <= sig_54_o0;
end architecture str;
