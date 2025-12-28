--------------------------------------------------------------------
-- Name:	Maxwell J. Pembo
-- Date:	1-29-2025
-- File:	Lab2_datapath.vhdl
-- HW:		Lab 2
-- Crs:		CSCE 436
--
-- datapath for project
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
library UNIMACRO;							-- This contains links to the Xilinx block RAM
use UNIMACRO.vcomponents.all;

library UNISIM;
use UNISIM.VComponents.all;

use work.lab2Parts.all;

entity Lab2_datapath is
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
         tmds : OUT  std_logic_vector(3 downto 0);
         tmdsb : OUT  std_logic_vector(3 downto 0);
         sw : OUT  std_logic_vector(2 downto 0);
         cw : IN  std_logic_vector(2 downto 0);
         btn : IN  std_logic_vector(4 downto 0);
         exWrAddr : IN  std_logic_vector(9 downto 0);
         exWen : IN  std_logic;
         exSel : IN  std_logic;
         Lbus_out : OUT  std_logic_vector(15 downto 0);
         Rbus_out : OUT  std_logic_vector(15 downto 0);
         exLbus : IN  std_logic_vector(15 downto 0);
         exRbus : IN  std_logic_vector(15 downto 0);
         flagQ : OUT  std_logic_vector(7 downto 0);
         flagClear : IN  std_logic_vector(7 downto 0);
         ex_trigger_time : IN unsigned(9 downto 0);
         ex_trigger_volt : IN unsigned(9 downto 0);
         ex_ch1_enb : in  std_logic;
         ex_ch2_enb : in  std_logic
         -- SEND THOUGH CHAN1 and CHAN 2 eneb
         
       
        );
        
        

end Lab2_datapath;

architecture Behavioral of Lab2_datapath is


    -- SIGNALS
	signal row, column,trigger_time, trigger_volt: unsigned(9 downto 0);
	signal temp_trigger_time, temp_trigger_volt: unsigned(9 downto 0);
	signal old_button, button_activity: std_logic_vector(4 downto 0);
	signal ch1_wave, ch2_wave: std_logic;
	signal ch1, ch1_enb: std_logic;
	signal ch2, ch2_enb, RamReset: std_logic;
	signal current_state, next_state: std_logic_vector(4 downto 0);
	
    signal ready :  STD_LOGIC;
    signal L_bus_in : std_logic_vector(17 downto 0); -- left channel input to DAC
    signal R_bus_in :  std_logic_vector(17 downto 0); -- right channel input to DAC
    signal L_bus_out  : std_logic_vector(17 downto 0); -- left channel output from ADC
    signal R_bus_out : std_logic_vector(17 downto 0); -- right channel output from ADC

    signal write_cntr, write_address, readL_shiftscale, readR_shiftscale  : unsigned(9 downto 0);
    signal readL_unsigned, L_bus_out_unsigned, L_bus_out_temp, Old_L_bus_out : unsigned(17 downto 0);
    signal readR_unsigned, R_bus_out_unsigned, R_bus_out_temp, Old_R_bus_out : unsigned(17 downto 0);
    signal wrENB, Gthan, Lthan : std_logic;
    signal readL, readR, D_in, D_inRight: std_logic_vector(17 downto 0);
    
    signal flagReg_set : std_logic_vector(7 downto 0);

     signal lEnable, rEnable : std_logic;    
    

begin

    lEnable <= '1' when ex_ch1_enb = '1' else '0';
    rEnable <= '1' when ex_ch2_enb = '1' else '0';

