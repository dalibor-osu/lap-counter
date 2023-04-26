----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.04.2023 09:06:49
-- Design Name: 
-- Module Name: top - Behavioral
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

entity top is
Port ( CLK100MHZ : in STD_LOGIC;
       CA   : out STD_LOGIC;
       CB   : out STD_LOGIC;
       CC   : out STD_LOGIC;
       CD   : out STD_LOGIC;
       CE   : out STD_LOGIC;
       CF   : out STD_LOGIC;
       CG   : out STD_LOGIC;
       AN   : out STD_LOGIC_VECTOR (7 downto 0);
       BTNC : in STD_LOGIC;
       SW   : in STD_LOGIC_VECTOR (15 downto 0)
   );
end top;

architecture Behavioral of top is

    signal sig_l_time       : std_logic_vector(7 downto 0);
    signal sig_l_count      : std_logic_vector(3 downto 0);
    signal sig_p_time       : std_logic_vector(3 downto 0);
    signal sig_lap          : std_logic_vector(3 downto 0);

    signal sig_en_1s        : std_logic;
    signal sig_t_en         : std_logic;
    signal sig_t_init       : std_logic_vector(7 downto 0);
    signal sig_t_cnt        : std_logic_vector(7 downto 0);
    signal sig_t_finish     : std_logic;
    signal sig_changed_rst  : std_logic;
    signal sig_state        : std_logic_vector(1 downto 0);
    
begin

  clk_en0 : entity work.clock_enable
    generic map (
      g_MAX => 100000000
    )
    port map (
      clk => CLK100MHZ,
      rst => BTNC,
      ce  => sig_en_1s
    );
    
 cnt_down : entity work.cnt_down
    port map (
      clk => sig_en_1s,
      en => sig_t_en,
      init  => sig_t_init,
      rst => sig_changed_rst,
      cnt => sig_t_cnt,
      finish => sig_t_finish
    );
    
time_ctrl: entity work.time_ctrl
    port map (
      l_time => sig_l_time,
      p_time => sig_p_time,
      state => sig_state,
      t_en => sig_t_en,
      time_out => sig_t_init
    );
    
data_hold: entity work.data_hold
 port map (
    l_time(0) => SW(15),
    l_time(1) => SW(14),
    l_time(2) => SW(13),
    l_time(3) => SW(12),
    l_time(4) => SW(11),
    l_time(5) => SW(10),
    l_time(6) => SW(9),
    l_time(7) => SW(8),
    
    l_count(0) => SW(7),
    l_count(1) => SW(6),
    l_count(2) => SW(5),
    l_count(3) => SW(4),
    
    p_time(0) => SW(3),
    p_time(1) => SW(2),
    p_time(2) => SW(1),
    p_time(3) => SW(0),
    
    state => sig_state,
    l_time_out => sig_l_time,
    l_count_out => sig_l_count,
    p_time_out => sig_p_time
 );
 
 state_ctrl : entity work.state_ctrl
     port map (
        next_s => sig_t_finish,
        l_count => sig_l_count,
        rst => BTNC,
        
        lap => sig_lap,
        state => sig_state,
        changed => sig_changed_rst
     );

driver_lap_break : entity work.driver_7seg_lap_break
    port map (
        clk => CLK100MHZ,
        state => sig_state,
        lap => sig_lap,
        
        seg(6) => CA,
        seg(5) => CB,
        seg(4) => CC,
        seg(3) => CD,
        seg(2) => CE,
        seg(1) => CF,
        seg(0) => CG,
        
        dig(3 downto 0) => AN(7 downto 4)
    );
    
driver_digits : entity work.driver_7seg_4digits
    port map (
        clk => CLK100MHZ,
        cnt => sig_t_cnt,
        
        seg(6) => CA,
        seg(5) => CB,
        seg(4) => CC,
        seg(3) => CD,
        seg(2) => CE,
        seg(1) => CF,
        seg(0) => CG,
        
        dig(3 downto 0) => AN(3 downto 0)
    );

end Behavioral;
