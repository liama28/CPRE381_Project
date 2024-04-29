-- mux_32bit_32t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 32 bit 32:1 mux
--
-------------------------------------------------------------------------

library IEEE;
library work;
use IEEE.std_logic_1164.all;
use work.array_2D32bit.all;

entity mux_32bit_32t1 is
  port(i_S	: in std_logic_vector(4 downto 0);
       i_D	: in Array2D;
       o_D	: out std_logic_vector(31 downto 0));

end mux_32bit_32t1;

architecture dataflow of mux_32bit_32t1 is



begin
	o_D <=  i_D(0)  when (i_S = "00000") else
		i_D(1)  when (i_S = "00001") else
		i_D(2)  when (i_S = "00010") else
		i_D(3)  when (i_S = "00011") else

		i_D(4)  when (i_S = "00100") else
		i_D(5)  when (i_S = "00101") else
		i_D(6)  when (i_S = "00110") else
		i_D(7)  when (i_S = "00111") else

		i_D(8)  when (i_S = "01000") else
		i_D(9)  when (i_S = "01001") else
		i_D(10) when (i_S = "01010") else
		i_D(11) when (i_S = "01011") else

		i_D(12) when (i_S = "01100") else
		i_D(13) when (i_S = "01101") else
		i_D(14) when (i_S = "01110") else
		i_D(15) when (i_S = "01111") else

		i_D(16) when (i_S = "10000") else
		i_D(17) when (i_S = "10001") else
		i_D(18) when (i_S = "10010") else
		i_D(19) when (i_S = "10011") else

		i_D(20) when (i_S = "10100") else
		i_D(21) when (i_S = "10101") else
		i_D(22) when (i_S = "10110") else
		i_D(23) when (i_S = "10111") else

		i_D(24) when (i_S = "11000") else
		i_D(25) when (i_S = "11001") else
		i_D(26) when (i_S = "11010") else
		i_D(27) when (i_S = "11011") else

		i_D(28) when (i_S = "11100") else
		i_D(29) when (i_S = "11101") else
		i_D(30) when (i_S = "11110") else
		i_D(31);

  
end dataflow;