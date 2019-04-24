--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Frantisek Langr, Vojtech Herbrych
-- Date: 2019-04-03 13:45
-- Design: Measure
-- Description: Distance measurement with ultrasonic sensor
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

--------------------------------------------------------------------------------
-- Entity declaration for distance measurement
--------------------------------------------------------------------------------
entity top is 
	port(
		-- Entity input/output signals
		btn_i : in std_logic;
		clk_i : in std_logic;
		ultra_son_i : in std_logic; -- echo signal
		
		disp_sseg_o : out std_logic_vector(7-1 downto 0);
		disp_digit_o : out std_logic_vector(4-1 downto 0);
		ultra_son_o : out std_logic -- trigger signal
	);
end top; 
--------------------------------------------------------------------------------
-- Architecture declaration 
--------------------------------------------------------------------------------
architecture Behavioral of top is 
	 signal s_mod_num : std_logic_vector(16-1 downto 0);
	 signal s_bcd : std_logic_vector(16-1 downto 0);
	 signal s_cnt_0 : std_logic_vector(16-1 downto 0);
	 signal s_cnt_1 : std_logic_vector(4-1 downto 0); -- value of 4-bit binary adder
	 signal s_cnt_0_en : std_logic; -- enable for binary adder (echo signal)
	 signal s_bin2bcd_rst : std_logic; -- reset for BIN2BCD converter
	 signal s_cnt_0_rst : std_logic;
	 signal s_cnt_1_rst : std_logic;
	 begin
		meas : entity work.meas
			port map (
				clk_i => clk_i,
				echo_i => ultra_son_i,
				btn_i => btn_i,
				cnt_0_i => s_cnt_0,
				cnt_1_i => s_cnt_1,	
				trig_o => ultra_son_o,
				cnt_0_en_o => s_cnt_0_en,
				cnt_0_rst_o => s_cnt_0_rst,
				cnt_1_rst_o => s_cnt_1_rst,
				mod_num_o => s_mod_num,
				bin2bcd_rst_o => s_bin2bcd_rst
			);
		binary_bcd : entity work.binary_bcd
			port map (
				clk => clk_i,
			   reset => s_bin2bcd_rst,
				binary_in => s_mod_num,
				bcd3 => s_bcd(16-1 downto 12),
				bcd2 => s_bcd(12-1 downto 8),
				bcd1 => s_bcd(8-1 downto 4), 
				bcd0 => s_bcd(4-1 downto 0)
			);
		cnts : entity work.cnts
			port map (
				clk_i => clk_i,
				enable_0_i => s_cnt_0_rst,
				enable_1_i => s_cnt_1_rst,
				c_i => s_cnt_0_en,	
		      cnt_0_o => s_cnt_0,
				cnt_1_o => s_cnt_1
			);
		disp_mux : entity work.disp_mux
			port map (
				clk_i => clk_i,  				
				data3_i => s_bcd(16-1 downto 12),
				data2_i => s_bcd(12-1 downto 8), 
				data1_i => s_bcd(8-1 downto 4), 
				data0_i => s_bcd(4-1 downto 0),
				an_o => disp_digit_o,    -- 1-of-4 decoder
				sseg_o => disp_sseg_o    -- 7-segment display
			);
end Behavioral;
