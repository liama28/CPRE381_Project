-- tb_fetch_logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a tb for the fetch logic
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_fetch_logic is
  generic(gCLK_HPER   : time := 50 ns);
end tb_fetch_logic;

architecture behavior of tb_fetch_logic is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

component fetch_logic is
  generic(N : integer := 32);
  port(i_jump_amt	: in std_logic_vector(31 downto 0);
       i_rs		: in std_logic_vector(31 downto 0);
       i_imem		: in std_logic_vector(25 downto 0);
       i_jump	 	: in std_logic;  
       i_jr	 	: in std_logic;      
       i_branch        	: in std_logic;
       i_beq		: in std_logic;
       i_bne		: in std_logic;
       i_zero	 	: in std_logic;
       i_CLK		: in std_logic;
       i_RST		: in std_logic;
       o_pc		: out std_logic_vector(31 downto 0);
       o_pc_plus8	: out std_logic_vector(31 downto 0));
end component;

  -- Temporary signals to connect to the decoder component.
  signal s_i_jump_amt  	: std_logic_vector(31 downto 0);
  signal s_i_rs	  	: std_logic_vector(31 downto 0);
  signal s_i_imem 	: std_logic_vector(25 downto 0);
  signal s_i_jump	: std_logic; 
  signal s_i_jr		: std_logic;       
  signal s_i_branch     : std_logic;
  signal s_i_beq	: std_logic;
  signal s_i_bne	: std_logic;
  signal s_i_zero	: std_logic;
  signal s_CLK		: std_logic;
  signal s_RST		: std_logic;
  signal s_o_pc		: std_logic_vector(31 downto 0);
  signal s_o_pc_plus8		: std_logic_vector(31 downto 0);

begin

  DUT: fetch_logic 
  port map(i_jump_amt 		=> s_i_jump_amt, 
           i_rs			=> s_i_rs,
           i_imem		=> s_i_imem,
	   i_jump		=> s_i_jump,
	   i_jr			=> s_i_jr,
	   i_branch 		=> s_i_branch,
	   i_beq 		=> s_i_beq,
	   i_bne		=> s_i_bne,
	   i_zero		=> s_i_zero,
	   i_CLK 		=> s_CLK,
	   i_RST		=> s_RST,
	   o_pc			=> s_o_pc,
	   o_pc_plus8		=> s_o_pc_plus8);

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

  P_RST: process
  begin
  	s_RST <= '0';   
    wait for gCLK_HPER/2;
	s_RST <= '1';
    wait for gCLK_HPER*2;
	s_RST <= '0';
	wait;
  end process;  
  
  -- Testbench process  
  P_TB: process
  begin
    
    wait for gCLK_HPER*2;

    -- initialize PC and let it increment for 3 cycles
    s_i_imem		<= "01010101010101010101010101";
    s_i_rs	 	<= x"77777777";
    s_i_jump 		<= '0';
    s_i_jr 		<= '0';
    s_i_beq 		<= '0';
    s_i_bne 		<= '0';
    s_i_jump_amt 	<= x"FFFFFFFF";
    s_i_branch 		<= '0';
    s_i_zero 		<= '0';
    wait for cCLK_PER;

    wait for cCLK_PER;

    wait for cCLK_PER;

    -- Relative jump to PC+4 + x"33333333" (beq)
    s_i_imem		<= "01010101010101010101010101";
    s_i_rs	 	<= x"77777777";
    s_i_jump 		<= '0';
    s_i_jr 		<= '0';
    s_i_beq 		<= '1';
    s_i_bne 		<= '0';
    s_i_jump_amt 	<= x"33333333"; --become C's when shifted
    s_i_branch 		<= '1';
    s_i_zero 		<= '1';
    wait for cCLK_PER;

    -- Jump
    s_i_imem		<= "01010101010101010101010101"; --bunch of 5's
    s_i_rs	 	<= x"77777777"; -- shouldn't matter
    s_i_jump 		<= '1';
    s_i_jr 		<= '0';
    s_i_beq 		<= '0';
    s_i_bne 		<= '0';
    s_i_jump_amt 	<= x"33333333"; -- shouldn't matter
    s_i_branch 		<= '0'; -- shouldn't matter
    s_i_zero 		<= '0'; -- shouldn't matter
    wait for cCLK_PER;

    -- Jump register
    s_i_imem		<= "01010101010101010101010101";
    s_i_rs	 	<= x"99999999";
    s_i_jump 		<= '1';
    s_i_jr 		<= '1';
    s_i_beq 		<= '0';
    s_i_bne 		<= '0';
    s_i_jump_amt 	<= x"33333333"; -- shouldn't matter
    s_i_branch 		<= '0'; -- shouldn't matter
    s_i_zero 		<= '0'; -- shouldn't matter
    wait for cCLK_PER;

    -- Relative jump to PC+4 + x"00000007" (bne) (+ x20)
    s_i_imem		<= "01010101010101010101010101";
    s_i_rs	 	<= x"77777777";
    s_i_jump 		<= '0';
    s_i_jr 		<= '0';
    s_i_beq 		<= '0';
    s_i_bne 		<= '1';
    s_i_jump_amt 	<= x"00000007";
    s_i_branch 		<= '1';
    s_i_zero 		<= '0';
    wait for cCLK_PER;


    wait;
  end process;
  
end behavior;

-- 0000 0111
-- 0001 1100
