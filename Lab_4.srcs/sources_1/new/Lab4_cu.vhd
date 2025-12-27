library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNIMACRO;							-- This contains links to the Xilinx block RAM
use UNIMACRO.vcomponents.all;

library UNISIM;
use UNISIM.VComponents.all;



entity Lab4_cu is
  Port (clk : in STD_LOGIC;
        reset_n : in STD_LOGIC;
        sw : in std_logic_vector(2 downto 0);
        cw : out std_logic_vector(2 downto 0));
end Lab4_cu;

architecture Behavioral of Lab4_cu is

type state_type is (Reset, Inc_Phase, Wait_phase, Wait_Activity);
signal state, next_state: state_type;

signal Ready : std_logic;
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
	  
	  process(clk, Ready)
	  begin
	  
	   case state is
	   
	       when Reset =>
	           next_state <= Wait_Activity;
	       
	       when Wait_Activity => 
	           if Ready = '1' then
	               next_state <= Inc_Phase;
	           else 
	               next_state <= Wait_Activity;
	           end if;
	           
	       when Inc_Phase => 
                    next_state <= Wait_phase;
              
              
           when Wait_phase => 
	           if Ready = '1' then
	               next_state <= Wait_phase;
	           else 
	               next_state <= Wait_Activity;
	           end if;         
          
                      

	   end case;
	  end process;
	  
	  

	       
cw_in <= "011" when state = Reset else
         "001" when state = Inc_Phase else 
         "000" when state = Wait_Activity else
         "000" when state = Wait_phase else
         "000";
        


cw <= cw_in;

end Behavioral;
