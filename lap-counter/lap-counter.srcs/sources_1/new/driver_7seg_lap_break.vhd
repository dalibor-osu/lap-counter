----------------------------------------------------------
--
--! @title Driver for 4-digit 7-segment display
--! @author Tomas Fryza
--! Dept. of Radio Electronics, Brno Univ. of Technology, Czechia
--!
--! @copyright (c) 2020 Tomas Fryza
--! This work is licensed under the terms of the MIT license
--
-- Hardware: Nexys A7-50T, xc7a50ticsg324-1L
-- Software: TerosHDL, Vivado 2020.2, EDA Playground
--
----------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity driver_7seg_lap_break is
  port (
    clk     : in    std_logic;
    state   : in    std_logic_vector(1 downto 0);
    lap     : in    std_logic_vector(3 downto 0);
    seg     : out   std_logic_vector(6 downto 0);
    dig     : out   std_logic_vector(3 downto 0)
  );
end entity driver_7seg_lap_break;

----------------------------------------------------------
-- Architecture declaration for display driver
----------------------------------------------------------

architecture behavioral of driver_7seg_lap_break is

  -- Internal clock enable
  signal sig_en_4ms : std_logic;

  -- Internal 2-bit counter for multiplexing 4 digits
  signal sig_cnt_2bit : std_logic_vector(1 downto 0);

  -- Internal 4-bit value for 7-segment decoder
  signal sig_hex : std_logic_vector(3 downto 0);

begin

  --------------------------------------------------------
  -- Instance (copy) of clock_enable entity generates
  -- an enable pulse every 4 ms
  --------------------------------------------------------
  clk_en0 : entity work.clock_enable
    generic map (
      -- FOR SIMULATION, KEEP THIS VALUE TO 4
      -- FOR IMPLEMENTATION, CHANGE THIS VALUE TO 400,000
      -- 4      @ 4 ns
      -- 400000 @ 4 ms
      g_MAX => 400000
    )
    port map (
      clk => clk,
      rst => '0',
      ce  => sig_en_4ms
    );

  --------------------------------------------------------
  -- Instance (copy) of cnt_up_down entity performs
  -- a 2-bit down counter
  --------------------------------------------------------
  bin_cnt0 : entity work.cnt_up_down
    generic map (
      g_CNT_WIDTH => 2
    )
    port map (
      clk => clk,
      rst => '0',
      cnt_up => '0',
      en => sig_en_4ms,
      cnt => sig_cnt_2bit
    );

  --------------------------------------------------------
  -- Instance (copy) of hex_7seg entity performs
  -- a 7-segment display decoder
  --------------------------------------------------------
  hex2seg : entity work.hex_7seg
    port map (
      blank => '0',
      hex   => sig_hex,
      seg   => seg
    );

  --------------------------------------------------------
  -- p_mux:
  -- A sequential process that implements a multiplexer for
  -- selecting data for a single digit, a decimal point,
  -- and switches the common anodes of each display.
  --------------------------------------------------------
  p_mux : process (clk) is
  begin

    if (rising_edge(clk)) then
        case sig_cnt_2bit is

          when "11" =>
            sig_hex <= "1111";
            dig     <= "0111";

          when "10" =>
            sig_hex <= "1111";
            dig     <= "1011";

          when "01" =>
            if state = "01" then
                sig_hex <= "1010";
                
            elsif state = "10" then
                sig_hex <= "1011";
                
            else
                sig_hex <= "1111";
                
            end if;

            dig     <= "1101";

          when others =>
            if state = "01" then
                sig_hex <= lap;
                
            else
                sig_hex <= "1111";
                
            end if;
            
            dig     <= "1110";

        end case;

    end if;

  end process p_mux;

end architecture behavioral;