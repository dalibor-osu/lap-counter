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

----------------------------------------------------------
-- Entity declaration for display driver
--
--             +-------------------+
--        -----|> clk              |
--        -----| rst            dp |-----
--             |          seg(6:0) |--/--
--        --/--| data0(3:0)        |  7
--        --/--| data1(3:0)        |
--        --/--| data2(3:0)        |
--        --/--| data3(3:0)        |
--          4  |           dig(3:0)|--/--
--        --/--| dp_vect(3:0)      |  4
--          4  +-------------------+
--
-- Inputs:
--   clk          -- Main clock
--   rst          -- Synchronous reset
--   dataX(3:0)   -- Data values for individual digits
--   dp_vect(3:0) -- Decimal points for individual digits
--
-- Outputs:
--   dp:          -- Decimal point for specific digit
--   seg(6:0)     -- Cathode values for individual segments
--   dig(3:0)     -- Common anode signals to individual digits
--
----------------------------------------------------------

entity driver_7seg_8digits is
  port (
    clk     : in    std_logic;
    cnt     : in    std_logic_vector(7 downto 0);
    state   : in    std_logic_vector(1 downto 0);
    lap     : in    std_logic_vector(3 downto 0);
    seg     : out   std_logic_vector(6 downto 0);
    dig     : out   std_logic_vector(7 downto 0)
  );
end entity driver_7seg_8digits;

----------------------------------------------------------
-- Architecture declaration for display driver
----------------------------------------------------------

architecture behavioral of driver_7seg_8digits is

  -- Internal clock enable
  signal sig_en_4ms : std_logic;

  -- Internal 2-bit counter for multiplexing 4 digits
  signal sig_cnt_3bit : std_logic_vector(2 downto 0);

  -- Internal 4-bit value for 7-segment decoder
  signal sig_hex : std_logic_vector(3 downto 0);
  
    signal data0   :     std_logic_vector(3 downto 0);
    signal data1   :     std_logic_vector(3 downto 0);
    signal data2   :     std_logic_vector(3 downto 0);
    signal data3   :     std_logic_vector(3 downto 0);

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
      g_CNT_WIDTH => 3
    )
    port map (
      clk => clk,
      rst => '0',
      cnt_up => '0',
      en => sig_en_4ms,
      cnt => sig_cnt_3bit
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
    
sec_min_conv : entity work.seconds_minutes_convertor
    port map (
      seconds_in => cnt,
      tens_minutes_out => data3,
      minutes_out => data2,
      tens_seconds_out => data1,
      seconds_out => data0
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
        case sig_cnt_3bit is

          when "111" =>
            sig_hex <= "1111";
            dig     <= "01111111";

          when "110" =>
            -- DEFINE ALL OUTPUTS FOR "10" HERE
            sig_hex <= "1111";
            dig     <= "10111111";

          when "101" =>
            if state = "01" then
                sig_hex <= "1010";
                
            elsif state = "10" then
                sig_hex <= "1011";
                
            else
                sig_hex <= "1111";
                
            end if;

            dig     <= "11011111";
            
          when "100" =>
          
            if state = "01" then
                sig_hex <= lap;
                
            else
                sig_hex <= "1111";
                
            end if;
            
            dig     <= "11101111";
            
          when "011" =>
            -- DEFINE ALL OUTPUTS FOR "01" HERE
            sig_hex <= data3;
            dig     <= "11110111";
            
          when "010" =>
            -- DEFINE ALL OUTPUTS FOR "01" HERE
            sig_hex <= data2;
            dig     <= "11111011";
            
          when "001" =>
            -- DEFINE ALL OUTPUTS FOR "01" HERE
            sig_hex <= data1;
            dig     <= "11111101";

          when others =>
            -- DEFINE ALL OUTPUTS FOR "00" HERE
            sig_hex <= data0;
            dig     <= "11111110";

        end case;

      end if;

  end process p_mux;

end architecture behavioral;