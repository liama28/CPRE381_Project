-- reg_file.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an register file
--
-------------------------------------------------------------------------

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.array_2D32bit.all;

entity reg_file is
  port(i_RS	: in std_logic_vector(4 downto 0);
       i_RT	: in std_logic_vector(4 downto 0);
       i_RD	: in std_logic_vector(4 downto 0);
       i_D	: in std_logic_vector(31 downto 0);
       i_CLK	: in std_logic;
       i_reset	: in std_logic;
       i_WE	: in std_logic;
       o_RS	: out std_logic_vector(31 downto 0);
       o_RT	: out std_logic_vector(31 downto 0));

end reg_file;


architecture structural of reg_file is

  -- components
  component andg2 is
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end component;

  component decoder_5t32 is
    port(i_S	: in std_logic_vector(4 downto 0);
         o_O	: out std_logic_vector(31 downto 0));
  end component;

  component register_N is
    generic(N : integer := 32); 
    port(i_clk            : in std_logic;
         i_writeEn        : in std_logic;
         i_reset          : in std_logic;
         i_D              : in std_logic_vector(N-1 downto 0);
         o_D          	  : out std_logic_vector(N-1 downto 0));
  end component;

  component mux_32bit_32t1 is
    port(i_S	: in std_logic_vector(4 downto 0);
         i_D	: in Array2D;
         o_D	: out std_logic_vector(31 downto 0));
  end component;

  --signals
  signal s_decoder_out   		: std_logic_vector(31 downto 0); --output of decoder
  signal s_registers_input		: std_logic_vector(31 downto 0); --output of decoder anded with i_WE
  signal s_mux_input     		: Array2D; 			 --input of muxes/output from registers


begin

  --decoder
  decoder: decoder_5t32
    port MAP(i_S  => i_RD,
	     o_O  => s_decoder_out);

  --and gates
  g_andg: for i in 0 to 31 generate
    andgI: andg2 port map(
	i_A => s_decoder_out(i),
	i_B => i_WE,
	o_F  => s_registers_input(i));
  end generate g_andg;

  --registers
  reg0: register_N
    port MAP(i_clk  	=> i_CLK,
	     i_writeEn 	=> s_registers_input(0),
	     i_reset	=> '1',
	     i_D	=> i_D,
	     o_D	=> s_mux_input(0));

  g_register_N: for i in 1 to 31 generate
    regI: register_N port map(
	   i_clk  	=> i_CLK,
	   i_writeEn 	=> s_registers_input(i),
	   i_reset	=> i_reset,
	   i_D		=> i_D,
	   o_D		=> s_mux_input(i));
  end generate g_register_N;

  --rs mux
  mux_RS: mux_32bit_32t1
    port MAP(
	  i_S	=> i_RS,
          i_D	=> s_mux_input,
          o_D	=> o_RS);

  --rt mux
  mux_RT: mux_32bit_32t1
    port MAP(
	  i_S	=> i_RT,
          i_D	=> s_mux_input,
          o_D	=> o_RT);
  
end structural;