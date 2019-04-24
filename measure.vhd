--------------------------------------------------------------------------------
-- Brno University of Technology, Department of Radio Electronics
--------------------------------------------------------------------------------
-- Author: Frantisek Langr, Vojtech Herbrych
-- Date: 2019-04-03 13:45
-- Design: Measure
-- Description: Distance measurement with ultrasonic sensor
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--------------------------------------------------------------------------------
-- Entity declaration for distance measurement
--------------------------------------------------------------------------------
entity meas is 
	port( 
		-- Entity input/output signals
		clk_i : in std_logic;
		echo_i : in std_logic;
		btn_i : in std_logic;
		cnt_0_i : in std_logic_vector(16-1 downto 0);
		cnt_1_i : in std_logic_vector(4-1 downto 0);
		
		trig_o : out std_logic := '0';
		cnt_0_en_o : out std_logic; 
		cnt_0_rst_o : out std_logic;
		cnt_1_rst_o : out std_logic :='0';
		mod_num_o : out std_logic_vector(16-1 downto 0);
		bin2bcd_rst_o : out std_logic	
	);
end meas;
--------------------------------------------------------------------------------
-- Architecture declaration
--------------------------------------------------------------------------------
architecture Behavioral of meas is 
	signal s_impulse : unsigned(16-1 downto 0) := (others => '0');
	signal s_echo_i_delay_r : std_logic := '0';
	signal s_echo_i_delay_f : std_logic := '0';
	signal s_btn_i_delay_r : std_logic := '0';
	signal s_btn_i_delay_f : std_logic := '0';
begin 
	-- Rising edge - echo_i
	process(clk_i) begin
		if rising_edge(clk_i) then
			s_echo_i_delay_r <= echo_i;
			if s_echo_i_delay_r = '0' and echo_i = '1' then
				cnt_0_rst_o <= '1';
				cnt_0_en_o <= '1';
			end if;
	-- Falling edge - echo_i
			s_echo_i_delay_f <= echo_i;
			if s_echo_i_delay_f = '1' and echo_i = '0' then
				cnt_0_en_o <= '0';
			end if;
   -- Falling edge - btn_i
			s_btn_i_delay_r <= btn_i;
			if s_btn_i_delay_r = '1' and btn_i = '0' then
				trig_o <= '1';
				cnt_1_rst_o <= '1';
				bin2bcd_rst_o <= '0';
			end if;
	-- Rising edge - btn_i
			s_btn_i_delay_f <= btn_i;
			if s_btn_i_delay_f = '0' and btn_i = '1' then
				s_impulse <= shift_right(unsigned(cnt_0_i),6);
				mod_num_o <= std_logic_vector(s_impulse);
				bin2bcd_rst_o <= '1';
				cnt_0_rst_o <= '0';
			end if;
			if cnt_1_i = "1010" then -- waiting 
				trig_o <= '0';
				cnt_1_rst_o <= '0';
			end if;
		end if;
  end process;
end Behavioral;