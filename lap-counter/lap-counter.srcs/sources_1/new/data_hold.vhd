library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity data_hold is
    Port ( l_time : in STD_LOGIC_VECTOR(7 downto 0);
           l_count : in STD_LOGIC_VECTOR(3 downto 0);
           p_time : in STD_LOGIC_VECTOR(3 downto 0);
           state : in STD_LOGIC_VECTOR(1 downto 0);
           l_time_out : out STD_LOGIC_VECTOR(7 downto 0);
           p_time_out : out STD_LOGIC_VECTOR(7 downto 0);
           l_count_out : out STD_LOGIC_VECTOR(3 downto 0));
end data_hold;

architecture Behavioral of data_hold is
    signal sig_l_time : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal sig_l_count : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal sig_p_time : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
begin

p_data_hold : process (l_time, l_count, p_time, state) is
    begin
      if state = "00" then
        sig_l_time <= p_time ;
        sig_p_time <= l_time ;
        sig_l_count <= l_count ;
      end if;
    end process p_data_hold;
    
  
  l_time_out <= sig_l_time;
  p_time_out <= sig_p_time;
  l_count_out <= sig_l_count; 
end Behavioral;