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
  signal sig_139_o0 : std_logic_vector(15 downto 0);
  signal sig_140_o0 : std_logic_vector(15 downto 0);
  signal sig_137_o0 : std_logic;
  signal sig_138_o0 : std_logic;
  signal sig_2_o0 : std_logic;
  signal sig_3_o0 : std_logic;
  signal sig_4_o0 : std_logic_vector(17 downto 0);
  signal sig_136_o0 : std_logic;
  signal sig_5_o0 : std_logic_vector(15 downto 0);
  signal sig_6_o0 : std_logic_vector(16 downto 0);
  signal sig_135_o0 : std_logic_vector(15 downto 0);
  signal sig_7_o0 : std_logic;
  signal sig_8_o0 : std_logic_vector(16 downto 0);
  signal sig_68_o0 : std_logic_vector(15 downto 0);
  signal sig_72_o0 : std_logic_vector(15 downto 0);
  signal sig_73_o0 : std_logic_vector(15 downto 0);
  signal sig_74_o0 : std_logic_vector(15 downto 0);
  signal sig_76_o0 : std_logic_vector(15 downto 0);
  signal sig_77_o0 : std_logic_vector(15 downto 0);
  signal sig_78_o0 : std_logic_vector(15 downto 0);
  signal sig_80_o0 : std_logic_vector(15 downto 0);
  signal sig_81_o0 : std_logic_vector(15 downto 0);
  signal sig_82_o0 : std_logic_vector(15 downto 0);
  signal sig_84_o0 : std_logic_vector(15 downto 0);
  signal sig_85_o0 : std_logic_vector(15 downto 0);
  signal sig_86_o0 : std_logic_vector(15 downto 0);
  signal sig_88_o0 : std_logic_vector(15 downto 0);
  signal sig_89_o0 : std_logic_vector(15 downto 0);
  signal sig_90_o0 : std_logic_vector(15 downto 0);
  signal sig_92_o0 : std_logic_vector(15 downto 0);
  signal sig_93_o0 : std_logic_vector(15 downto 0);
  signal sig_94_o0 : std_logic_vector(15 downto 0);
  signal sig_96_o0 : std_logic_vector(15 downto 0);
  signal sig_97_o0 : std_logic_vector(15 downto 0);
  signal sig_98_o0 : std_logic_vector(15 downto 0);
  signal sig_100_o0 : std_logic_vector(15 downto 0);
  signal sig_101_o0 : std_logic_vector(15 downto 0);
  signal sig_102_o0 : std_logic_vector(15 downto 0);
  signal sig_104_o0 : std_logic_vector(15 downto 0);
  signal sig_105_o0 : std_logic_vector(15 downto 0);
  signal sig_106_o0 : std_logic_vector(15 downto 0);
  signal sig_108_o0 : std_logic_vector(15 downto 0);
  signal sig_109_o0 : std_logic_vector(15 downto 0);
  signal sig_110_o0 : std_logic_vector(15 downto 0);
  signal sig_112_o0 : std_logic_vector(15 downto 0);
  signal sig_113_o0 : std_logic_vector(15 downto 0);
  signal sig_114_o0 : std_logic_vector(15 downto 0);
  signal sig_116_o0 : std_logic_vector(15 downto 0);
  signal sig_117_o0 : std_logic_vector(15 downto 0);
  signal sig_118_o0 : std_logic_vector(15 downto 0);
  signal sig_120_o0 : std_logic_vector(15 downto 0);
  signal sig_121_o0 : std_logic_vector(15 downto 0);
  signal sig_122_o0 : std_logic_vector(15 downto 0);
  signal sig_124_o0 : std_logic_vector(15 downto 0);
  signal sig_125_o0 : std_logic_vector(15 downto 0);
  signal sig_126_o0 : std_logic_vector(15 downto 0);
  signal sig_128_o0 : std_logic_vector(15 downto 0);
  signal sig_129_o0 : std_logic_vector(15 downto 0);
  signal sig_130_o0 : std_logic_vector(15 downto 0);
  signal sig_132_o0 : std_logic_vector(15 downto 0);
  signal sig_133_o0 : std_logic_vector(15 downto 0);
  signal sig_134_o0 : std_logic_vector(15 downto 0);
  signal sig_131_o0 : std_logic_vector(15 downto 0);
  signal sig_127_o0 : std_logic_vector(15 downto 0);
  signal sig_123_o0 : std_logic_vector(15 downto 0);
  signal sig_119_o0 : std_logic_vector(15 downto 0);
  signal sig_115_o0 : std_logic_vector(15 downto 0);
  signal sig_111_o0 : std_logic_vector(15 downto 0);
  signal sig_107_o0 : std_logic_vector(15 downto 0);
  signal sig_103_o0 : std_logic_vector(15 downto 0);
  signal sig_99_o0 : std_logic_vector(15 downto 0);
  signal sig_95_o0 : std_logic_vector(15 downto 0);
  signal sig_91_o0 : std_logic_vector(15 downto 0);
  signal sig_87_o0 : std_logic_vector(15 downto 0);
  signal sig_83_o0 : std_logic_vector(15 downto 0);
  signal sig_79_o0 : std_logic_vector(15 downto 0);
  signal sig_75_o0 : std_logic_vector(15 downto 0);
  signal sig_71_o0 : std_logic_vector(15 downto 0);
  signal sig_69_o0 : std_logic;
  signal sig_70_o0 : std_logic;
  signal sig_9_o0 : std_logic;
  signal sig_11_o0 : std_logic;
  signal sig_21_o0 : std_logic;
  signal sig_22_o0 : std_logic;
  signal sig_24_o0 : std_logic;
  signal sig_25_o0 : std_logic;
  signal sig_27_o0 : std_logic;
  signal sig_28_o0 : std_logic;
  signal sig_30_o0 : std_logic;
  signal sig_31_o0 : std_logic;
  signal sig_33_o0 : std_logic;
  signal sig_34_o0 : std_logic;
  signal sig_36_o0 : std_logic;
  signal sig_37_o0 : std_logic;
  signal sig_39_o0 : std_logic;
  signal sig_40_o0 : std_logic;
  signal sig_42_o0 : std_logic;
  signal sig_43_o0 : std_logic;
  signal sig_45_o0 : std_logic;
  signal sig_46_o0 : std_logic;
  signal sig_48_o0 : std_logic;
  signal sig_49_o0 : std_logic;
  signal sig_51_o0 : std_logic;
  signal sig_52_o0 : std_logic;
  signal sig_54_o0 : std_logic;
  signal sig_55_o0 : std_logic;
  signal sig_57_o0 : std_logic;
  signal sig_58_o0 : std_logic;
  signal sig_60_o0 : std_logic;
  signal sig_61_o0 : std_logic;
  signal sig_63_o0 : std_logic;
  signal sig_64_o0 : std_logic;
  signal sig_66_o0 : std_logic;
  signal sig_67_o0 : std_logic;
  signal sig_65_o0 : std_logic;
  signal sig_62_o0 : std_logic;
  signal sig_59_o0 : std_logic;
  signal sig_56_o0 : std_logic;
  signal sig_53_o0 : std_logic;
  signal sig_50_o0 : std_logic;
  signal sig_47_o0 : std_logic;
  signal sig_44_o0 : std_logic;
  signal sig_41_o0 : std_logic;
  signal sig_38_o0 : std_logic;
  signal sig_35_o0 : std_logic;
  signal sig_32_o0 : std_logic;
  signal sig_29_o0 : std_logic;
  signal sig_26_o0 : std_logic;
  signal sig_23_o0 : std_logic;
  signal sig_20_o0 : std_logic;
  signal sig_12_o0 : std_logic;
  signal sig_14_o0 : std_logic;
  signal sig_15_o0 : std_logic;
  signal sig_16_o0 : std_logic_vector(17 downto 0);
  signal sig_19_o0 : std_logic;
  signal sig_18_o0 : std_logic;
  signal sig_17_o0 : std_logic_vector(15 downto 0);
  signal sig_13_o0 : std_logic;
  signal sig_10_o0 : std_logic;
