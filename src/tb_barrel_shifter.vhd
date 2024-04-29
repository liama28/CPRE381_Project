-- tb_barrel_shifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a tb for a barrel shifter
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_barrel_shifter is
  generic(gCLK_HPER   : time := 50 ns);
end tb_barrel_shifter;

architecture behavior of tb_barrel_shifter is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component barrel_shifter is
    port(i_data      		: in std_logic_vector(31 downto 0);
         shift_amt		: in std_logic_vector(4 downto 0);
         go_left		: in std_logic;
	 shift_arithmetic	: in std_logic;
         o_data   		: out std_logic_vector(31 downto 0));

  end component;

  -- Temporary signals to connect to the decoder component.
  signal s_i_data    	: std_logic_vector(31 downto 0);
  signal s_amount 	: std_logic_vector(4 downto 0);
  signal s_o_data 	: std_logic_vector(31 downto 0);
  signal s_left 	: std_logic;
  signal s_CLK 		: std_logic;
  signal s_arithmetic	: std_logic;

begin

  DUT: barrel_shifter 
  port map(i_data 	=> s_i_data, 
           shift_amt	=> s_amount,
	   go_left	=> s_left,
	   shift_arithmetic => s_arithmetic,
	   o_data	=> s_o_data);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin
    
    s_left <= '0';
    s_arithmetic <= '0';
    s_i_data <= x"FFFFFFFF";

    -- Set bits
    s_amount <= "11000";
    wait for cCLK_PER;

    s_amount <= "10000";
    wait for cCLK_PER;

    s_amount <= "01000";
    wait for cCLK_PER;

    s_amount <= "00000";
    wait for cCLK_PER;

    s_amount <= "00100";
    wait for cCLK_PER;

    s_amount <= "00010";
    wait for cCLK_PER;

    s_amount <= "00001";
    wait for cCLK_PER;

    s_amount <= "00101";
    wait for cCLK_PER;

    s_amount <= "11111";
    wait for cCLK_PER;


    s_left <= '1';
    s_arithmetic <= '1';
    s_i_data <= x"FFAAFFFF";
    s_amount <= "00100";
    wait for cCLK_PER;

    s_left <= '1';
    s_arithmetic <= '1';
    s_i_data <= x"7FAAFFFF";
    s_amount <= "00100";
    wait for cCLK_PER;

    s_amount <= "00101";
    wait for cCLK_PER;

    s_amount <= "11000";
    wait for cCLK_PER;

    s_amount <= "11111";
    wait for cCLK_PER;


    wait;
  end process;
  
end behavior;