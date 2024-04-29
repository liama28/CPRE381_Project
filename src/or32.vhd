-------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------
-- or32.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity or32 is
	port(
	i_A		: in std_logic_vector(31 downto 0);
	i_B		: in std_logic_vector(31 downto 0);
	o_F		: out std_logic_vector(31 downto 0));

end or32;

architecture structural of or32 is

	component org2 is 
		port(
		i_A          : in std_logic;
       		i_B          : in std_logic;
       		o_F          : out std_logic);	
	end component;

begin

	g_32bit_or: for i in 0 to 31 generate
		ori: org2 port map(
		i_A	=> i_A(i),
		i_B	=> i_B(i),
		o_F	=> o_F(i));
	end generate g_32bit_or;
end structural;