-- register_pc.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an pc register
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity register_pc is 
  port(i_clk            : in std_logic;
       i_writeEn        : in std_logic;
       i_reset         	: in std_logic;
       i_D              : in std_logic_vector(31 downto 0);
       o_D          	: out std_logic_vector(31 downto 0));

end register_pc;

architecture mixed of register_pc is

	signal s_data	: std_logic_vector(31 downto 0);

begin


process(i_reset, i_D) is
	begin

	s_data <= i_D;

	if i_reset = '1' then
		s_data <= x"00400000";
	end if;

end process;
  

process(i_clk) is
	begin

	if rising_edge(i_clk) then
		o_D <= s_data;
	end if;

end process;
end mixed;
