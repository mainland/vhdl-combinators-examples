---------------------------------------------------------------------------
--
--  (c) Copyright 2013 Xilinx, Inc. All rights reserved.
--
--  This file contains confidential and proprietary information
--  of Xilinx, Inc. and is protected under U.S. and
--  international copyright and other intellectual property
--  laws.
--
--  DISCLAIMER
--  This disclaimer is not a license and does not grant any
--  rights to the materials distributed herewith. Except as
--  otherwise provided in a valid license issued to you by
--  Xilinx, and to the maximum extent permitted by applicable
--  law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
--  WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
--  AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
--  BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
--  INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
--  (2) Xilinx shall not be liable (whether in contract or tort,
--  including negligence, or under any other theory of
--  liability) for any loss or damage of any kind or nature
--  related to, arising under or in connection with these
--  materials, including for any direct, or any indirect,
--  special, incidental, or consequential loss or damage
--  (including loss of data, profits, goodwill, or any type of
--  loss or damage suffered as a result of any action brought
--  by a third party) even if such damage or loss was
--  reasonably foreseeable or Xilinx had been advised of the
--  possibility of the same.
--
--  CRITICAL APPLICATIONS
--  Xilinx products are not designed or intended to be fail-
--  safe, or for use in any application requiring fail-safe
--  performance, such as life-support or safety devices or
--  systems, Class III medical devices, nuclear facilities,
--  applications related to the deployment of airbags, or any
--  other applications that could lead to death, personal
--  injury, or severe property or environmental damage
--  (individually and collectively, "Critical
--  Applications"). Customer assumes the sole risk and
--  liability of any use of Xilinx products in Critical
--  Applications, subject only to applicable laws and
--  regulations governing limitations on product liability.
--
--  THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
--  PART OF THIS FILE AT ALL TIMES.
--
---------------------------------------------------------------------------
-- Description:
-- This is an example testbench for the Convolution Encoder IP core.
-- The testbench has been generated by Vivado to accompany the IP core
-- instance you have generated.
--
-- This testbench is for demonstration purposes only.  See note below for
-- instructions on how to use it with the netlist created for your core.
--
-- See the Convolution Encoder product guide for further information
-- about this core.
--
---------------------------------------------------------------------------
-- Using this testbench
--
-- This testbench instantiates your generated Convolution Encoder core
-- instance named "convolution_0".
--
-- Use Vivado's Run Simulation flow to run this testbench.  See the Vivado
-- documentation for details.
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_convolution_0 is
end tb_convolution_0;

architecture tb of tb_convolution_0 is

  -----------------------------------------------------------------------
  -- Timing constants
  -----------------------------------------------------------------------
  constant CLOCK_PERIOD : time := 100 ns;
  constant T_HOLD       : time := 10 ns;
  constant T_STROBE     : time := CLOCK_PERIOD - (1 ns);

  -----------------------------------------------------------------------
  -- DUT signals
  -----------------------------------------------------------------------

  -- Global signals
  signal aclk                           : std_logic := '0';  -- the master clock
  signal aresetn                        : std_logic := '1';  -- synchronous active low reset

  -- Input data slave channel signals
  signal s_axis_data_tvalid            : std_logic := '0';  -- payload is valid
  signal s_axis_data_tready            : std_logic := '1';  -- slave is ready
  signal s_axis_data_tdata             : std_logic_vector(7 downto 0) := (others => '0');  -- data payload

  -- Output data master channel signals
  signal m_axis_data_tvalid            : std_logic := '0';  -- payload is valid
  signal m_axis_data_tready            : std_logic := '1';  -- slave is ready
  signal m_axis_data_tdata             : std_logic_vector(7 downto 0) := (others => '0');  -- data payload

  -----------------------------------------------------------------------
  -- Aliases for AXI channel TDATA and TUSER fields
  -- These are a convenience for viewing data in a simulator waveform viewer.
  -- If using ModelSim or Questa, add "-voptargs=+acc=n" to the vsim command
  -- to prevent the simulator optimizing away these signals.
  -----------------------------------------------------------------------

  -- Input data slave channel alias signals
  signal s_axis_data_tdata_data_in  : std_logic := '0';  -- DATA_IN field

  -- Output data master channel alias signals
  signal m_axis_data_tdata_data_out : std_logic_vector(1 downto 0) := (others => '0');  -- DATA_OUT field

  -----------------------------------------------------------------------
  -- Testbench types and signals
  -----------------------------------------------------------------------

  -- Overall simulation phase control enumerated type and signal
  type t_sim_phase is (phase_init,           -- testbench initialization
                       phase_normal,         -- normal encoding operation
                       phase_axi_handshake,  -- demonstrate the use and effect of AXI handshaking signals
                       phase_aresetn,        -- demonstrate the use of synchronous reset
                       phase_end             -- end of simulation
                       );
  signal sim_phase : t_sim_phase := phase_init;

  -- Clock cycle count
  signal cycle : integer := 0;

begin

  -----------------------------------------------------------------------
  -- Instantiate the DUT
  -----------------------------------------------------------------------

  dut : entity work.convolution_0
    port map (
      -- Global signals
      aclk                          => aclk,
      aresetn                       => aresetn,
    -- AXI4-Stream slave channel for input data
      s_axis_data_tvalid            => s_axis_data_tvalid,
      s_axis_data_tready            => s_axis_data_tready,
      s_axis_data_tdata             => s_axis_data_tdata,
      -- AXI4-Stream master channel for output data
      m_axis_data_tvalid            => m_axis_data_tvalid,
      m_axis_data_tready            => m_axis_data_tready,
      m_axis_data_tdata             => m_axis_data_tdata
      );


  -----------------------------------------------------------------------
  -- Generate clock
  -----------------------------------------------------------------------

  clock_gen : process
  begin
    aclk <= '0';
    wait for CLOCK_PERIOD;
    loop
      aclk <= '0';
      wait for CLOCK_PERIOD/2;
      aclk <= '1';
      cycle <= cycle + 1;
      wait for CLOCK_PERIOD/2;
    end loop;
  end process clock_gen;


  -----------------------------------------------------------------------
  -- Simulation control
  -- Run a series of demonstrations, each in a separate test phase
  -- This process controls all other stimuli processes
  -----------------------------------------------------------------------

  sim_control : process
  begin

    -- Drive simulation control synchronous to the rising edge of the clock
    wait until rising_edge(aclk);

    -- Normal encoding operation
    sim_phase <= phase_normal;
    wait for 120 * CLOCK_PERIOD;

    -- Demonstrate the use and effect of AXI handshaking signals
    sim_phase <= phase_axi_handshake;
    wait for 120 * CLOCK_PERIOD;

    -- Demonstrate the use of synchronous reset
    sim_phase <= phase_aresetn;
    wait for 120 * CLOCK_PERIOD;

    -- End of simulation
    sim_phase <= phase_end;
    wait for CLOCK_PERIOD;
    report "Not a real failure. Simulation finished successfully. Test completed successfully" severity failure;
    wait;

  end process sim_control;


  -----------------------------------------------------------------------
  -- Generate input data slave channel inputs
  -----------------------------------------------------------------------

  s_data_stimuli : process

    -- Variables for random number generation
    variable seed1, seed2 : positive;
    variable rand         : real;

    -- Procedure to drive a single input data bit on the input data channel
    -- valid_mode defines how to drive TVALID: 0 = TVALID always high, otherwise TVALID low 1 in valid_mode cycles
    -- The transaction payload is tdata
    -- abort is set if a reset aborts the transaction
    procedure drive_input_bit(data           : std_logic;
                              valid_mode     : integer := 0;
                              variable abort : out boolean) is
      variable tdata : std_logic_vector(7 downto 0);
    begin

      -- Construct TDATA signal: only bit 0 is used
      tdata := (0 => data, others => '0');

      -- Drive AXI payload signals
      s_axis_data_tdata <= tdata;

      -- Drive AXI control signal TVALID
      if valid_mode > 0 then
        uniform(seed1, seed2, rand);  -- generate random number
        if rand < 1.0 / real(valid_mode) then
          s_axis_data_tvalid <= '0';  -- deassert TVALID
          uniform(seed1, seed2, rand);  -- generate another random number
          wait for CLOCK_PERIOD * integer(ceil(rand * 4.0));  -- hold low for up to 4 cycles
        end if;
      end if;
      s_axis_data_tvalid <= '1';  -- assert TVALID
      abort := false;
      loop
        wait until rising_edge(aclk);
        if aresetn = '0' then
          abort := true;
          exit;
        end if;
        exit when s_axis_data_tready = '1';
      end loop;
      wait for T_HOLD;
      s_axis_data_tvalid <= '0';
    end procedure drive_input_bit;

    -- Procedure to drive a random input data bit on the input data channel
    -- valid_mode defines how to drive TVALID: 0 = TVALID always high, otherwise TVALID low 1 in valid_mode cycles
    procedure drive_input_random(valid_mode : integer := 0) is
      variable data  : std_logic;
      variable abort : boolean;
    begin

      -- Generate a random input data bit
      uniform(seed1, seed2, rand);  -- generate random number
      if rand < 0.5 then
        data := '0';
      else
        data := '1';
      end if;

      -- Drive the AXI transaction
      drive_input_bit(data       => data,
                      valid_mode => valid_mode,
                      abort      => abort);

    end procedure drive_input_random;

    variable current_phase : t_sim_phase := phase_init;
    variable start_cycle   : integer;

  begin

    -- Wait for simulation control to signal the first phase
    wait until sim_phase = phase_normal;
    wait for T_HOLD;  -- drive inputs T_HOLD after the rising edge of the clock

    -- In each simulation phase, drive inputs for up to 100 clock cycles, then wait for the next phase
    phase_loop: while sim_phase /= phase_end loop
      current_phase := sim_phase;
      start_cycle   := cycle;
      drive_loop: while cycle < start_cycle + 100 loop
        if sim_phase = phase_axi_handshake then
          -- In AXI handshake manipulation phase, gradually decrease how often TVALID is low
          drive_input_random((cycle - start_cycle) / 10);
        else
          drive_input_random;
        end if;
      end loop drive_loop;

      -- Wait for simulation control to signal the next phase
      if sim_phase = current_phase then
        wait until sim_phase /= current_phase;
        wait for T_HOLD;  -- drive inputs T_HOLD after the rising edge of the clock
      end if;

    end loop phase_loop;

    -- End of test
    wait;

  end process s_data_stimuli;


  -----------------------------------------------------------------------
  -- Generate output data master channel TREADY input
  -----------------------------------------------------------------------

  m_data_tready_stimuli : process

    -- Variables for random number generation
    variable seed1, seed2 : positive;
    variable rand         : real;
    -- Clock cycle count at start of AXI handshake manipulation phase
    variable start_cycle  : integer;

  begin

    -- Output channel TREADY is high in all phases except AXI handshake manipulation phase
    m_axis_data_tready <= '1';
    wait until sim_phase = phase_axi_handshake;
    wait until rising_edge(aclk);  -- synchronize to the clock
    wait for T_HOLD;  -- drive inputs T_HOLD after the rising edge of the clock
    start_cycle := cycle;  -- record starting clock cycle count

    -- Gradually increase how often TREADY is low
    while sim_phase = phase_axi_handshake loop

      -- Drive AXI control signal TREADY
      uniform(seed1, seed2, rand);  -- generate random number
      if rand < 1.0 / real(10 - ((cycle - start_cycle) / 12)) then
        m_axis_data_tready <= '0';  -- deassert TREADY
        uniform(seed1, seed2, rand);  -- generate another random number
        wait for CLOCK_PERIOD * integer(ceil(rand * 10.0));  -- hold low for up to 10 cycles
      end if;
      m_axis_data_tready <= '1';  -- assert TREADY
      wait for CLOCK_PERIOD;  -- hold high for at least one cycle

    end loop;

    -- End of test
    wait;

  end process m_data_tready_stimuli;


  -----------------------------------------------------------------------
  -- Generate synchronous reset input
  -----------------------------------------------------------------------

  aresetn_stimuli : process
  begin

    -- Synchronous reset input is active low.
    -- Synchronous reset is high (inactive) in all phases except reset demonstration
    aresetn <= '1';
    wait until sim_phase = phase_aresetn;

    -- Reset the core partway through the test phase.
    -- Note that reset must be asserted for a minimum of two clock cycles (see the datasheet for details).
    wait for CLOCK_PERIOD * 20;
    wait for T_HOLD;  -- drive inputs T_HOLD after the rising edge of the clock

    -- Assert reset for two clock cycles
    aresetn <= '0';  -- reset is active low
    wait for CLOCK_PERIOD * 2;
    aresetn <= '1';

    -- End of test
    wait;

  end process aresetn_stimuli;


  -----------------------------------------------------------------------
  -- Check outputs
  -----------------------------------------------------------------------

  check_outputs : process

    -- Variables for checking the protocol of the output data master channel
    variable check_ok : boolean := true;
    -- Previous values of output data master channel signals
    variable m_data_tvalid_prev : std_logic := '0';
    variable m_data_tready_prev : std_logic := '0';
    variable m_data_tdata_prev  : std_logic_vector(7 downto 0) := (others => '0');

  begin

    -- Check outputs T_STROBE time after rising edge of clock
    wait until rising_edge(aclk);
    wait for T_STROBE;

    -- Do not check the output payload values, as this requires the behavioral model
    -- which would make this demonstration testbench unwieldy.
    -- Instead, check the protocol of the output data master channel:
    -- check that the payload is valid (not X) when TVALID is high
    -- and check that the payload does not change while TVALID is high until TREADY goes high


    if m_axis_data_tvalid = '1' and aresetn = '1' then
      if is_x(m_axis_data_tdata) then
        report "ERROR: m_axis_data_tdata is invalid when m_axis_data_tvalid is high" severity error;
        check_ok := false;
      end if;

      if m_data_tvalid_prev = '1' and m_data_tready_prev = '0' then  -- payload must be the same as last cycle
        if m_axis_data_tdata /= m_data_tdata_prev then
          report "ERROR: m_axis_data_tdata changed while m_axis_data_tvalid was high and m_axis_data_tready was low" severity error;
          check_ok := false;
        end if;
      end if;

    end if;

    assert check_ok
      report "ERROR: terminating test with failures." severity failure;

    -- Record payload values for checking next clock cycle
    if check_ok then
      m_data_tvalid_prev := m_axis_data_tvalid;
      m_data_tready_prev := m_axis_data_tready;
      m_data_tdata_prev  := m_axis_data_tdata;
    end if;

  end process check_outputs;


  -----------------------------------------------------------------------
  -- Assign TDATA / TUSER fields to aliases, for easy simulator waveform viewing
  -----------------------------------------------------------------------

  -- Input data slave channel alias signals
  s_axis_data_tdata_data_in  <= s_axis_data_tdata(0);  -- DATA_IN field

  -- Output data master channel alias signals
  m_axis_data_tdata_data_out <= m_axis_data_tdata(1 downto 0);  -- DATA_OUT field

end tb;
