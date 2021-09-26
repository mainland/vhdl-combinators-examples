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
  signal sig_82_o0 : std_logic_vector(15 downto 0);
  signal sig_83_o0 : std_logic_vector(15 downto 0);
  signal sig_80_o0 : std_logic;
  signal sig_81_o0 : std_logic;
  signal sig_2_o0 : std_logic;
  signal sig_3_o0 : std_logic;
  signal sig_4_o0 : std_logic_vector(17 downto 0);
  signal sig_79_o0 : std_logic;
  signal sig_5_o0 : std_logic_vector(15 downto 0);
  signal sig_6_o0 : std_logic_vector(16 downto 0);
  signal sig_78_o0 : std_logic_vector(15 downto 0);
  signal sig_7_o0 : std_logic;
  signal sig_8_o0 : std_logic_vector(16 downto 0);
  signal sig_41_o0 : std_logic_vector(15 downto 0);
  type sig_42_o0_type is array (31 downto 0) of std_logic_vector(15 downto 0);
  signal sig_42_o0 : sig_42_o0_type;
  type sig_43_o0_type is array (31 downto 0) of std_logic_vector(15 downto 0);
  signal sig_43_o0 : sig_43_o0_type;
  type sig_44_o0_type is array (31 downto 0) of std_logic_vector(15 downto 0);
  signal sig_44_o0 : sig_44_o0_type;
  signal sig_77_o0 : std_logic_vector(15 downto 0);
  signal sig_75_o0 : std_logic_vector(15 downto 0);
  signal sig_76_o0 : std_logic_vector(15 downto 0);
  signal sig_73_o0 : std_logic_vector(15 downto 0);
  signal sig_74_o0 : std_logic_vector(15 downto 0);
  signal sig_71_o0 : std_logic_vector(15 downto 0);
  signal sig_72_o0 : std_logic_vector(15 downto 0);
  signal sig_69_o0 : std_logic_vector(15 downto 0);
  signal sig_70_o0 : std_logic_vector(15 downto 0);
  signal sig_67_o0 : std_logic_vector(15 downto 0);
  signal sig_68_o0 : std_logic_vector(15 downto 0);
  signal sig_65_o0 : std_logic_vector(15 downto 0);
  signal sig_66_o0 : std_logic_vector(15 downto 0);
  signal sig_63_o0 : std_logic_vector(15 downto 0);
  signal sig_64_o0 : std_logic_vector(15 downto 0);
  signal sig_61_o0 : std_logic_vector(15 downto 0);
  signal sig_62_o0 : std_logic_vector(15 downto 0);
  signal sig_59_o0 : std_logic_vector(15 downto 0);
  signal sig_60_o0 : std_logic_vector(15 downto 0);
  signal sig_57_o0 : std_logic_vector(15 downto 0);
  signal sig_58_o0 : std_logic_vector(15 downto 0);
  signal sig_55_o0 : std_logic_vector(15 downto 0);
  signal sig_56_o0 : std_logic_vector(15 downto 0);
  signal sig_53_o0 : std_logic_vector(15 downto 0);
  signal sig_54_o0 : std_logic_vector(15 downto 0);
  signal sig_51_o0 : std_logic_vector(15 downto 0);
  signal sig_52_o0 : std_logic_vector(15 downto 0);
  signal sig_49_o0 : std_logic_vector(15 downto 0);
  signal sig_50_o0 : std_logic_vector(15 downto 0);
  signal sig_47_o0 : std_logic_vector(15 downto 0);
  signal sig_48_o0 : std_logic_vector(15 downto 0);
  signal sig_45_o0 : std_logic_vector(15 downto 0);
  signal sig_46_o0 : std_logic_vector(15 downto 0);
  signal sig_9_o0 : std_logic;
  type sig_10_o0_type is array (31 downto 0) of std_logic_vector(0 downto 0);
  signal sig_10_o0 : sig_10_o0_type;
  type sig_11_o0_type is array (31 downto 0) of std_logic_vector(0 downto 0);
  signal sig_11_o0 : sig_11_o0_type;
  type sig_40_o0_type is array (31 downto 0) of std_logic_vector(0 downto 0);
  signal sig_40_o0 : sig_40_o0_type;
  type sig_13_o0_type is array (31 downto 0) of std_logic_vector(0 downto 0);
  signal sig_13_o0 : sig_13_o0_type;
  type sig_22_o0_type is array (31 downto 0) of std_logic_vector(0 downto 0);
  signal sig_22_o0 : sig_22_o0_type;
  signal sig_39_o0 : std_logic;
  signal sig_38_o0 : std_logic;
  signal sig_37_o0 : std_logic;
  signal sig_36_o0 : std_logic;
  signal sig_35_o0 : std_logic;
  signal sig_34_o0 : std_logic;
  signal sig_33_o0 : std_logic;
  signal sig_32_o0 : std_logic;
  signal sig_31_o0 : std_logic;
  signal sig_30_o0 : std_logic;
  signal sig_29_o0 : std_logic;
  signal sig_28_o0 : std_logic;
  signal sig_27_o0 : std_logic;
  signal sig_26_o0 : std_logic;
  signal sig_25_o0 : std_logic;
  signal sig_24_o0 : std_logic;
  signal sig_23_o0 : std_logic;
  signal sig_14_o0 : std_logic;
  signal sig_17_o0 : std_logic;
  signal sig_18_o0 : std_logic_vector(17 downto 0);
  signal sig_21_o0 : std_logic;
  signal sig_20_o0 : std_logic;
  signal sig_19_o0 : std_logic_vector(15 downto 0);
  signal sig_15_o0 : std_logic;
  signal sig_16_o0 : std_logic;
  signal sig_12_o0 : std_logic;
