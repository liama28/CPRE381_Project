-------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------
-- tb_ALUControl.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity tb_ALUControl is
	generic(gCLK_HPER	: time := 10 ns);
end tb_ALUControl;

architecture behavior of tb_ALUControl is
	constant cCLK_PER	: time := gCLK_HPER * 2;

component ALUControl
	port(
	i_ALUOp		: in std_logic_vector(2 downto 0);
	i_F		: in std_logic_vector(5 downto 0);
	o_ALUOp		: out std_logic_vector(3 downto 0));
end component;

signal s_i_ALUOp	: std_logic_vector(2 downto 0);
signal s_i_F		: std_logic_vector(5 downto 0);
signal s_o_ALUOp	: std_logic_vector(3 downto 0);

begin
	DUT: ALUControl port map(
	i_ALUOp		=> s_i_ALUOp,
	i_F		=> s_i_F,
	o_ALUOp		=> s_o_ALUOp);

	P_TB: process
	begin

		wait for cCLK_PER;

		-- AND test
		s_i_ALUOp	<= "010";
		s_i_F		<= "100100";
		wait for cCLK_PER;
		-- o_ALUOp = 000x

		-- OR test
		s_i_ALUOp	<= "100";
		s_i_F		<= "100101";
		wait for cCLK_PER;
		-- o_ALUOp = 001x

		-- NOR test
		s_i_ALUOp	<= "111";
		s_i_F		<= "100111";
		wait for cCLK_PER;
		-- o_ALUOp = 010x

		-- XOR test
		s_i_ALUOp	<= "101";
		s_i_F		<= "100110";
		wait for cCLK_PER;
		-- o_ALUOp = 011x

		-- ADD test
		s_i_ALUOp	<= "000";
		s_i_F		<= "100000";
		wait for cCLK_PER;
		-- o_ALUOp = 1000

		-- ADD test 2
		s_i_ALUOp	<= "000";
		s_i_F		<= "100001";
		wait for cCLK_PER;
		-- o_ALUOp = 1000

		-- SUB test
		s_i_ALUOp	<= "001";
		s_i_F		<= "100010";
		wait for cCLK_PER;
		-- o_ALUOp = 1001

		-- SUB test 2
		s_i_ALUOp	<= "001";
		s_i_F		<= "100011";
		wait for cCLK_PER;
		-- o_ALUOp = 1001

		-- SLT test
		s_i_ALUOp	<= "011";
		s_i_F		<= "101010";
		wait for cCLK_PER;
		-- o_ALUOp = 1011

		-- SLL test
		s_i_ALUOp	<= "000";
		s_i_F		<= "000000";
		wait for cCLK_PER;
		-- o_ALUOp = 11xx

		-- SRL test
		s_i_ALUOp	<= "000";
		s_i_F		<= "000010";
		wait for cCLK_PER;
		-- o_ALUOp = 11x0

		-- SRA test
		s_i_ALUOp	<= "000";
		s_i_F		<= "000011";
		wait for cCLK_PER;
		-- o_ALUOp = 11x1
		
		end process;

	end behavior;
