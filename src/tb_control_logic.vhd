-- tb_control_logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a tb for the control logic
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_control_logic is
  generic(gCLK_HPER   : time := 50 ns);
end tb_control_logic;

architecture behavior of tb_control_logic is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;

  component control_logic is
	port 
	(
		instruction     : in std_logic_vector(31 downto 0);
		RegDst		: out std_logic;
		Jump		: out std_logic;
		MemtoReg	: out std_logic;
		MemWr		: out std_logic;
		bne		: out std_logic;
		beq		: out std_logic;
		o_Op		: out std_logic_vector(3 downto 0);
		ALUSrc		: out std_logic;
		RegWr		: out std_logic;
		o_sign		: out std_logic;
		jal		: out std_logic;
		jr		: out std_logic;
		Halt		: out std_logic;
		lui		: out std_logic;
		shift		: out std_logic
	);

  end component;

  -- Temporary signals to connect to the decoder component.
  signal s_instruction  	: std_logic_vector(31 downto 0);
  signal s_RegDst		: std_logic; 
  signal s_Jump		: std_logic;       
  signal s_MemtoReg       : std_logic;
  signal s_MemWr		: std_logic;
  signal s_bne		: std_logic;
  signal s_beq		: std_logic;
  signal s_o_Op		: std_logic_vector(3 downto 0);
  signal s_ALUSrc		: std_logic;
  signal s_RegWr		: std_logic;
  signal s_o_sign		: std_logic;
  signal s_jal		: std_logic;
  signal s_jr		: std_logic;
  signal s_Halt		: std_logic;
  signal s_lui		: std_logic;
  signal s_shift		: std_logic;
  signal s_CLK 		: std_logic;

begin

  DUT: control_logic 
  port map(instruction 		=> s_instruction, 
           RegDst		=> s_RegDst,
           Jump			=> s_Jump,
	   MemtoReg		=> s_MemtoReg,
	   MemWr		=> s_MemWr,
	   bne 			=> s_bne,
	   beq 			=> s_beq,
	   o_Op			=> s_o_Op,
	   ALUSrc		=> s_ALUSrc,
	   RegWr 		=> s_RegWr,
	   o_sign		=> s_o_sign,
	   jal			=> s_jal,
	   jr			=> s_jr,
	   Halt 		=> s_Halt,
	   lui			=> s_lui,
	   shift		=> s_shift);

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
    
    -- R formats
    wait for gCLK_HPER*2; --add
    s_instruction	<= "000000" & "00000000000000000000" & "100000";

    wait for gCLK_HPER*2; --addu
    s_instruction	<= "000000" & "00000000000000000000" & "100001";

    wait for gCLK_HPER*2; --sub
    s_instruction	<= "000000" & "00000000000000000000" & "100010";

    wait for gCLK_HPER*2; --subu
    s_instruction	<= "000000" & "00000000000000000000" & "100011";

    wait for gCLK_HPER*2; --and
    s_instruction	<= "000000" & "00000000000000000000" & "100100";

    wait for gCLK_HPER*2; --nor
    s_instruction	<= "000000" & "00000000000000000000" & "100111";

    wait for gCLK_HPER*2; --xor
    s_instruction	<= "000000" & "00000000000000000000" & "100110";

    wait for gCLK_HPER*2; --or
    s_instruction	<= "000000" & "00000000000000000000" & "100101";

    wait for gCLK_HPER*2; --slt
    s_instruction	<= "000000" & "00000000000000000000" & "101010";

    wait for gCLK_HPER*2; --sll
    s_instruction	<= "000000" & "00000000000000000000" & "000000";

    wait for gCLK_HPER*2; --sra
    s_instruction	<= "000000" & "00000000000000000000" & "000011";

    wait for gCLK_HPER*2; --srl
    s_instruction	<= "000000" & "00000000000000000000" & "000010";

    wait for gCLK_HPER*2; --jr
    s_instruction	<= "000000" & "00000000000000000000" & "001000";

    -- I & J formats
    wait for gCLK_HPER*2; -- J
    s_instruction	<= "000010" & "00000000000000000000" & "000000";

    wait for gCLK_HPER*2; -- Jal
    s_instruction	<= "000011" & "00000000000000000000" & "000000";

    wait for gCLK_HPER*2; -- Addi
    s_instruction	<= "001000" & "00000000000000000000" & "000000";

    wait for gCLK_HPER*2; -- Addiu
    s_instruction	<= "001001" & "00000000000000000000" & "000000";

    wait for gCLK_HPER*2; -- Andi
    s_instruction	<= "001100" & "00000000000000000000" & "000000";

    wait for gCLK_HPER*2; -- Lui
    s_instruction	<= "001111" & "00000000000000000000" & "000000";

    wait for gCLK_HPER*2; -- LW
    s_instruction	<= "100011" & "00000000000000000000" & "000000";

    wait for gCLK_HPER*2; -- Xori
    s_instruction	<= "001110" & "00000000000000000000" & "000000";

    wait for gCLK_HPER*2; -- Ori
    s_instruction	<= "001101" & "00000000000000000000" & "000000";

    wait for gCLK_HPER*2; -- SLTI
    s_instruction	<= "001010" & "00000000000000000000" & "000000";

    wait for gCLK_HPER*2; -- SW
    s_instruction	<= "101011" & "00000000000000000000" & "000000";

    wait for gCLK_HPER*2; -- BEQ
    s_instruction	<= "000100" & "00000000000000000000" & "000000";

    wait for gCLK_HPER*2; -- BNE
    s_instruction	<= "000101" & "00000000000000000000" & "000000";

    wait for gCLK_HPER*2; -- HALT
    s_instruction	<= "010100" & "00000000000000000000" & "000000";


    wait for cCLK_PER*2;


    wait;
  end process;
  
end behavior;