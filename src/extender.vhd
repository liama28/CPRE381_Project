-- extender.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a bit-width extender
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity extender is
  port(i_data      	: in std_logic_vector(15 downto 0);
       extend_with 	: in std_logic;
       o_data   	: out std_logic_vector(31 downto 0));

end extender;


architecture behavioral of extender is

  component mux2t1 is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic;
         i_D1                 : in std_logic;
         o_O                  : out std_logic);
  end component;

  signal s_mux_t_concat	      : std_logic;

begin

  mux0: mux2t1
    port Map(i_s   => extend_with,
	     i_D0  => '0', 
	     i_D1  => i_data(15),
	     o_O   => s_mux_t_concat);

	o_data <= x"0000" & i_data when (s_mux_t_concat = '0') else
	          x"FFFF" & i_data;



end behavioral;