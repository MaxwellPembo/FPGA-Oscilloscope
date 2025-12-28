--------------------------------------------------------------------
-- Name:	Maxwell J. Pembo
-- Date:	1-29-2025
-- File:	vga.vhdl
-- HW:		Lab 1
-- Crs:		CSCE 436
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity vga is
	Port(	clk: in  STD_LOGIC;
			reset_n : in  STD_LOGIC;
			h_sync : out  STD_LOGIC;
			v_sync : out  STD_LOGIC; 
			blank : out  STD_LOGIC;
			r: out STD_LOGIC_VECTOR(7 downto 0);
			g: out STD_LOGIC_VECTOR(7 downto 0);
			b: out STD_LOGIC_VECTOR(7 downto 0);
			trigger_time: in unsigned(9 downto 0);
			trigger_volt: in unsigned (9 downto 0);
			row: out unsigned(9 downto 0);
			column: out unsigned(9 downto 0);
			ch1: in std_logic;
			ch1_enb: in std_logic;
			ch2: in std_logic;
			ch2_enb: in std_logic);
end vga;

architecture Behavior of vga is

component h_counter is
        port(	clk, reset_n: in std_logic; 
		ctrl: in std_logic;
		roll : out std_logic;
		columns : out unsigned(9 downto 0));
end component;


component v_counter is
        port(	clk, reset_n: in std_logic; 
		ctrl: in std_logic;
		roll : out std_logic;
		rows : out unsigned(9 downto 0));
end component;

component ScopeFace is
   Port ( row : in  unsigned(9 downto 0);
           column : in  unsigned(9 downto 0);
		   trigger_volt: in unsigned (9 downto 0);
		   trigger_time: in unsigned (9 downto 0);
           r : out  std_logic_vector(7 downto 0);
           g : out  std_logic_vector(7 downto 0);
           b : out  std_logic_vector(7 downto 0);
		   ch1: in std_logic;
	       ch1_enb: in std_logic;
		   ch2: in std_logic;
	       ch2_enb: in std_logic);
end component;




signal rollover : std_logic:= '0';
signal nullover : std_logic:= '0';
signal counter2reset : std_logic := '0';
signal rowcount, columncount : unsigned(9 downto 0);

begin 

counter2reset <= reset_n;

inst_h_counter : h_counter port map(
    clk => clk,
    reset_n  => reset_n,
    ctrl => '1',
	roll => rollover,
	columns => columncount
);


inst_v_counter : v_counter port map(
    clk => clk,
    reset_n  => reset_n,
    ctrl => rollover,
	roll => nullover,
	rows => rowcount
);

inst_scopeFace : scopeFace port map(
     row => rowcount,
     column => columncount,
	 trigger_volt => trigger_volt,
	 trigger_time => trigger_time,
     r => r,
     g => g,
     b => b,
	 ch1 => ch1,
	 ch1_enb => ch1_enb,
     ch2 => ch2,
	 ch2_enb => ch2_enb
);

row <= rowcount;
column <= columncount;

h_sync <= '1' when ((columncount >= 0) and (columncount < 655)) or ((columncount >= 751) and (columncount <= 799))
              else '0'; 


v_sync <= '1' when ((rowcount >= 0) and (rowcount < 489)) or ((rowcount >= 491) and (rowcount <= 524))
              else '0'; 

blank <= '0' when ((columncount >= 0) and (columncount < 639)) and ((rowcount >= 0) and (rowcount < 479))
             else '1'; 

end behavior;
