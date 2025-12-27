--------------------------------------------------------------------
-- Name:	Maxwell J. Pembo
-- Date:	4-6-2025
-- File:	Lab4_tb.vhdl
-- HW:		Lab 2
-- Crs:		CSCE 436
--
-- Control Unit for project
--
-- Academic Integrity Statement: I certify that, while others may have 
-- assisted me in brain storming, debugging and validating this program, 
-- the program itself is my own work. I understand that submitting code 
-- which is the work of other individuals is a violation of the honor   
-- code.  I also understand that if I knowingly give my original work to 
-- another individual is also a violation of the honor code. 
------------------------------------------------------------------------- 


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Lab4_tb is
end Lab4_tb;

architecture Behavioral of Lab4_tb is
component lab4 
    Port ( clk : in  STD_LOGIC;
           reset_n : in  STD_LOGIC;
		   ac_mclk : out STD_LOGIC;
		   ac_adc_sdata : in STD_LOGIC;
		   ac_dac_sdata : out STD_LOGIC;
		   ac_bclk : out STD_LOGIC;
		   ac_lrclk : out STD_LOGIC;
           scl : inout STD_LOGIC;
           sda : inout STD_LOGIC;
		   btn: in	STD_LOGIC_VECTOR(4 downto 0);
		   slide: in	STD_LOGIC_VECTOR(7 downto 0);
		   sw_sim : in STD_LOGIC_VECTOR (2 downto 0));
end component;

-- Signal declarations for the testbench
signal clk : std_logic;
signal reset_n : std_logic;
signal sw : std_logic_vector(2 downto 0);
signal sw_sim : std_logic_vector(2 downto 0);
signal cw : std_logic_vector(2 downto 0);
signal ready : std_logic;
signal slide : std_logic_vector(7 downto 0) := (others => '0');
signal btn : std_logic_vector(4 downto 0) := (others => '0');
 signal BIT_CLK : std_logic := '0';

   signal ac_mclk : std_logic;
   signal ac_dac_sdata : std_logic;
   signal ac_bclk : std_logic;
   signal ac_lrclk : std_logic;
   signal scl : std_logic;
   signal ac_adc_sdata : std_logic := '0';
   signal sda : std_logic := '0';


constant clk_period : time := 500 ns;  -- Sets clock to ~100 MHz


begin

 clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
     

 uut : Lab4
    Port map (
		clk => clk,
		reset_n => reset_n,
		ac_mclk => ac_mclk,
		ac_adc_sdata => ac_adc_sdata,
		ac_dac_sdata => ac_dac_sdata,
		ac_bclk => ac_bclk,
		ac_lrclk => ac_lrclk,
        scl => scl,
        sda => sda,
		btn => btn,
		slide => slide,
		sw_sim => sw_sim);  




		reset_n <= '0', '1' after 1 us;
		sw_sim <= "000", "001" after 5us, "000" after 6 us, "001" after 10 us, "000" after 11 us;
		
        slide <= x"01", x"02" after 5 us, x"0A" after 6 us,  x"0F" after 10 us	;
        
        btn <= "00000", "00001" after 5 us, "00000" after 6 us, 
                        "00010" after 7 us, "00000" after 8 us,
                        "00100" after 9 us, "00000" after 10 us,
                        "01000" after 11 us, "00000" after 12 us;


end Behavioral;
