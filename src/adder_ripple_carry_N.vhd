-- adder_ripple_carry_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains am implementation of an n-bit ripple 
-- carry adder
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity adder_ripple_carry_N is
  generic(N : integer := 32); 
  port(i_D0             : in std_logic_vector(N-1 downto 0);
       i_D1             : in std_logic_vector(N-1 downto 0);
       i_cin         	: in std_logic;
       o_sum          	: out std_logic_vector(N-1 downto 0);
       o_cout          	: out std_logic);

end adder_ripple_carry_N;

architecture structural of adder_ripple_carry_N is

component adderstruct is
  port(i_x             : in std_logic;
       i_y             : in std_logic;
       i_cin           : in std_logic;
       o_sum           : out std_logic;
       o_cout          : out std_logic);

end component;


signal s_carry	       : std_logic_vector(N-1 downto 0);

begin

  adder: adderstruct port map (
	i_x => i_D0(0),
	i_y => i_D1(0),
	i_cin => i_cin,
	o_sum => o_sum(0),
  	o_cout => s_carry(0));

  G_NBit_Adder: for i in 1 to N-1 generate
    ADDERI: adderstruct port map(
	i_x => i_D0(i),
	i_y => i_D1(i),
	i_cin => s_carry(i-1),
	o_sum => o_sum(i),
  	o_cout => s_carry(i));
  end generate G_NBit_Adder;

  o_cout <= s_carry(N-1);
  
end structural;