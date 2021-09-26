library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;

library vunit_lib;
context vunit_lib.vunit_context;

library osvvm;
use osvvm.RandomPkg.all;

entity tb_example is
  generic (
    runner_cfg : string;
    tb_path    : string;
    csv_i      : string := "data/in.csv";
    csv_o      : string := "data/out.csv"
  );
end entity tb_example;

architecture test of tb_example is
  constant clk_period : time := 10 ns;

  constant m_I : integer_array_t := load_csv(tb_path & csv_i);
  constant m_O : integer_array_t := load_csv(tb_path & csv_o);
  signal clk : std_logic := '1';
  signal reset : std_logic := '0';
  signal rst : std_logic := '0';
  signal start, done, saved : boolean := false;
  signal en : boolean := true;
  signal in_ready : boolean;
  signal in_valid : boolean;
  signal in_x : unsigned(15 downto 0);
  signal out_ready : boolean;
  signal out_valid : boolean;
  signal out_x : unsigned(15 downto 0);
begin
  clk <= not clk after clk_period/2;

  main: process
  begin
    test_runner_setup(runner, runner_cfg);
    while test_suite loop
      if run("test") then
        rst <= '1';
        wait for 15*clk_period;
        rst <= '0';

        info("Init test");
        wait until rising_edge(clk);
        start <= true;
        wait until rising_edge(clk);
        start <= false;

        wait until (done and saved and rising_edge(clk));

        info("Test done");
      end if;
    end loop;
    test_runner_cleanup(runner);
  end process;

  test_runner_watchdog(runner, 5000*clk_period);

  stimuli: process
    variable rnd : RandomPType;
  begin
    rnd.InitSeed("common_seed");

    wait until start and rising_edge(clk);
    done <= false;
    wait until rising_edge(clk);

    for i in 0 to height(m_I)-1 loop
      in_x <= unsigned(to_slv(to_ufixed(get(m_I, i),7,-8)));
      wait for rnd.RandInt(0, 5)*clk_period;
      in_valid <= true;

      wait until rising_edge(clk) and in_ready = true;
      info("in_x = " & to_string(get(m_I, i)) & " (" & to_string(i) & " of " & to_string(height(m_I)-1) & ")");
      in_valid <= false;
    end loop;

    wait until rising_edge(clk);
    done <= true;

    wait;
  end process;

  save: process
    variable rnd : RandomPType;
  begin
    saved <= false;


    wait until start and rising_edge(clk);

    for i in 0 to height(m_O)-1 loop
      out_ready <= false;
      wait for rnd.RandInt(0, 50)*clk_period;
      out_ready <= true;

      wait until rising_edge(clk) and out_valid = true;
      info("out_x = " & to_string(to_integer(to_ufixed(std_logic_vector(out_x),7,-8))) & " (" & to_string(i) & " of " & to_string(height(m_O)-1) & ")");
      check_equal(to_integer(to_ufixed(std_logic_vector(out_x),7,-8)), get(m_O, i), "Comparing output with reference");
      report(to_string(to_integer(to_ufixed(std_logic_vector(out_x),7,-8))));
      report(to_string(get(m_O, i)));
      report(to_string(in_ready));
      report(to_string(out_valid));
    end loop;

    wait until rising_edge(clk);
    saved <= true;

    wait;
  end process;


  uut: entity work.incrementer port map
  ( clk => clk,
    rst => rst,
    en => en,
    in_x => in_x,
    in_valid => in_valid,
    out_ready => out_ready,
    out_x => out_x,
    out_valid => out_valid,
    in_ready => in_ready
    );
end architecture test;
