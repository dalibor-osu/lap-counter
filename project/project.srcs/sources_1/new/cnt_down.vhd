library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

----------------------------------------------------------
-- Entity declaration for N-bit counter
----------------------------------------------------------

entity cnt_down is
  generic (
    g_CNT_WIDTH : natural := 8 --! Default number of counter bits
  );
  port (
    clk    : in    std_logic; --! Main clock
    rst    : in    std_logic; --! Synchronous reset
    en     : in    std_logic; --! Enable input
    init   : in    std_logic_vector (g_CNT_WIDTH - 1 downto 0); -- Initial value
    cnt    : out   std_logic_vector(g_CNT_WIDTH - 1 downto 0); --! Counter value
    finish : out   std_logic
  );
end entity cnt_down;

----------------------------------------------------------
-- Architecture body for N-bit counter
----------------------------------------------------------

architecture behavioral of cnt_down is

  signal sig_cnt : unsigned(g_CNT_WIDTH - 1 downto 0) := (others => '0'); --! Local counter
  signal cnt_up  : std_logic := '0';
  
begin

  --------------------------------------------------------
  -- p_cnt_up_down:
  -- Clocked process with synchronous reset which implements
  -- n-bit up/down counter.
  --------------------------------------------------------
  p_cnt_down : process (clk) is
  begin
    
    if (sig_cnt = 0) then
        finish <= '1';
    else
        finish <= '0';
    end if;
    
    if rising_edge(clk) then
      if (rst = '1') then
        sig_cnt <= unsigned(init);
        
      elsif (en = '1') then
        sig_cnt <= sig_cnt - 1;
        
        if sig_cnt = 0 then
            finish <= '1';
        end if;
        
      elsif (en = '0') then
        sig_cnt <= unsigned(init);
        
      end if;
    end if;

  end process p_cnt_down;

  -- Output must be retyped from "unsigned" to "std_logic_vector"
  cnt <= std_logic_vector(sig_cnt);

end architecture behavioral;
