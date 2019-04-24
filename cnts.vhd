--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Tomas Fryza (tomas.fryza@vut.cz)
-- Date: 2019-02-28 10:52
-- Design: top
-- Description: Implementation of Up Down BCD counter.
--------------------------------------------------------------------------------
-- TODO: Verify BCD counter on Coolrunner-II board. Use seven-segment LED
--       display and on-board clock signal with frequency of 10 kHz.
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
-- Entity declaration for top level
--------------------------------------------------------------------------------
entity cnts is
    port (
        clk_i : in std_logic;   
		  enable_1_i : in std_logic;
		  enable_0_i : in std_logic;
		  c_i : in std_logic;
		  
		  cnt_0_o : out std_logic_vector(16-1 downto 0);
		  cnt_1_o : out std_logic_vector(4-1 downto 0)
    );
end cnts;

--------------------------------------------------------------------------------
-- Architecture declaration for top level
--------------------------------------------------------------------------------
architecture Behavioral of cnts is
begin
	
	 BINCNT_0 : entity work.bin_cnt
        generic map (
			   N_BIT => 16)
        port map (
            clk_i => clk_i,
            rst_n_i => enable_0_i,
            bin_cnt_o => cnt_0_o,
				c_i => c_i
        );
		  
	 BINCNT_1 : entity work.bin_cnt
        generic map (
			   N_BIT => 4)
        port map (
            clk_i => clk_i,
            rst_n_i => enable_1_i,
            bin_cnt_o => cnt_1_o,
				c_i => '1'
        );
end Behavioral;
