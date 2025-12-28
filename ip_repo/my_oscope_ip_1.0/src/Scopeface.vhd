--------------------------------------------------------------------
-- Name:	Maxwell J. Pembo
-- Date:	1-29-2025
-- File:	Scopeface.vhdl
-- HW:		Lab 1
-- Crs:		CSCE 436
--------------------------------------------------------------------------- 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity scopeFace is
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
end scopeFace;

architecture Bahavioral of scopeface is

signal ch1_trace : std_logic:= '0';
signal ch2_trace : std_logic:= '0';
signal grid : std_logic:= '0';

signal volt, tim : std_logic:= '0';


Begin

grid <= '1' when ( 
    ((row = 20 or row = 120 or row = 170 or row = 220
    or row = 270 or row = 320 or row = 370 or row = 420 or row = 70) -- Regular Rows
    or 
    (column = 20 or column = 80 or column = 140 or column = 200
    or column = 260 or column = 320 or column = 380 or column = 440
    or column = 500 or column = 560 or column = 620) -- Regular columns

    or ((column >= 315 and column <= 325) and ((row - 20) mod 10 = 0)) -- Dashes
    or ((row >= 210 and row <= 230) and ((column - 20) mod 10 = 0)))
    
    and  (row >= 20 and row <= 420) and 
        (column >= 20 and column <= 620) -- bounds
        
) else '0';


volt <= '1' when (((row = trigger_volt ) 
    
    --trigger marks 
    or ((column = 21) and (row <= trigger_volt + 4) and (row >= trigger_volt - 4))
    or ((column = 22) and (row <= trigger_volt + 3) and (row >= trigger_volt - 3))
    or ((column = 23) and (row <= trigger_volt + 2) and (row >= trigger_volt - 2))
    or ((column = 24) and (row <= trigger_volt + 1) and (row >= trigger_volt - 1)))


    and  (row >= 20 and row <= 420)
    and (column >= 20 and column <= 620))
        
        
         else '0';
         
tim <= '1' when (((column = trigger_time)
      --trigger marks 
    or ((row = 21) and (column <= trigger_time + 4) and (column >= trigger_time - 4))
    or ((row = 22) and (column <= trigger_time + 3) and (column >= trigger_time - 3))
    or ((row = 23) and (column <= trigger_time + 2) and (column >= trigger_time - 2))
    or ((row = 24) and (column <= trigger_time + 1) and (column >= trigger_time - 1)))

    and  (row >= 20 and row <= 420) 
    and (column >= 20 and column <= 620)) else '0';


ch1_trace <= '1' when (ch1 = '1' and ch1_enb = '1')     and  (row >= 20 and row <= 420) and 
        (column >= 20 and column <= 620)   else '0';
ch2_trace <= '1' when (ch2 = '1' and ch2_enb = '1') and  (row >= 20 and row <= 420) and 
        (column >= 20 and column <= 620)  else '0';
        
        
        

r <= x"FF" when ((grid = '1') or (ch1_trace = '1') or (volt = '1')) else x"00";
g <= x"FF" when ((grid = '1') or (ch1_trace = '1')or (ch2_trace = '1')) else x"00";
b <= x"FF" when (grid = '1') or (tim = '1') else x"00";




end Bahavioral;

