-- adderstruct.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of an adder
--
--
-- NOTES:
-- 9/1/21 Created
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity adderstruct is

  port(i_x           : in std_logic;
       i_y           : in std_logic;
       i_cin         : in std_logic;
       o_sum         : out std_logic;
       o_cout        : out std_logic);

end adderstruct;

architecture structure of adderstruct is

  component andg2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

  component org2
    port(i_A          : in std_logic;
       	 i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

  component xorg2
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

  --Control to carry result from XOR of x & y
  signal s_xyXOR	: std_logic;

  --Control to carry result from and of x & y
  signal s_abAND	: std_logic;

  --Control to carry result from and of s_xyXOR and cin
  signal s_XORcinAND	: std_logic;


begin
  g_and0: andg2
    port MAP(i_A	=> i_x,
	     i_B        => i_y,
	     o_F	=> s_abAND);

  g_xor0: xorg2
    port MAP(i_A	=> i_x,
	     i_B        => i_y,
	     o_F	=> s_xyXOR);

  g_and1: andg2
    port MAP(i_A	=> i_cin,
	     i_B        => s_xyXOR,
	     o_F	=> s_XORcinAND);

  g_xor1: org2
    port MAP(i_A	=> s_abAND,
	     i_B        => s_XORcinAND,
	     o_F	=> o_cout);

  g_xor2: xorg2
    port MAP(i_A	=> s_xyXOR,
	     i_B        => i_cin,
	     o_F	=> o_sum);


end structure;



