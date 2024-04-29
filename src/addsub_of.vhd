-- addsub_of.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of an adder-subtractor
--
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity addsub_of is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(A        : in std_logic_vector(N-1 downto 0);
       B        : in std_logic_vector(N-1 downto 0);
       nAdd_Sub : in std_logic;
       o_sum    : out std_logic_vector(N-1 downto 0);
	o_of	: out std_logic;
       o_cout	: out std_logic);

end addsub_of;

architecture structure of addsub_of is

  component mux2t1_N is
    port(i_S          : in std_logic;
         i_D0         : in std_logic_vector(N-1 downto 0);
         i_D1         : in std_logic_vector(N-1 downto 0);
         o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  component ones_comp is
    port(i_D0         : in std_logic_vector(N-1 downto 0);
         o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  component adder_ripple_carry_N is
    port(i_D0             : in std_logic_vector(N-1 downto 0);
         i_D1             : in std_logic_vector(N-1 downto 0);
         i_cin         	  : in std_logic;
         o_sum            : out std_logic_vector(N-1 downto 0);
         o_cout           : out std_logic);
  end component;

  component andg2 is
	port(
	i_A	: in std_logic;
	i_B	: in std_logic;
	o_F	: out std_logic);
  end component;

  component org2 is
	port(
	i_A	: in std_logic;
	i_B	: in std_logic;
	o_F	: out std_logic);
  end component;

  component invg is
	port(
	i_A	: in std_logic;
	o_F	: out std_logic);
  end component;

  component mux2t1 is
	port(
	i_S          : in std_logic;
        i_D0         : in std_logic;
        i_D1         : in std_logic;
        o_O          : out std_logic);
  end component;

  --Control to carry ones comp signal 
  signal s_onesComp	: std_logic_vector(N-1 downto 0);
  --Control to carry result from 2t1 mux
  signal s_mux, s_sum	: std_logic_vector(N-1 downto 0);
  signal s_and, s_or, s_not : std_logic;


begin

  onesComp0: ones_comp
    port MAP(i_D0  => B,
	     o_O   => s_onesComp);

  mux0: mux2t1_N
    port Map(i_s   => nAdd_Sub,
	     i_D0  => B,
	     i_D1  => s_onesComp,
	     o_O   => s_mux);

  adder0: adder_ripple_carry_N
    port MAP(i_D0   => A,
	     i_D1   => s_mux,
	     i_cin  => nAdd_Sub,
	     o_sum  => s_sum,
	     o_cout => o_cout);
  
  and0: andg2
	port map(
	i_A	=> A(N-1),
	i_B	=> B(N-1),
	o_F	=> s_and);

  or0: org2
	port map(
	i_A	=> A(N-1),
	i_B	=> B(N-1),
	o_F	=> s_or);

  not0: invg
	port map(
	i_A	=> s_or,
	o_F	=> s_not);

  mux1: mux2t1
	port map(
	i_S	=> s_sum(N-1),
	i_D0	=> s_and,
	i_D1	=> s_not,
	o_O	=> o_of);

   o_sum <= s_sum;

end structure;


