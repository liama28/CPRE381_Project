---------------------------------------------------------------------
----------------------------- EX_MEM.vhd -----------------------------
---------------------------------------------------------------------

library IEEE;
library work;
use IEEE.std_logic_1164.all;

entity EX_MEM is
	port(
	i_Inst	: in std_logic_vector(31 downto 0);
	i_MemAddr	: in std_logic_vector(31 downto 0);
	i_MemData	: in std_logic_vector(31 downto 0);
	i_WB		: in std_logic_vector(2 downto 0);				-- 3 bit(s) needed?
	i_M			: in std_logic;														-- 1 bit(s) needed?
	i_CLK		: in std_logic;
	i_WE 		: in std_logic;
	i_Rest 	: in std_logic;
	o_Inst	: out std_logic_vector(31 downto 0);
	o_MemAddr	: out std_logic_vector(31 downto 0);
	o_MemData	: out std_logic_vector(31 downto 0);
	o_M			: out std_logic);
end EX_MEM;

architecture structural of EX_MEM is

	component register_N is
		generic(N : integer := 107);		-- This value might need changing
		port(
		i_clk            : in std_logic;
         	i_writeEn        : in std_logic;
         	i_reset          : in std_logic;
         	i_D              : in std_logic_vector(N-1 downto 0);
         	o_D          	 : out std_logic_vector(N-1 downto 0));
  	end component;

	signal s_regInput	: std_logic_vector(106 downto 0);
	signal s_regOutput	: std_logic_vector(106 downto 0);

begin

	s_regInput	<= i_WB & i_M & i_EX & i_RS & i_RT & i_SignExtend;

	reg0 : register_N
		generic MAP( N => 107)			-- Size needs to be equal to signal size
		port MAP(
		i_clk  		=> i_CLK,
		i_writeEn => i_WE,
		i_reset		=> i_Rest,
		i_D				=> s_regInput,
		o_D				=> s_regOutput);

	o_WB					<= s_regOutput(106 downto 104);
	o_M						<= s_regOutput(103);
	o_EX					<= s_regOutput(102 downto 96);
	o_RS					<= s_regOutput(95 downto 64);
	o_RT					<= s_regOutput(63 downto 32);
	o_SignExtend	<= s_regOutput(31 downto 0);

end structural;
