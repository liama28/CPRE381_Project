-------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------
-- tb_ALU.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity tb_ALU is
	generic(gCLK_HPER	: time := 10 ns);
end tb_ALU;

architecture behavior of tb_ALU is
	constant cCLK_PER	: time := gCLK_HPER * 2;

component ALU
	port(
	i_A		: in std_logic_vector(31 downto 0);	-- 32-Bit operand A
       	i_B		: in std_logic_vector(31 downto 0);	-- 32-Bit operand B
       	i_ALUOP		: in std_logic_vector(3 downto 0);	-- 4-Bit ALU Operation Code 
       	o_F		: out std_logic_vector(31 downto 0);	-- 32-Bit Result ouput
       	o_CO		: out std_logic;			-- Carryout output
	o_OF		: out std_logic;			-- Overflow output
	o_Zero		: out std_logic);
end component;

signal s_i_A, s_i_B, s_o_F	: std_logic_vector(31 downto 0) := x"00000000";
signal s_i_ALUOP		: std_logic_vector(3 downto 0) := "0000";
signal s_o_CO, s_o_OF, s_o_Zero	: std_logic := '0';

begin
	DUT: ALU port map(
	i_A	=> s_i_A,
	i_B	=> s_i_B,
	i_ALUOP	=> s_i_ALUOP,
	o_F	=> s_o_F,
	o_CO	=> s_o_CO,
	o_OF	=> s_o_OF,
	o_Zero	=> s_o_Zero);

P_TB: process
begin
	
	wait for cCLK_PER;

	-- Add (1000) 0 (0x00000000) + (0x0FFFFFFF)		
	s_i_ALUOP	<= "1000";
	s_i_A		<= x"00000000";
	s_i_B		<= x"0FFFFFFF";
	-- Expecting o_F = 0x0FFFFFFF, o_CO = 0, o_OF = 0, and o_Zero = 0
	wait for cCLK_PER;

	-- Add (1000) 200 (0x00000000) + 500 (0x0FFFFFFF)		
	s_i_ALUOP	<= "1000";
	s_i_A		<= x"000000C8";
	s_i_B		<= x"000001F4";
	-- Expecting o_F = 0x000002BC, o_CO = 0, o_OF = 0, and o_Zero = 0
	wait for cCLK_PER;

	-- Add (1000) (0x7FFFFFFF) + (0x00000001)		
	s_i_ALUOP	<= "1000";
	s_i_A		<= x"7FFFFFFF";
	s_i_B		<= x"00000001";
	-- Expecting o_F = 0x80000000, o_CO = 0, o_OF = 1, and o_Zero = 0
	wait for cCLK_PER;

	-- Add (1000) (0xFFFFFFFF) + (0x00000001)		
	s_i_ALUOP	<= "1000";
	s_i_A		<= x"FFFFFFFF";
	s_i_B		<= x"00000001";
	-- Expecting o_F = 0x00000000, o_CO = 1, o_OF = 1, and o_Zero = 0
	wait for cCLK_PER;

	-- AND (000x) (0xF030FFFF) & (0x3FCF0F0F)
	s_i_ALUOP	<= "0001";
	s_i_A		<= x"F030FFFF";
	s_i_B		<= x"3FCF0F0F";
	-- Expected o_F = 0x30000F0F
	wait for cCLK_PER;

	-- OR (001x) (0xF030FFFF) | (0x3FCF0F0F)
	s_i_ALUOP	<= "0011";
	-- Expected o_F = 0xFFFFFFFF
	wait for cCLK_PER;

	-- NOR (001x) (0xF030FFFF) !| (0x3FCF0F0F)
	s_i_ALUOP	<= "0101";
	wait for cCLK_PER;

	-- OR (001x) (0x0C003330) | (0x003A000D)
	s_i_ALUOP	<= "0011";
	s_i_A		<= x"0C003330";
	s_i_B		<= x"003A000D";
	-- Expected o_F = 0x0c3A333D
	wait for cCLK_PER;

	-- XOR (0111) (0xF00FA22A) xor (0xF0F0A2A2)
	s_i_ALUOP	<= "0111";
	s_i_A		<= x"F00FA22A";
	s_i_B		<= x"F0F0A2A2";
	-- Expected o_F = 0x00FF0088
	wait for cCLK_PER;

	-- SUB (1001) (0x00000001) - (0xFFFFFFFF)
	s_i_ALUOP	<= "1001";
	s_i_A		<= x"00000001";
	s_i_B		<= x"FFFFFFFF";
	-- Expected o_F = 0x00000002
	wait for cCLK_PER;

	-- SUB (1001) (0x0000000A) - (0x0000000A)
	s_i_ALUOP	<= "1001";
	s_i_A		<= x"0000000A";
	s_i_B		<= x"0000000A";
	-- Expected o_F = 0x00000000
	wait for cCLK_PER;

	-- SUB (1001) (0x80000000) - (0x0000000F)
	s_i_ALUOP	<= "1001";
	s_i_A		<= x"80000000";
	s_i_B		<= x"0000000F";
	-- Expected o_F = 0x, o_OF = 1
	wait for cCLK_PER;

	-- SLT (1011) 0x0000000A < 0x00000000
	s_i_ALUOP	<= "1011";
	s_i_A		<= x"0000000A";
	s_i_B		<= x"00000000";
	-- Expected o_F = 0x00000000, o_Zero = 1
	wait for cCLK_PER;


	-- SLT (1011) 0x80000000 < 0x0000000F
	s_i_ALUOP	<= "1011";
	s_i_A		<= x"80000000";
	s_i_B		<= x"0000000F";
	-- Expected o_F = 0x00000001, o_Zero = 0
	wait for cCLK_PER;

	-- SLL (1110) 0x0000000F << 0x00000004
	s_i_ALUOP	<= "1110";
	s_i_A		<= x"0000000F";
	s_i_B		<= x"00000004";
	-- Expected o_F = 0x000000F0
	wait for cCLK_PER;

	-- SLL (1110) 0x0000000F << 0x0000001F
	s_i_ALUOP	<= "1110";
	s_i_A		<= x"0000000F";
	s_i_B		<= x"0000001F";
	-- Expected o_F = 0x80000000
	wait for cCLK_PER;

	-- SRL (1100) 0x80000000 << 0x0000001F
	s_i_ALUOP	<= "1100";
	s_i_A		<= x"80000000";
	s_i_B		<= x"0000001F";
	-- Expected o_F = 0x00000001
	wait for cCLK_PER;

	-- SRA (1100) 0x80000000 << 0x0000001F
	s_i_ALUOP	<= "1101";
	s_i_A		<= x"80000000";
	s_i_B		<= x"0000001F";
	-- Expected o_F = 0xFFFF8000
	wait for cCLK_PER;


	
	
	
end process;

end behavior;
	

	
	




	
