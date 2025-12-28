--------------------------------------------------------------------
-- Name:	Maxwell J. Pembo
-- Date:	1-29-2025
-- File:	addressCntr.vhdl
-- HW:		Lab 2
-- Crs:		CSCE 436
--
-- Counts to 20 to 1023, then rolls over back to 20. 
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
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity addressCntr is
        port(	clk, reset_n: in std_logic; 
                crtl: in std_logic_vector(1 downto 0);
    	        address : out unsigned(9 downto 0));
end addressCntr;

architecture Behavioral of addressCntr is

signal count : unsigned(9 downto 0);
signal D : unsigned(9 downto 0);

begin

D <= "0000010100";
	-----------------------------------------------------------------------------
	--		ctrl
	--		0			hold
	--		1			count up mod 5
	-----------------------------------------------------------------------------   
 
    process(clk)
    begin
    
		if (rising_edge(clk)) then
			if (reset_n = '0') then
				count <= "0000010100";
			elsif (crtl = "01") then
				count <= count + 1;
			elsif (crtl = "10") then
				count <= unsigned(D);
			elsif (crtl = "11") then
				count <= "0000010100";
			end if;
		end if;
	end process;
            
            
address <= count;


end Behavioral;
