-------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------
-- or32to1.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity or32to1 is
	port(
	i_A	: in std_logic_vector(31 downto 0);
	o_F	: out std_logic);
end or32to1;

architecture structural of or32to1 is
	
	component org2 is
		port(
		i_A          : in std_logic;
       		i_B          : in std_logic;
       		o_F          : out std_logic);
	end component;
	
	signal s_S	: std_logic_vector(30 downto 0);

begin
	or0: org2 port map(
	i_A	=> i_A(0),
	i_B	=> i_A(1),
	o_F	=> s_S(0));

	g_32to1_or: for i in 1 to 29 generate
		ori: org2 port map(
		i_A	=> i_A(i+1),
		i_B	=> s_S(i-1),
		o_F	=> s_S(i));
	end generate g_32to1_or;

	or30: org2 port map(
	i_A	=> i_A(31),
	i_B	=> s_S(29),
	o_F	=> o_F);

end structural;
		