-- COMPONENT INSTANTIATION
	video_inst: video port map( 
		clk => clk,
		reset_n => reset_n,
		tmds => tmds,
		tmdsb => tmdsb,
		trigger_time => trigger_time,
		trigger_volt => trigger_volt,
		row => row, 
		column => column,
		ch1 => ch1,
		ch1_enb => lEnable,
		ch2 => ch2,
		ch2_enb => rEnable); 

    
    Audio_Codec_Wrapper_inst : Audio_Codec_Wrapper Port Map(
        clk => clk,
        reset_n => reset_n,
        ac_mclk => ac_mclk,
        ac_adc_sdata => ac_adc_sdata,
        ac_dac_sdata  => ac_dac_sdata,
        ac_bclk => ac_bclk,
        ac_lrclk => ac_lrclk,
        ready => ready,
        L_bus_in => L_bus_in,
        R_bus_in => R_bus_in,
        L_bus_out => L_bus_out,
        R_bus_out => R_bus_out,
        scl => scl,
        sda => sda
    );
    
    addressCntr_inst : addressCntr Port Map(   
        clk => clk,
        reset_n => reset_n, 
		crtl => cw(1 downto 0), 
		address => write_cntr
	); 
	
	flagRegister_inst : flagRegister Port Map(
	    clk => clk,
        reset_n => reset_n, 
        set => flagReg_set,
        clear =>flagClear,
        Q =>flagQ
	);
	
	flagReg_set(0) <= ready;

    RamReset <= not reset_n;
	sampleMemory: BRAM_SDP_MACRO
		generic map (
			BRAM_SIZE => "18Kb", 					-- Target BRAM, "18Kb" or "36Kb"
			DEVICE => "7SERIES", 					-- Target device: "VIRTEX5", "VIRTEX6", "SPARTAN6, 7SERIES"
			DO_REG => 0, 							-- Optional output register disabled
			INIT => X"000000000000000000",			-- Initial values on output port
			INIT_FILE => "NONE",					-- Not sure how to initialize the RAM from a file
			WRITE_WIDTH => 18, 						-- Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
			READ_WIDTH => 18, 						-- Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
			SIM_COLLISION_CHECK => "NONE", 			-- Collision check enable "ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE"
			SRVAL => X"000000000000000000")			-- Set/Reset value for port output
		port map (
			DO => readL,						-- Output read data port, width defined by READ_WIDTH parameter
			RDADDR => std_logic_vector(column),					-- Input address, width defined by port depth
			RDCLK => clk,	 						-- 1-bit input clock
			RST => RamReset,							-- active high reset
			
			
			RDEN => '1',	
									-- read enable 
			REGCE => '1',							-- 1-bit input read output register enable - ignored
			DI => D_in,						-- Input data port, width defined by WRITE_WIDTH parameter
			WE => "11" ,					-- since RAM is byte read, this determines high or low byte
			WRADDR => std_logic_vector(write_address),					-- Input write address, width defined by write port depth
			WRCLK => clk,							-- 1-bit input write clock
			WREN => wrENB -- CHANGE TO MUX
			);	
			
		RightMemory: BRAM_SDP_MACRO
		generic map (
			BRAM_SIZE => "18Kb", 					-- Target BRAM, "18Kb" or "36Kb"
			DEVICE => "7SERIES", 					-- Target device: "VIRTEX5", "VIRTEX6", "SPARTAN6, 7SERIES"
			DO_REG => 0, 							-- Optional output register disabled
			INIT => X"000000000000000000",			-- Initial values on output port
			INIT_FILE => "NONE",					-- Not sure how to initialize the RAM from a file
			WRITE_WIDTH => 18, 						-- Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
			READ_WIDTH => 18, 						-- Valid values are 1-72 (37-72 only valid when BRAM_SIZE="36Kb")
			SIM_COLLISION_CHECK => "NONE", 			-- Collision check enable "ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE"
			SRVAL => X"000000000000000000")			-- Set/Reset value for port output
		port map (
			DO => readR,						-- Output read data port, width defined by READ_WIDTH parameter
			RDADDR => std_logic_vector(column),					-- Input address, width defined by port depth
			RDCLK => clk,	 						-- 1-bit input clock
			RST => RamReset,							-- active high reset
			
			
			RDEN => '1',							-- read enable 
			
			REGCE => '1',							-- 1-bit input read output register enable - ignored
			DI => D_inright,						-- Input data port, width defined by WRITE_WIDTH parameter
			WE => "11" ,					-- since RAM is byte read, this determines high or low byte
			WRADDR => std_logic_vector(write_address),					-- Input write address, width defined by write port depth
			WRCLK => clk,							-- 1-bit input write clock
			WREN => wrENB -- CHANGE TO MUX
			);	
			
	
    wrENB <= exWen when (exSel = '1') else cw(2);
    
    
    -- WRITE CHAN 1 WHEN DRAM OUT = ROW
    readL_unsigned <= unsigned(readL);
    readL_shiftscale <= readL_unsigned(17 downto 8) - 292;
    ch1 <= '1' when (readL_shiftscale = row) else '0';
    --ch1_enb <= '1' when (ex_ch1_enb = '1') else '0' ; --always enabled for now
    ch1_enb <= '1';
    
    readR_unsigned <= unsigned(readR);
    readR_shiftscale <= readR_unsigned(17 downto 8) - 292;
    ch2 <= '1' when (readR_shiftscale = row) else '0';
    --ch2_enb <= '1' when (ex_ch2_enb = '1') else '0'; --always enabled for now
    ch2_enb <= '1';
    
	------------------------------------------------------------------------------
	-- the variable button_activity will contain a '1' in any position which 
	-- has been pressed or released.  The buttons are all nominally 0
	-- and equal to 1 when pressed.
	------------------------------------------------------------------------------
