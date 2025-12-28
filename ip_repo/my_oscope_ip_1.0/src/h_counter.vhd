--------------------------------------------------------------------
-- Name:	Maxwell J. Pembo
-- Date:	1-29-2025
-- File:	h_counter.vhdl
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
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity h_counter is
        port(	clk, reset_n: in std_logic; 
		ctrl: in std_logic;
		roll : out std_logic;
		columns : out unsigned(9 downto 0));
end h_counter;

architecture Behavioral of h_counter is

signal count : unsigned(9 downto 0);
signal rollover : std_logic := '0';

begin

	-----------------------------------------------------------------------------
	--		ctrl
	--		0			hold
	--		1			count up mod 5
	-----------------------------------------------------------------------------   
 
    process(clk)
    begin
    
        if (rising_edge(clk)) then
        
            if reset_n = '0' then
                count <= (others => '0');

                
            elsif (count < 799) then
                count <= count + 1;

             
            elsif (count = 799) then
                count <= (others => '0');              
                             
            end if;
       end if;
    end process;


roll <= '1' when (count = 799) else '0';
columns <= count;


end Behavioral;
