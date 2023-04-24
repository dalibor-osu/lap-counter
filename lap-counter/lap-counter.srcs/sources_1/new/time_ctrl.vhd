----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2023 19:28:04
-- Design Name: 
-- Module Name: time_ctrl - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity time_ctrl is
    Port ( l_time : in STD_LOGIC_VECTOR (7 downto 0);
           p_time : in STD_LOGIC_VECTOR (3 downto 0);
           state : in STD_LOGIC_VECTOR (1 downto 0);
           t_en : out STD_LOGIC;
           time_out : out STD_LOGIC_VECTOR (7 downto 0));
end time_ctrl;

architecture Behavioral of time_ctrl is

    signal sig_time_out : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal sig_t_en     : STD_LOGIC := '0';

begin

p_time_ctrl : process (state, p_time, l_time) is
begin
    
    if state = "00" or state = "11" then
        sig_t_en <= '0';
    else
        sig_t_en <= '1';
    end if;
    
    if state = "00" then
        sig_time_out <= l_time;
    elsif state = "01" then
        sig_time_out <= l_time;
    elsif state = "10" then
        sig_time_out <= p_time;
    else
        sig_time_out <= "00000000";
    end if;

end process p_time_ctrl;

time_out <= sig_time_out;
t_en <= sig_t_en;

end Behavioral;