begin
  sig_82_o0 <= sig_83_o0;
  sig_83_o0 <= sig_4_o0(15 downto 0);
  sig_80_o0 <= sig_81_o0;
  sig_81_o0 <= sig_4_o0(17);
  sig_2_o0 <= sig_3_o0;
  sig_3_o0 <= sig_4_o0(16);
  -- [("i0",Sampled 128 16,(5).o0),("i1",B,(79).o0),("i2",B,(17).o0)];
  sig_4_o0 <= sig_17_o0 & sig_79_o0 & sig_5_o0;
  sig_79_o0 <= sig_6_o0(0);
  sig_5_o0 <= sig_6_o0(16 downto 1);
  -- [("i0",B,(7).o0),("i1",Sampled 128 16,(78).o0)];
  sig_6_o0 <= sig_78_o0 & sig_7_o0;
  sig_78_o0 <= sig_8_o0(16 downto 1);
  sig_7_o0 <= sig_8_o0(0);
  -- [("i0",B,(9).o0),("i1",Sampled 128 16,(41).o0)];
  sig_8_o0 <= sig_41_o0 & sig_9_o0;
  sig_41_o0 <= sig_42_o0(15);
  proc99 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_42_o0(0) <= sig_43_o0(0);
        sig_42_o0(1) <= sig_43_o0(1);
        sig_42_o0(2) <= sig_43_o0(2);
        sig_42_o0(3) <= sig_43_o0(3);
        sig_42_o0(4) <= sig_43_o0(4);
        sig_42_o0(5) <= sig_43_o0(5);
        sig_42_o0(6) <= sig_43_o0(6);
        sig_42_o0(7) <= sig_43_o0(7);
        sig_42_o0(8) <= sig_43_o0(8);
        sig_42_o0(9) <= sig_43_o0(9);
        sig_42_o0(10) <= sig_43_o0(10);
        sig_42_o0(11) <= sig_43_o0(11);
        sig_42_o0(12) <= sig_43_o0(12);
        sig_42_o0(13) <= sig_43_o0(13);
        sig_42_o0(14) <= sig_43_o0(14);
        sig_42_o0(15) <= sig_43_o0(15);
        sig_42_o0(16) <= sig_43_o0(16);
      end if;
    end if;
  end process proc99;
  sig_43_o0(0) <= sig_44_o0(0) when (sig_14_o0 = '1') else
                  sig_42_o0(0);
  sig_43_o0(1) <= sig_44_o0(1) when (sig_14_o0 = '1') else
                  sig_42_o0(1);
  sig_43_o0(2) <= sig_44_o0(2) when (sig_14_o0 = '1') else
                  sig_42_o0(2);
  sig_43_o0(3) <= sig_44_o0(3) when (sig_14_o0 = '1') else
                  sig_42_o0(3);
  sig_43_o0(4) <= sig_44_o0(4) when (sig_14_o0 = '1') else
                  sig_42_o0(4);
  sig_43_o0(5) <= sig_44_o0(5) when (sig_14_o0 = '1') else
                  sig_42_o0(5);
  sig_43_o0(6) <= sig_44_o0(6) when (sig_14_o0 = '1') else
                  sig_42_o0(6);
  sig_43_o0(7) <= sig_44_o0(7) when (sig_14_o0 = '1') else
                  sig_42_o0(7);
  sig_43_o0(8) <= sig_44_o0(8) when (sig_14_o0 = '1') else
                  sig_42_o0(8);
  sig_43_o0(9) <= sig_44_o0(9) when (sig_14_o0 = '1') else
                  sig_42_o0(9);
  sig_43_o0(10) <= sig_44_o0(10) when (sig_14_o0 = '1') else
                   sig_42_o0(10);
  sig_43_o0(11) <= sig_44_o0(11) when (sig_14_o0 = '1') else
                   sig_42_o0(11);
  sig_43_o0(12) <= sig_44_o0(12) when (sig_14_o0 = '1') else
                   sig_42_o0(12);
  sig_43_o0(13) <= sig_44_o0(13) when (sig_14_o0 = '1') else
                   sig_42_o0(13);
  sig_43_o0(14) <= sig_44_o0(14) when (sig_14_o0 = '1') else
                   sig_42_o0(14);
  sig_43_o0(15) <= sig_44_o0(15) when (sig_14_o0 = '1') else
                   sig_42_o0(15);
  sig_43_o0(16) <= sig_44_o0(16) when (sig_14_o0 = '1') else
                   sig_42_o0(16);
  sig_44_o0(0) <= sig_45_o0;
  sig_44_o0(1) <= sig_47_o0;
  sig_44_o0(2) <= sig_49_o0;
  sig_44_o0(3) <= sig_51_o0;
  sig_44_o0(4) <= sig_53_o0;
  sig_44_o0(5) <= sig_55_o0;
  sig_44_o0(6) <= sig_57_o0;
  sig_44_o0(7) <= sig_59_o0;
  sig_44_o0(8) <= sig_61_o0;
  sig_44_o0(9) <= sig_63_o0;
  sig_44_o0(10) <= sig_65_o0;
  sig_44_o0(11) <= sig_67_o0;
  sig_44_o0(12) <= sig_69_o0;
  sig_44_o0(13) <= sig_71_o0;
  sig_44_o0(14) <= sig_73_o0;
  sig_44_o0(15) <= sig_75_o0;
  sig_44_o0(16) <= sig_77_o0;
  inst77 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_41_o0,
            i1 => "0000000100000000",
            o0 => sig_77_o0);
  inst75 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_76_o0,
            i1 => "0000000100000000",
            o0 => sig_75_o0);
  sig_76_o0 <= sig_42_o0(14);
  inst73 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_74_o0,
            i1 => "0000000100000000",
            o0 => sig_73_o0);
  sig_74_o0 <= sig_42_o0(13);
  inst71 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_72_o0,
            i1 => "0000000100000000",
            o0 => sig_71_o0);
  sig_72_o0 <= sig_42_o0(12);
  inst69 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_70_o0,
            i1 => "0000000100000000",
            o0 => sig_69_o0);
  sig_70_o0 <= sig_42_o0(11);
  inst67 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_68_o0,
            i1 => "0000000100000000",
            o0 => sig_67_o0);
  sig_68_o0 <= sig_42_o0(10);
  inst65 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_66_o0,
            i1 => "0000000100000000",
            o0 => sig_65_o0);
  sig_66_o0 <= sig_42_o0(9);
  inst63 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_64_o0,
            i1 => "0000000100000000",
            o0 => sig_63_o0);
  sig_64_o0 <= sig_42_o0(8);
  inst61 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_62_o0,
            i1 => "0000000100000000",
            o0 => sig_61_o0);
  sig_62_o0 <= sig_42_o0(7);
  inst59 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_60_o0,
            i1 => "0000000100000000",
            o0 => sig_59_o0);
  sig_60_o0 <= sig_42_o0(6);
  inst57 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_58_o0,
            i1 => "0000000100000000",
            o0 => sig_57_o0);
  sig_58_o0 <= sig_42_o0(5);
  inst55 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_56_o0,
            i1 => "0000000100000000",
            o0 => sig_55_o0);
  sig_56_o0 <= sig_42_o0(4);
  inst53 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_54_o0,
            i1 => "0000000100000000",
            o0 => sig_53_o0);
  sig_54_o0 <= sig_42_o0(3);
  inst51 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_52_o0,
            i1 => "0000000100000000",
            o0 => sig_51_o0);
  sig_52_o0 <= sig_42_o0(2);
  inst49 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_50_o0,
            i1 => "0000000100000000",
            o0 => sig_49_o0);
  sig_50_o0 <= sig_42_o0(1);
  inst47 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_48_o0,
            i1 => "0000000100000000",
            o0 => sig_47_o0);
  sig_48_o0 <= sig_42_o0(0);
  inst45 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_46_o0,
            i1 => "0000000100000000",
            o0 => sig_45_o0);
  sig_46_o0 <= sig_18_o0(15 downto 0);
  sig_9_o0 <= lava_to_std_logic(sig_10_o0(15));
  proc168 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_10_o0(0) <= sig_11_o0(0);
        sig_10_o0(1) <= sig_11_o0(1);
        sig_10_o0(2) <= sig_11_o0(2);
        sig_10_o0(3) <= sig_11_o0(3);
        sig_10_o0(4) <= sig_11_o0(4);
        sig_10_o0(5) <= sig_11_o0(5);
        sig_10_o0(6) <= sig_11_o0(6);
        sig_10_o0(7) <= sig_11_o0(7);
        sig_10_o0(8) <= sig_11_o0(8);
        sig_10_o0(9) <= sig_11_o0(9);
        sig_10_o0(10) <= sig_11_o0(10);
        sig_10_o0(11) <= sig_11_o0(11);
        sig_10_o0(12) <= sig_11_o0(12);
        sig_10_o0(13) <= sig_11_o0(13);
        sig_10_o0(14) <= sig_11_o0(14);
        sig_10_o0(15) <= sig_11_o0(15);
        sig_10_o0(16) <= sig_11_o0(16);
      end if;
    end if;
  end process proc168;
  sig_11_o0(0) <= sig_40_o0(0) when (sig_12_o0 = '1') else
                  sig_13_o0(0);
  sig_11_o0(1) <= sig_40_o0(1) when (sig_12_o0 = '1') else
                  sig_13_o0(1);
  sig_11_o0(2) <= sig_40_o0(2) when (sig_12_o0 = '1') else
                  sig_13_o0(2);
  sig_11_o0(3) <= sig_40_o0(3) when (sig_12_o0 = '1') else
                  sig_13_o0(3);
  sig_11_o0(4) <= sig_40_o0(4) when (sig_12_o0 = '1') else
                  sig_13_o0(4);
  sig_11_o0(5) <= sig_40_o0(5) when (sig_12_o0 = '1') else
                  sig_13_o0(5);
  sig_11_o0(6) <= sig_40_o0(6) when (sig_12_o0 = '1') else
                  sig_13_o0(6);
  sig_11_o0(7) <= sig_40_o0(7) when (sig_12_o0 = '1') else
                  sig_13_o0(7);
  sig_11_o0(8) <= sig_40_o0(8) when (sig_12_o0 = '1') else
                  sig_13_o0(8);
  sig_11_o0(9) <= sig_40_o0(9) when (sig_12_o0 = '1') else
                  sig_13_o0(9);
  sig_11_o0(10) <= sig_40_o0(10) when (sig_12_o0 = '1') else
                   sig_13_o0(10);
  sig_11_o0(11) <= sig_40_o0(11) when (sig_12_o0 = '1') else
                   sig_13_o0(11);
  sig_11_o0(12) <= sig_40_o0(12) when (sig_12_o0 = '1') else
                   sig_13_o0(12);
  sig_11_o0(13) <= sig_40_o0(13) when (sig_12_o0 = '1') else
                   sig_13_o0(13);
  sig_11_o0(14) <= sig_40_o0(14) when (sig_12_o0 = '1') else
                   sig_13_o0(14);
  sig_11_o0(15) <= sig_40_o0(15) when (sig_12_o0 = '1') else
                   sig_13_o0(15);
  sig_11_o0(16) <= sig_40_o0(16) when (sig_12_o0 = '1') else
                   sig_13_o0(16);
  sig_40_o0(0) <= "" & '0';
  sig_40_o0(1) <= "" & '0';
  sig_40_o0(2) <= "" & '0';
  sig_40_o0(3) <= "" & '0';
  sig_40_o0(4) <= "" & '0';
  sig_40_o0(5) <= "" & '0';
  sig_40_o0(6) <= "" & '0';
  sig_40_o0(7) <= "" & '0';
  sig_40_o0(8) <= "" & '0';
  sig_40_o0(9) <= "" & '0';
  sig_40_o0(10) <= "" & '0';
  sig_40_o0(11) <= "" & '0';
  sig_40_o0(12) <= "" & '0';
  sig_40_o0(13) <= "" & '0';
  sig_40_o0(14) <= "" & '0';
  sig_40_o0(15) <= "" & '0';
  sig_40_o0(16) <= "" & '0';
  sig_13_o0(0) <= sig_22_o0(0) when (sig_14_o0 = '1') else
                  sig_10_o0(0);
  sig_13_o0(1) <= sig_22_o0(1) when (sig_14_o0 = '1') else
                  sig_10_o0(1);
  sig_13_o0(2) <= sig_22_o0(2) when (sig_14_o0 = '1') else
                  sig_10_o0(2);
  sig_13_o0(3) <= sig_22_o0(3) when (sig_14_o0 = '1') else
                  sig_10_o0(3);
  sig_13_o0(4) <= sig_22_o0(4) when (sig_14_o0 = '1') else
                  sig_10_o0(4);
  sig_13_o0(5) <= sig_22_o0(5) when (sig_14_o0 = '1') else
                  sig_10_o0(5);
  sig_13_o0(6) <= sig_22_o0(6) when (sig_14_o0 = '1') else
                  sig_10_o0(6);
  sig_13_o0(7) <= sig_22_o0(7) when (sig_14_o0 = '1') else
                  sig_10_o0(7);
  sig_13_o0(8) <= sig_22_o0(8) when (sig_14_o0 = '1') else
                  sig_10_o0(8);
  sig_13_o0(9) <= sig_22_o0(9) when (sig_14_o0 = '1') else
                  sig_10_o0(9);
  sig_13_o0(10) <= sig_22_o0(10) when (sig_14_o0 = '1') else
                   sig_10_o0(10);
  sig_13_o0(11) <= sig_22_o0(11) when (sig_14_o0 = '1') else
                   sig_10_o0(11);
  sig_13_o0(12) <= sig_22_o0(12) when (sig_14_o0 = '1') else
                   sig_10_o0(12);
  sig_13_o0(13) <= sig_22_o0(13) when (sig_14_o0 = '1') else
                   sig_10_o0(13);
  sig_13_o0(14) <= sig_22_o0(14) when (sig_14_o0 = '1') else
                   sig_10_o0(14);
  sig_13_o0(15) <= sig_22_o0(15) when (sig_14_o0 = '1') else
                   sig_10_o0(15);
  sig_13_o0(16) <= sig_22_o0(16) when (sig_14_o0 = '1') else
                   sig_10_o0(16);
  sig_22_o0(0) <= "" & sig_23_o0;
  sig_22_o0(1) <= "" & sig_24_o0;
  sig_22_o0(2) <= "" & sig_25_o0;
  sig_22_o0(3) <= "" & sig_26_o0;
  sig_22_o0(4) <= "" & sig_27_o0;
  sig_22_o0(5) <= "" & sig_28_o0;
  sig_22_o0(6) <= "" & sig_29_o0;
  sig_22_o0(7) <= "" & sig_30_o0;
  sig_22_o0(8) <= "" & sig_31_o0;
  sig_22_o0(9) <= "" & sig_32_o0;
  sig_22_o0(10) <= "" & sig_33_o0;
  sig_22_o0(11) <= "" & sig_34_o0;
  sig_22_o0(12) <= "" & sig_35_o0;
  sig_22_o0(13) <= "" & sig_36_o0;
  sig_22_o0(14) <= "" & sig_37_o0;
  sig_22_o0(15) <= "" & sig_38_o0;
  sig_22_o0(16) <= "" & sig_39_o0;
  sig_39_o0 <= lava_to_std_logic(sig_10_o0(15));
  sig_38_o0 <= lava_to_std_logic(sig_10_o0(14));
  sig_37_o0 <= lava_to_std_logic(sig_10_o0(13));
  sig_36_o0 <= lava_to_std_logic(sig_10_o0(12));
  sig_35_o0 <= lava_to_std_logic(sig_10_o0(11));
  sig_34_o0 <= lava_to_std_logic(sig_10_o0(10));
  sig_33_o0 <= lava_to_std_logic(sig_10_o0(9));
  sig_32_o0 <= lava_to_std_logic(sig_10_o0(8));
  sig_31_o0 <= lava_to_std_logic(sig_10_o0(7));
  sig_30_o0 <= lava_to_std_logic(sig_10_o0(6));
  sig_29_o0 <= lava_to_std_logic(sig_10_o0(5));
  sig_28_o0 <= lava_to_std_logic(sig_10_o0(4));
  sig_27_o0 <= lava_to_std_logic(sig_10_o0(3));
  sig_26_o0 <= lava_to_std_logic(sig_10_o0(2));
  sig_25_o0 <= lava_to_std_logic(sig_10_o0(1));
  sig_24_o0 <= lava_to_std_logic(sig_10_o0(0));
  sig_23_o0 <= sig_18_o0(16);
  sig_14_o0 <= (sig_15_o0 and sig_17_o0);
  sig_17_o0 <= sig_18_o0(17);
  -- [("i0",Sampled 128 16,(19).o0),("i1",B,(20).o0),("i2",B,(21).o0)];
  sig_18_o0 <= sig_21_o0 & sig_20_o0 & sig_19_o0;
  sig_21_o0 <= out_ready;
  sig_20_o0 <= in_valid;
  sig_19_o0 <= in_x;
  sig_15_o0 <= not(sig_16_o0);
  sig_16_o0 <= (sig_12_o0 or '0');
  sig_12_o0 <= reset;
  out_valid <= sig_2_o0;
  in_ready <= sig_80_o0;
  out_x <= sig_82_o0;
end architecture str;
