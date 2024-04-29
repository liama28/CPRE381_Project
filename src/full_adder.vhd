-------------------------------------------------------------------------
-- Liam Anderson
-------------------------------------------------------------------------
-- full_adder.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;


entity full_adder is

  port(iA                         : in std_logic;
       iB 		            : in std_logic;
       iC 		            : in std_logic;
       oC			    : out std_logic;
       oS 		            : out std_logic);
end full_adder;

architecture structure of full_adder is
  
  -- Describe the component entities as defined in andg2.vhd, org2.vhd, and invg.vhd (not strictly necessary).
  component andg2
    port(i_A          	: in std_logic;
       i_B		: in std_logic;
       o_F          	: out std_logic);
  end component;

  component org2
    port(i_A          	: in std_logic;
       i_B          	: in std_logic;
       o_F          	: out std_logic);
  end component;

  component xorg2
    port(i_A        : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;


  -- Signal from g_xor1 to g_xor2 and g_and1
  signal s_xor1		: std_logic;
  -- Signals from g_and1 and g_and2 to g_or1
  signal s_and1, s_and2 : std_logic;

begin
 
  g_xor1: xorg2
    port MAP(i_A     		=> iA,
	     i_B		=> iB,
             o_F      		=> s_xor1);

  g_xor2: xorg2
    port MAP(i_A		=> s_xor1,
	     i_B		=> iC,
	     o_F		=> oS);

  g_and1: andg2
    port MAP(i_A             	=> s_xor1,
             i_B           	=> iC,
             o_F              	=> s_and1);
  
  g_and2: andg2
    port MAP(i_A		=> iA,
             i_B       		=> iB,
             o_F       		=> s_and2);

  g_or1: org2
    port MAP(i_A           	=> s_and1,
             i_B           	=> s_and2,
             o_F           	=> oC);

  end structure;
