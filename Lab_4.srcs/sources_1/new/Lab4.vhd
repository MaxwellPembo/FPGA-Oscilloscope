library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNIMACRO;
use UNIMACRO.vcomponents.all;


entity lab4 is
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
		   slide: in	STD_LOGIC_VECTOR(7 downto 0)
		  -- sw_sim : in STD_LOGIC_VECTOR (2 downto 0)
		   );
end lab4;



architecture behavior of lab4 is


--Init Components 
component Lab4_dp 
    PORT(
         clk : IN  std_logic;
         reset_n : IN  std_logic;
         ac_mclk : out STD_LOGIC;
         ac_adc_sdata : in STD_LOGIC;
         ac_dac_sdata : out STD_LOGIC;
         ac_bclk : out STD_LOGIC;
         ac_lrclk : out STD_LOGIC;
         scl : inout STD_LOGIC;
         sda : inout STD_LOGIC;
         sw : OUT  std_logic_vector(2 downto 0);
         cw : IN  std_logic_vector(2 downto 0);
         btn : IN  std_logic_vector(4 downto 0);
         slide: IN	STD_LOGIC_VECTOR(7 downto 0));
end component;


component Lab4_cu 
  Port (clk : in STD_LOGIC;
        reset_n : in STD_LOGIC;
        sw : in std_logic_vector(2 downto 0);
        cw : out std_logic_vector(2 downto 0));
end component;


	signal sw: std_logic_vector(2 downto 0);
	signal cw: std_logic_vector (2 downto 0) := "000";

	
begin


	datapath: Lab4_dp port map(
		clk => clk,
		reset_n => reset_n,
		ac_mclk => ac_mclk,
		ac_adc_sdata => ac_adc_sdata,
		ac_dac_sdata => ac_dac_sdata,
		ac_bclk => ac_bclk,
		ac_lrclk => ac_lrclk,
        scl => scl,
        sda => sda,
		sw => sw,
		cw => cw,
		btn => btn,
		slide => slide);


	control: lab4_cu port map( 
		clk => clk,
		reset_n => reset_n,
		sw => sw,
		--sw => sw_sim,
		cw => cw);

end behavior;
