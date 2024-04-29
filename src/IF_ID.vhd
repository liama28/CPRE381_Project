---------------------------------------------------------------------
----------------------------- IF_ID.vhd -----------------------------
---------------------------------------------------------------------

library IEEE;
library work;
use IEEE.std_logic_1164.all;

entity IF_ID is
	port(
	i_PC			: in std_logic_vector(31 downto 0);
	i_Inst		: in std_logic_vector(31 downto 0);
	i_CLK			: in std_logic;
	i_WE			: in std_logic;
	i_Rest 		: in std_logic;
	o_PC			: out std_logic_vector(31 downto 0);
	o_Inst		: out std_logic_vector(31 downto 0));
end IF_ID;

architecture structural of IF_ID is

	component register_N is
		generic(N : integer := 64);
		port(
		i_clk            : in std_logic;
         	i_writeEn        : in std_logic;
         	i_reset          : in std_logic;
         	i_D              : in std_logic_vector(N-1 downto 0);
         	o_D          	 : out std_logic_vector(N-1 downto 0));
  	end component;

	signal s_regInput	: std_logic_vector(63 downto 0);
	signal s_regOutput	: std_logic_vector(63 downto 0);

begin

	s_regInput	<= i_PC & i_Inst;

	reg0 : register_N
		generic MAP( N => 64)
		port MAP(
		i_clk  		=> i_CLK,
		i_writeEn 	=> i_WE,
		i_reset		=> i_Rest,
		i_D		=> s_regInput,
		o_D		=> s_regOutput);

	o_PC		<= s_regOutput(63 downto 32);
	o_Inst		<= s_regOutput(31 downto 0);

end structural;
