---------------------------------------------------------------------
----------------------------- ID_EX.vhd -----------------------------
---------------------------------------------------------------------

library IEEE;
library work;
use IEEE.std_logic_1164.all;

entity ID_EX is
	port(
	i_RS		: in std_logic_vector(31 downto 0);
	i_RT		: in std_logic_vector(31 downto 0);
	i_SignExtend	: in std_logic_vector(31 downto 0);
	i_Inst	:			: in std_logic_vector(31 downto 0);
	i_WB		: in std_logic_vector(2 downto 0);				-- 3 bit(s) needed?
	i_M			: in std_logic;														-- 1 bit(s) needed?
	i_EX		: in std_logic_vector(6 downto 0);				-- 7 bits needed. Last 4 bits are ALUOP
	i_CLK		: in std_logic;
	i_WE 		: in std_logic;
	i_Rest 	: in std_logic;
	o_RS		: out std_logic_vector(31 downto 0);
	o_RT		: out std_logic_vector(31 downto 0);
	o_WB		: out std_logic_vector(2 downto 0);
	o_M			: out std_logic;
	o_EX		: out std_logic_vector(6 downto 0);
	o_Inst	: out std_logic_vector(31 downto 0);
	o_SignExtend	: out std_logic_vector(31 downto 0));
end ID_EX;

architecture structural of ID_EX is

	component register_N is
		generic(N : integer := 138);		-- This value might need changing
		port(
		i_clk            : in std_logic;
         	i_writeEn        : in std_logic;
         	i_reset          : in std_logic;
         	i_D              : in std_logic_vector(N-1 downto 0);
         	o_D          	 : out std_logic_vector(N-1 downto 0));
  	end component;

	signal s_regInput	: std_logic_vector(138 downto 0);
	signal s_regOutput	: std_logic_vector(138 downto 0);

begin

	s_regInput	<= i_Inst & i_WB & i_M & i_EX & i_RS & i_RT & i_SignExtend;

	reg0 : register_N
		generic MAP( N => 138)			-- Size needs to be equal to signal size
		port MAP(
		i_clk  		=> i_CLK,
		i_writeEn => i_WE,
		i_reset		=> i_Rest,
		i_D				=> s_regInput,
		o_D				=> s_regOutput);

	o_Inst				<= s_regOutput(107 downto 138);
	o_WB					<= s_regOutput(106 downto 104);
	o_M						<= s_regOutput(103);
	o_EX					<= s_regOutput(102 downto 96);
	o_RS					<= s_regOutput(95 downto 64);
	o_RT					<= s_regOutput(63 downto 32);
	o_SignExtend	<= s_regOutput(31 downto 0);

end structural;
