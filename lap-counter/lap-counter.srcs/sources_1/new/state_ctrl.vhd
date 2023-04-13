----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/13/2023 11:53:08 AM
-- Design Name: 
-- Module Name: state_ctrl - Behavioral
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
  use ieee.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity state_ctrl is

  port (
    next_s  : in    std_logic;
    l_count : in    std_logic_vector(3 downto 0);
    rst     : in    std_logic;
    state   : out   std_logic_vector(1 downto 0);
    lap     : out   std_logic_vector(3 downto 0);
    changed : out   std_logic
  );  
end entity state_ctrl;

architecture Behavioral of state_ctrl is

signal sig_state :  unsigned(1 downto 0) := (others => '0');
signal sig_lap   :  unsigned(3 downto 0) := (others => '0');

begin

  p_state_ctrl : process (next_s) is
  begin
    
    if(rst = '1') then
        if (sig_state = 0) then
            sig_state <= sig_state + 1;
            sig_lap <= TO_UNSIGNED(1, 2);
        else
            sig_state <= (others => '0');
            sig_lap <= unsigned(l_count);
        end if;
    else
        if rising_edge(next_s) then
            if (sig_state = 0) then
                
            end if;
        
        end if;
    end if;

  end process p_state_ctrl;


end architecture  Behavioral;
