-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of a 2 to 1 mux
--
--
-- NOTES:
-- 9/1/21 Created
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is

  port(i_S          : in std_logic;
       i_D0         : in std_logic;
       i_D1         : in std_logic;
       o_O          : out std_logic);

end mux2t1;

architecture structure of mux2t1 is

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

  component invg
    port(i_A          : in std_logic;
         o_F          : out std_logic);
  end component;

  --Control to carry inverted signal from 
  signal i_invS	: std_logic;

  --Control to carry result from g_and0
  signal s_And0	: std_logic;

  --Control to carry result from g_and1
  signal s_And1	: std_logic;


begin

g_invg0: invg
  port MAP(i_A  => i_S,
	   o_F  => i_invS);

g_and0: andg2
  port MAP(i_A	=> i_D1, --was D0
	   i_B  => i_S,
	   o_F	=> s_And0);

g_and1: andg2
  port MAP(i_A	=> i_D0, --was D1
	   i_B  => i_invS,
	   o_F	=> s_And1);

g_org: org2
  port MAP(i_A	=> s_And0,
	   i_B  => s_And1,
	   o_F	=> o_O);

end structure;