button_activity <= (old_button XOR btn) and btn;
    
process(clk)
    begin
        if(rising_edge(clk)) then
            if(reset_n='0') then
                old_button <= "00000";
            else
               old_button <= btn;
            end if;
        end if;
end process;

	------------------------------------------------------------------------------
	-- If a button has been pressed then increment of decrement the trigger vars
	------------------------------------------------------------------------------
process(clk)
    begin
        if(rising_edge(clk)) then
        
            if exSel = '1' then
                trigger_volt <= ex_trigger_volt;
                trigger_time <= ex_trigger_time;
            else
            
                if (button_activity(0) = '1') then
                    trigger_volt <= trigger_volt - 10;
                end if;
            
                if (button_activity(2) = '1') then
                    trigger_volt <= trigger_volt + 10;
                end if;
            
                if (button_activity(1) = '1') then
                    trigger_time <= trigger_time - 15;
                end if;
            
                if (button_activity(3) = '1') then
                    trigger_time <= trigger_time + 15;
                end if;
            
                if (button_activity(4) = '1') then
                    trigger_time <= to_unsigned(320, trigger_time'length);
                    trigger_volt <= to_unsigned(220, trigger_volt'length);
                end if;
              end if;
            end if;
end process;    
    
 -- Audio Code Loopback Process:
process (clk)
    begin
	if (rising_edge(clk)) then
	    if reset_n = '0' then
		L_bus_in <= (others => '0');
		R_bus_in <= (others => '0');				
	    elsif(ready = '1') then
		L_bus_in <= L_bus_out;
		R_bus_in <= R_bus_out;

		Old_L_bus_out <= L_bus_out_unsigned;
		Old_R_bus_out <= r_bus_out_unsigned;
		
--		 Lbus_out <= L_bus_out(17 downto 2);
--         Rbus_out  <= r_bus_out(17 downto 2);
         
         Lbus_out <= std_logic_vector(L_bus_out_unsigned(17 downto 2));
		 Rbus_out <= std_logic_vector(r_bus_out_unsigned(17 downto 2));
		
	    end if;
	end if;
end process;

D_in <= (exLBus & "00") when (exSel = '1') else std_logic_vector(L_bus_out_unsigned);
L_bus_out_unsigned <= (unsigned(L_bus_out) + 131072);

D_inRight <= (exRBus & "00") when (exSel = '1') else std_logic_vector(R_bus_out_unsigned);
r_bus_out_unsigned <= (unsigned(R_bus_out) + 131072);

sw(0) <= ready;
sw(1) <= '1' when ((L_bus_out_unsigned(17 downto 8) - 292 > trigger_volt) and (Old_L_bus_out(17 downto 8) - 292 < trigger_volt)) else '0';
sw(2) <= '1' when (write_cntr = 1023) else '0';

write_address <= unsigned(exWrAddr) when (exSel ='1') else write_cntr;

---- LAB 3 CODE ----


end Behavioral;
