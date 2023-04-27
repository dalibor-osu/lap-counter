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
    state   : out   std_logic_vector(1 downto 0) := (others => '0');
    lap     : out   std_logic_vector(3 downto 0) := (others => '0');
    changed : out   std_logic := '0'
  );  
end entity state_ctrl;

architecture Behavioral of state_ctrl is

signal sig_state     :  STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
signal sig_lap       :  STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
signal sig_changed   :  STD_LOGIC := '0';

begin

  p_state_ctrl : process (next_s, rst) is
  begin
    
    if sig_changed = '1' then
        sig_changed <= '0';
    end if;
    
    if(rst = '1') then
        if (sig_state = "00") then
            sig_state <= "01";
            sig_lap <= "0001";
        else
            sig_state <= (others => '0');
            sig_lap <= l_count;
        end if;
    else
        if rising_edge(next_s) then
            if (sig_state = "01") then
                if (sig_lap = l_count) then
                    sig_state <= "11";
                else
                    sig_state <= "10";
                end if;        
                        
            elsif sig_state = "10" then
                sig_state <= "01";   
                                        
            end if;
        end if;
    end if;
end process p_state_ctrl;

    state <= sig_state;
    lap <= sig_lap;
    changed <= sig_changed;
    
end architecture  Behavioral;
