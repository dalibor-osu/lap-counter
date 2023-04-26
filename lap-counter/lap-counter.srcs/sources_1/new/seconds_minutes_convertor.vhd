----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2023 10:04:00
-- Design Name: 
-- Module Name: seconds_minutes_convertor - Behavioral
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
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity seconds_minutes_convertor is
    Port ( seconds_in : in STD_LOGIC_VECTOR (7 downto 0);
    
           minutes_out : out STD_LOGIC_VECTOR (3 downto 0);
           seconds_out : out STD_LOGIC_VECTOR (3 downto 0);
           
           tens_minutes_out : out STD_LOGIC_VECTOR (3 downto 0);
           tens_seconds_out : out STD_LOGIC_VECTOR (3 downto 0)
         );
           
end seconds_minutes_convertor;

architecture Behavioral of seconds_minutes_convertor is

    signal sig_seconds : unsigned(7 downto 0);
    
    signal sig_seconds_out : std_logic_vector(5 downto 0) := (others => '0');
    signal sig_minutes_out : std_logic_vector(5 downto 0) := (others => '0');
    signal sig_tens_seconds_out : std_logic_vector(5 downto 0) := (others => '0');
    signal sig_tens_minutes_out : std_logic_vector(5 downto 0) := (others => '0');

begin

p_count : process

    variable seconds_var : unsigned(7 downto 0) := (others => '0') ;
    variable minutes_var : unsigned(5 downto 0) := (others => '0');
    variable tens_seconds_var : unsigned(7 downto 0) := (others => '0') ;
    variable tens_minutes_var : unsigned(5 downto 0) := (others => '0');

begin
      
    if unsigned(seconds_in) /= sig_seconds then
    
        sig_seconds <= unsigned(seconds_in);
        
        seconds_var := sig_seconds;
        minutes_var := (others => '0');
        
        while seconds_var > 59 loop
            minutes_var := minutes_var + 1;
            seconds_var := seconds_var - 60;
        end loop;
        
        while seconds_var > 9 loop
            tens_seconds_var := tens_seconds_var + 1;
            seconds_var := seconds_var - 10;
        end loop;
        
        while minutes_var > 9 loop
            tens_minutes_var := tens_minutes_var + 1;
            minutes_var := minutes_var - 10;
        end loop;
        
        sig_seconds_out <= std_logic_vector(seconds_var);
        sig_minutes_out <= std_logic_vector(minutes_var);
        sig_tens_seconds_out <= std_logic_vector(tens_seconds_var);
        sig_tens_minutes_out <= std_logic_vector(tens_minutes_var);
        
    end if;
    
end process p_count;

seconds_out <= sig_seconds_out;
minutes_out <= sig_minutes_out;
tens_seconds_out <= sig_tens_seconds_out;
tens_minutes_out <= sig_tens_minutes_out;

end Behavioral;
