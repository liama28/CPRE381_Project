-------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------
-- ALU.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;
-------------------------------------------------------------------------
-- ALU Operatoion Code
-- AND		| 000x
-- OR 		| 001x
-- NOR		| 010x
-- XOR		| 011x
-- ADD		| 1000
-- SUB		| 1001
-- SLT		| 1011
-- SLL		| 1110
-- SRL		| 1100
-- SRA		| 1101
-------------------------------------------------------------------------

entity ALU is
	port(
	i_A		: in std_logic_vector(31 downto 0);	-- 32-Bit operand A
       	i_B		: in std_logic_vector(31 downto 0);	-- 32-Bit operand B
       	i_ALUOP		: in std_logic_vector(3 downto 0);	-- 4-Bit ALU Operation Code 
       	o_F		: out std_logic_vector(31 downto 0);	-- 32-Bit Result ouput
       	o_CO		: out std_logic;			-- Carryout output
	o_OF		: out std_logic;			-- Overflow output
	o_Zero		: out std_logic);
end ALU;

architecture structure of ALU is
  
-------------------------------------------------------------------------
----- Define components
-------------------------------------------------------------------------

  	component OnesComp is
  	generic(N : integer := 32);
  	port(
	iA            : in std_logic_vector(N-1 downto 0);
       	oB		: out std_logic_vector(N-1 downto 0)
	);
  	end component;

  	component AdderSubtractor is
  	port(
	i_A	    	: in std_logic_vector(31 downto 0);
       	i_B		: in std_logic_vector(31 downto 0);
       	nAdd_Sub	: in std_logic;
       	o_OF		: out std_logic;
	o_CO		: out std_logic;
       	o_S		: out std_logic_vector(31 downto 0)
	);
  	end component;

  	component org2 is
  	port(
	i_A          	: in std_logic;
 	i_B          	: in std_logic;
       	o_F          	: out std_logic
	);
  	end component;

  	component andg2 is
  	port(
	i_A          	: in std_logic;
       	i_B          	: in std_logic;
       	o_F          	: out std_logic);
  	end component;

  	component invg is
  	port(
	i_A          	: in std_logic;
       	o_F       	: out std_logic);
  	end component;

  	component mux2t1 is
  	port(i_S     	: in std_logic;
       	i_D0         	: in std_logic;
       	i_D1         	: in std_logic;
       	o_O          	: out std_logic);
  	end component;

	component mux8to1_32bit is
	port(
	i_S	: in std_logic_vector(2 downto 0);
	i_D0	: in std_logic_vector(31 downto 0);
	i_D1	: in std_logic_vector(31 downto 0);
	i_D2	: in std_logic_vector(31 downto 0);
	i_D3	: in std_logic_vector(31 downto 0);
	i_D4	: in std_logic_vector(31 downto 0);
	i_D5	: in std_logic_vector(31 downto 0);
	i_D6	: in std_logic_vector(31 downto 0);
	i_D7	: in std_logic_vector(31 downto 0);
	o_O	: out std_logic_vector(31 downto 0));
	end component;

	component or32 is
	port(
	i_A		: in std_logic_vector(31 downto 0);
	i_B		: in std_logic_vector(31 downto 0);
	o_F		: out std_logic_vector(31 downto 0));
	end component;

	component and32 is
	port(
	i_A		: in std_logic_vector(31 downto 0);
	i_B		: in std_logic_vector(31 downto 0);
	o_F		: out std_logic_vector(31 downto 0));
	end component;

	component or32to1 is
	port(
	i_A	: in std_logic_vector(31 downto 0);
	o_F	: out std_logic);
	end component;

	component xor32 is
	port(
	i_A		: in std_logic_vector(31 downto 0);
	i_B		: in std_logic_vector(31 downto 0);
	o_F		: out std_logic_vector(31 downto 0));
	end component;

	
	component barrel_shifter is
	port(i_data      	: in std_logic_vector(31 downto 0);
       	shift_amt		: in std_logic_vector(4 downto 0);
       	go_left			: in std_logic;
       	shift_arithmetic	: in std_logic;
       	o_data   		: out std_logic_vector(31 downto 0));
	end component;

-------------------------------------------------------------------------
-- Signals
-------------------------------------------------------------------------

	signal s_and32, s_or32, s_xor32, s_sum, s_bs, s_nor32, s_mux, s_slt 	: std_logic_vector(31 downto 0);
	signal s_or, s_not_slt, s_or_slt, s_and_slt	: std_logic;

  	constant SIZE: integer := 32;

	begin
-------------------------------------------------------------------------
---- Define Structure
-------------------------------------------------------------------------
		
		g_and32_0: and32
		port map(
		i_A	=> i_A,
		i_B	=> i_B,
		o_F	=> s_and32);

		g_or32_0: or32
		port map(
		i_A	=> i_A,
		i_B	=> i_B,
		o_F	=> s_or32);

		g_nor_0: OnesComp
		generic map(N => 32)
		port map(
		iA	=> s_or32,
		oB	=> s_nor32);

		g_xor32_0: xor32
		port map(
		i_A	=> i_A,
		i_B	=> i_B,
		o_F	=> s_xor32);

		g_addsub_0: AdderSubtractor
		port map(
		i_A		=> i_A,
		i_B		=> i_B,
		nAdd_Sub	=> i_ALUOP(0),
		o_OF		=> o_OF,
		o_CO		=> o_CO,
		o_S		=> s_sum);

		g_bs_0: barrel_shifter
		port map(
		i_data			=> i_B,
		shift_amt		=> i_A(4 downto 0),
		go_left			=> i_ALUOP(1),
		shift_arithmetic	=> i_ALUOP(0),
		o_data			=> s_bs);

		
		g_not_slt : invg
		port map(
		i_A			=> i_B(31),
		o_F			=> s_not_slt);

		g_and_slt : andg2
		port map(
		i_A			=> s_not_slt,
		i_B			=> i_A(31),
		o_F			=> s_and_slt);

		g_or_slt : org2
		port map(
		i_A			=> s_and_slt,
		i_B			=> s_sum(31),
		o_F			=> s_or_slt);

		s_slt <= "0000000000000000000000000000000" & s_or_slt;

		g_mux_0: mux8to1_32bit
		port map(
		i_S	=> i_ALUOP(3 downto 1),
		i_D0	=> s_and32,
		i_D1	=> s_or32,
		i_D2	=> s_nor32,
		i_D3	=> s_xor32,
		i_D4	=> s_sum,
		i_D5	=> s_slt,	-- When sum is negative s_sum(31) = 10, when sum is positive s_sum(0) = 0
		i_D6	=> s_bs,
		i_D7	=> s_bs,
		o_O	=> s_mux);

		g_or32to1_0: or32to1
		port map(
		i_A	=> s_mux,
		o_F	=> s_or);

		g_not_0: invg
		port map(
		i_A	=> s_or,
		o_F	=> o_Zero);

		o_F <=	s_mux;
		
	
 
end structure;