begin
  sig_139_o0 <= sig_140_o0;
  sig_140_o0 <= sig_4_o0(15 downto 0);
  sig_137_o0 <= sig_138_o0;
  sig_138_o0 <= sig_4_o0(17);
  sig_2_o0 <= sig_3_o0;
  sig_3_o0 <= sig_4_o0(16);
  -- [("i0",Sampled 128 16,(5).o0),("i1",B,(136).o0),("i2",B,(15).o0)];
  sig_4_o0 <= sig_15_o0 & sig_136_o0 & sig_5_o0;
  sig_136_o0 <= sig_6_o0(0);
  sig_5_o0 <= sig_6_o0(16 downto 1);
  -- [("i0",B,(7).o0),("i1",Sampled 128 16,(135).o0)];
  sig_6_o0 <= sig_135_o0 & sig_7_o0;
  sig_135_o0 <= sig_8_o0(16 downto 1);
  sig_7_o0 <= sig_8_o0(0);
  -- [("i0",B,(9).o0),("i1",Sampled 128 16,(68).o0)];
  sig_8_o0 <= sig_68_o0 & sig_9_o0;
  sig_68_o0 <= sig_72_o0 when (sig_69_o0 = '1') else
               sig_71_o0;
  inst72 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_73_o0,
            i1 => "0000000100000000",
            o0 => sig_72_o0);
  proc157 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_73_o0 <= sig_74_o0;
      end if;
    end if;
  end process proc157;
  sig_74_o0 <= sig_76_o0 when (sig_69_o0 = '1') else
               sig_75_o0;
  inst76 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_77_o0,
            i1 => "0000000100000000",
            o0 => sig_76_o0);
  proc160 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_77_o0 <= sig_78_o0;
      end if;
    end if;
  end process proc160;
  sig_78_o0 <= sig_80_o0 when (sig_69_o0 = '1') else
               sig_79_o0;
  inst80 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_81_o0,
            i1 => "0000000100000000",
            o0 => sig_80_o0);
  proc163 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_81_o0 <= sig_82_o0;
      end if;
    end if;
  end process proc163;
  sig_82_o0 <= sig_84_o0 when (sig_69_o0 = '1') else
               sig_83_o0;
  inst84 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_85_o0,
            i1 => "0000000100000000",
            o0 => sig_84_o0);
  proc166 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_85_o0 <= sig_86_o0;
      end if;
    end if;
  end process proc166;
  sig_86_o0 <= sig_88_o0 when (sig_69_o0 = '1') else
               sig_87_o0;
  inst88 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_89_o0,
            i1 => "0000000100000000",
            o0 => sig_88_o0);
  proc169 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_89_o0 <= sig_90_o0;
      end if;
    end if;
  end process proc169;
  sig_90_o0 <= sig_92_o0 when (sig_69_o0 = '1') else
               sig_91_o0;
  inst92 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_93_o0,
            i1 => "0000000100000000",
            o0 => sig_92_o0);
  proc172 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_93_o0 <= sig_94_o0;
      end if;
    end if;
  end process proc172;
  sig_94_o0 <= sig_96_o0 when (sig_69_o0 = '1') else
               sig_95_o0;
  inst96 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_97_o0,
            i1 => "0000000100000000",
            o0 => sig_96_o0);
  proc175 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_97_o0 <= sig_98_o0;
      end if;
    end if;
  end process proc175;
  sig_98_o0 <= sig_100_o0 when (sig_69_o0 = '1') else
               sig_99_o0;
  inst100 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_101_o0,
            i1 => "0000000100000000",
            o0 => sig_100_o0);
  proc178 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_101_o0 <= sig_102_o0;
      end if;
    end if;
  end process proc178;
  sig_102_o0 <= sig_104_o0 when (sig_69_o0 = '1') else
                sig_103_o0;
  inst104 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_105_o0,
            i1 => "0000000100000000",
            o0 => sig_104_o0);
  proc181 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_105_o0 <= sig_106_o0;
      end if;
    end if;
  end process proc181;
  sig_106_o0 <= sig_108_o0 when (sig_69_o0 = '1') else
                sig_107_o0;
  inst108 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_109_o0,
            i1 => "0000000100000000",
            o0 => sig_108_o0);
  proc184 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_109_o0 <= sig_110_o0;
      end if;
    end if;
  end process proc184;
  sig_110_o0 <= sig_112_o0 when (sig_69_o0 = '1') else
                sig_111_o0;
  inst112 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_113_o0,
            i1 => "0000000100000000",
            o0 => sig_112_o0);
  proc187 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_113_o0 <= sig_114_o0;
      end if;
    end if;
  end process proc187;
  sig_114_o0 <= sig_116_o0 when (sig_69_o0 = '1') else
                sig_115_o0;
  inst116 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_117_o0,
            i1 => "0000000100000000",
            o0 => sig_116_o0);
  proc190 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_117_o0 <= sig_118_o0;
      end if;
    end if;
  end process proc190;
  sig_118_o0 <= sig_120_o0 when (sig_69_o0 = '1') else
                sig_119_o0;
  inst120 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_121_o0,
            i1 => "0000000100000000",
            o0 => sig_120_o0);
  proc193 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_121_o0 <= sig_122_o0;
      end if;
    end if;
  end process proc193;
  sig_122_o0 <= sig_124_o0 when (sig_69_o0 = '1') else
                sig_123_o0;
  inst124 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_125_o0,
            i1 => "0000000100000000",
            o0 => sig_124_o0);
  proc196 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_125_o0 <= sig_126_o0;
      end if;
    end if;
  end process proc196;
  sig_126_o0 <= sig_128_o0 when (sig_69_o0 = '1') else
                sig_127_o0;
  inst128 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_129_o0,
            i1 => "0000000100000000",
            o0 => sig_128_o0);
  proc199 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_129_o0 <= sig_130_o0;
      end if;
    end if;
  end process proc199;
  sig_130_o0 <= sig_132_o0 when (sig_69_o0 = '1') else
                sig_131_o0;
  inst132 : entity lava_sampled_add
  generic map (frac_width => 8,width => 16)
  port map (i0 => sig_133_o0,
            i1 => "0000000100000000",
            o0 => sig_132_o0);
  proc202 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_133_o0 <= sig_134_o0;
      end if;
    end if;
  end process proc202;
  sig_134_o0 <= sig_16_o0(15 downto 0);
  proc204 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_131_o0 <= sig_130_o0;
      end if;
    end if;
  end process proc204;
  proc205 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_127_o0 <= sig_126_o0;
      end if;
    end if;
  end process proc205;
  proc206 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_123_o0 <= sig_122_o0;
      end if;
    end if;
  end process proc206;
  proc207 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_119_o0 <= sig_118_o0;
      end if;
    end if;
  end process proc207;
  proc208 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_115_o0 <= sig_114_o0;
      end if;
    end if;
  end process proc208;
  proc209 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_111_o0 <= sig_110_o0;
      end if;
    end if;
  end process proc209;
  proc210 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_107_o0 <= sig_106_o0;
      end if;
    end if;
  end process proc210;
  proc211 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_103_o0 <= sig_102_o0;
      end if;
    end if;
  end process proc211;
  proc212 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_99_o0 <= sig_98_o0;
      end if;
    end if;
  end process proc212;
  proc213 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_95_o0 <= sig_94_o0;
      end if;
    end if;
  end process proc213;
  proc214 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_91_o0 <= sig_90_o0;
      end if;
    end if;
  end process proc214;
  proc215 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_87_o0 <= sig_86_o0;
      end if;
    end if;
  end process proc215;
  proc216 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_83_o0 <= sig_82_o0;
      end if;
    end if;
  end process proc216;
  proc217 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_79_o0 <= sig_78_o0;
      end if;
    end if;
  end process proc217;
  proc218 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_75_o0 <= sig_74_o0;
      end if;
    end if;
  end process proc218;
  proc219 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_71_o0 <= sig_68_o0;
      end if;
    end if;
  end process proc219;
  sig_69_o0 <= (sig_13_o0 and sig_70_o0);
  proc221 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_70_o0 <= sig_15_o0;
      end if;
    end if;
  end process proc221;
  sig_9_o0 <= '0' when (sig_10_o0 = '1') else
              sig_11_o0;
  sig_11_o0 <= sig_21_o0 when (sig_12_o0 = '1') else
               sig_20_o0;
  proc224 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_21_o0 <= sig_22_o0;
      end if;
    end if;
  end process proc224;
  sig_22_o0 <= sig_24_o0 when (sig_12_o0 = '1') else
               sig_23_o0;
  proc226 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_24_o0 <= sig_25_o0;
      end if;
    end if;
  end process proc226;
  sig_25_o0 <= sig_27_o0 when (sig_12_o0 = '1') else
               sig_26_o0;
  proc228 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_27_o0 <= sig_28_o0;
      end if;
    end if;
  end process proc228;
  sig_28_o0 <= sig_30_o0 when (sig_12_o0 = '1') else
               sig_29_o0;
  proc230 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_30_o0 <= sig_31_o0;
      end if;
    end if;
  end process proc230;
  sig_31_o0 <= sig_33_o0 when (sig_12_o0 = '1') else
               sig_32_o0;
  proc232 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_33_o0 <= sig_34_o0;
      end if;
    end if;
  end process proc232;
  sig_34_o0 <= sig_36_o0 when (sig_12_o0 = '1') else
               sig_35_o0;
  proc234 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_36_o0 <= sig_37_o0;
      end if;
    end if;
  end process proc234;
  sig_37_o0 <= sig_39_o0 when (sig_12_o0 = '1') else
               sig_38_o0;
  proc236 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_39_o0 <= sig_40_o0;
      end if;
    end if;
  end process proc236;
  sig_40_o0 <= sig_42_o0 when (sig_12_o0 = '1') else
               sig_41_o0;
  proc238 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_42_o0 <= sig_43_o0;
      end if;
    end if;
  end process proc238;
  sig_43_o0 <= sig_45_o0 when (sig_12_o0 = '1') else
               sig_44_o0;
  proc240 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_45_o0 <= sig_46_o0;
      end if;
    end if;
  end process proc240;
  sig_46_o0 <= sig_48_o0 when (sig_12_o0 = '1') else
               sig_47_o0;
  proc242 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_48_o0 <= sig_49_o0;
      end if;
    end if;
  end process proc242;
  sig_49_o0 <= sig_51_o0 when (sig_12_o0 = '1') else
               sig_50_o0;
  proc244 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_51_o0 <= sig_52_o0;
      end if;
    end if;
  end process proc244;
  sig_52_o0 <= sig_54_o0 when (sig_12_o0 = '1') else
               sig_53_o0;
  proc246 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_54_o0 <= sig_55_o0;
      end if;
    end if;
  end process proc246;
  sig_55_o0 <= sig_57_o0 when (sig_12_o0 = '1') else
               sig_56_o0;
  proc248 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_57_o0 <= sig_58_o0;
      end if;
    end if;
  end process proc248;
  sig_58_o0 <= sig_60_o0 when (sig_12_o0 = '1') else
               sig_59_o0;
  proc250 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_60_o0 <= sig_61_o0;
      end if;
    end if;
  end process proc250;
  sig_61_o0 <= sig_63_o0 when (sig_12_o0 = '1') else
               sig_62_o0;
  proc252 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_63_o0 <= sig_64_o0;
      end if;
    end if;
  end process proc252;
  sig_64_o0 <= sig_66_o0 when (sig_12_o0 = '1') else
               sig_65_o0;
  proc254 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_66_o0 <= sig_67_o0;
      end if;
    end if;
  end process proc254;
  sig_67_o0 <= sig_16_o0(16);
  proc256 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_65_o0 <= sig_64_o0;
      end if;
    end if;
  end process proc256;
  proc257 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_62_o0 <= sig_61_o0;
      end if;
    end if;
  end process proc257;
  proc258 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_59_o0 <= sig_58_o0;
      end if;
    end if;
  end process proc258;
  proc259 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_56_o0 <= sig_55_o0;
      end if;
    end if;
  end process proc259;
  proc260 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_53_o0 <= sig_52_o0;
      end if;
    end if;
  end process proc260;
  proc261 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_50_o0 <= sig_49_o0;
      end if;
    end if;
  end process proc261;
  proc262 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_47_o0 <= sig_46_o0;
      end if;
    end if;
  end process proc262;
  proc263 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_44_o0 <= sig_43_o0;
      end if;
    end if;
  end process proc263;
  proc264 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_41_o0 <= sig_40_o0;
      end if;
    end if;
  end process proc264;
  proc265 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_38_o0 <= sig_37_o0;
      end if;
    end if;
  end process proc265;
  proc266 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_35_o0 <= sig_34_o0;
      end if;
    end if;
  end process proc266;
  proc267 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_32_o0 <= sig_31_o0;
      end if;
    end if;
  end process proc267;
  proc268 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_29_o0 <= sig_28_o0;
      end if;
    end if;
  end process proc268;
  proc269 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_26_o0 <= sig_25_o0;
      end if;
    end if;
  end process proc269;
  proc270 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_23_o0 <= sig_22_o0;
      end if;
    end if;
  end process proc270;
  proc271 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_20_o0 <= sig_11_o0;
      end if;
    end if;
  end process proc271;
  sig_12_o0 <= (sig_13_o0 and sig_14_o0);
  proc273 : process(clk) is
  begin
    if rising_edge(clk) then
      if true then
        sig_14_o0 <= sig_15_o0;
      end if;
    end if;
  end process proc273;
  sig_15_o0 <= sig_16_o0(17);
  -- [("i0",Sampled 128 16,(17).o0),("i1",B,(18).o0),("i2",B,(19).o0)];
  sig_16_o0 <= sig_19_o0 & sig_18_o0 & sig_17_o0;
  sig_19_o0 <= out_ready;
  sig_18_o0 <= in_valid;
  sig_17_o0 <= in_x;
  sig_13_o0 <= not(sig_10_o0);
  sig_10_o0 <= reset;
  out_valid <= sig_2_o0;
  in_ready <= sig_137_o0;
  out_x <= sig_139_o0;
end architecture str;
