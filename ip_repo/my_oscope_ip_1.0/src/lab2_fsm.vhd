--------------------------------------------------------------------
-- Name:	Maxwell J. Pembo
-- Date:	1-29-2025
-- File:	Lab2_fsm.vhdl
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lab2_fsm is
  Port (clk : in STD_LOGIC;
        reset_n : in STD_LOGIC;
        sw : in std_logic_vector(2 downto 0);
        cw : out std_logic_vector(2 downto 0));
end lab2_fsm;

architecture Behavioral of lab2_fsm is

type state_type is (Reset, WaitTrigger, StoreValue, WaitValue);
signal state, next_state: state_type;

signal Ready, Trigger, Max_Count : std_logic;
signal cw_in : std_logic_vector(2 downto 0);


begin


	process(clk)
	begin
	       if (reset_n = '0') then
	           state <= Reset;
	       elsif rising_edge(clk) then
	           state <= next_state;
	       end if;
	  end process;
	  
	  
Ready <= sw(0);
Trigger <= sw(1);
Max_Count <= sw(2);

	  
	  process(clk, Ready, Trigger, Max_Count )
	  begin
	  
	   case state is
	   
	       when Reset =>
	           next_state <= WaitTrigger;
	       
	       when WaitTrigger => 
	           if Trigger = '1' then
	               next_state <= StoreValue;
	           else 
	               next_state <= WaitTrigger;
	           end if;
	           
	       when StoreValue => 
                    next_state <= WaitValue;
                    
           when WaitValue => 
	           if Ready = '1' then
	               next_state <= StoreValue;
	           elsif (Max_Count = '1') and (Ready = '0') then
	               next_state <= Reset;
	           else 
	               next_state <= WaitValue;
	           end if;	   
	
	   end case;
	  end process;
	  
	  

	       
cw_in <= "011" when state = Reset else
         "000" when state = WaitTrigger else 
         "101" when state = StoreValue else
         "000" when state = WaitValue;
        


cw <= cw_in;

end Behavioral;
