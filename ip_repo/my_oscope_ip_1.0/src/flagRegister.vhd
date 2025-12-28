--------------------------------------------------------------------
-- Name:	Maxwell J. Pembo
-- Date:	1-29-2025
-- File:	flagRegister.vhdl
-- HW:		Lab 2
-- Crs:		CSCE 436
--
-- 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity flagRegister is
	Generic (N: integer := 8);
	Port(	clk: in  STD_LOGIC;
			reset_n : in  STD_LOGIC;
			set, clear: in std_logic_vector(N-1 downto 0);
			Q: out std_logic_vector(N-1 downto 0));
end flagRegister;


architecture Behavioral of flagRegister is

signal process_Q : std_logic_vector(N-1 downto 0);

begin

process(clk)    
begin
    if (rising_edge(clk)) then
    if (reset_n = '0') then
        process_Q <= (others => '0');
    else
        process_Q <= (process_Q OR set) AND (NOT clear);
    end if;
    end if;
end process;


Q <= process_Q;
end Behavioral;

