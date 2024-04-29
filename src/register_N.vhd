-- register_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit register
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity register_N is
  generic(N : integer := 32); 
  port(i_clk            : in std_logic;
       i_writeEn        : in std_logic;
       i_reset         	: in std_logic;
       i_D              : in std_logic_vector(N-1 downto 0);
       o_D          	: out std_logic_vector(N-1 downto 0));

end register_N;

architecture structural of register_N is

component dffg is
  port(i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output

end component;


signal s_muxtdffg   : std_logic_vector(N-1 downto 0);

begin
  G_register_N: for i in 0 to N-1 generate
    dffgI: dffg port map(
	i_CLK => i_clk,
	i_RST => i_reset,
	i_WE  => i_writeEn,
	i_D   => i_D(i),
  	o_Q   => o_D(i));
  end generate G_register_N;
  
end structural;