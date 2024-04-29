-- tb_decoder_5t32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a tb for a 5:32 decoder
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_decoder_5t32 is
  generic(gCLK_HPER   : time := 50 ns);
end tb_decoder_5t32;

architecture behavior of tb_decoder_5t32 is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component decoder_5t32
    port(i_S	: in std_logic_vector(4 downto 0);
         o_O	: out std_logic_vector(31 downto 0));
  end component;

  -- Temporary signals to connect to the decoder component.
  signal i_Signal : std_logic_vector(4 downto 0);
  signal o_Out    : std_logic_vector(31 downto 0);
  signal s_CLK : std_logic;


begin

  DUT: decoder_5t32 
  port map(i_S 	=> i_Signal, 
           o_O 	=> o_Out);

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
    -- Select bit 0
    i_Signal   <= "00000";
    wait for cCLK_PER;

    -- Select bit 1
    i_Signal   <= "00001";
    wait for cCLK_PER;

    -- Select bit 31
    i_Signal   <= "11111";
    wait for cCLK_PER;

    -- Select bit 30
    i_Signal   <= "11110";
    wait for cCLK_PER;

    -- Select bit 5
    i_Signal   <= "00101";
    wait for cCLK_PER;

    -- Select bit 3
    i_Signal   <= "00011";
    wait for cCLK_PER;

    wait;
  end process;
  
end behavior;