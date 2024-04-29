-- ones_comp.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a structural implementation of a ones comp
--
--
-- NOTES:
-- 9/3/21 Created
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity ones_comp is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_D0         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));

end ones_comp;

architecture structural of ones_comp is

  component invg is
    port(i_A          : in std_logic;
         o_F          : out std_logic);
  end component;
    

begin

  G_Ones_Comp: for i in 0 to N-1 generate
    INVGI: invg port map(
              i_A     => i_D0(i),
              o_F      => o_O(i));
  end generate G_Ones_Comp;
  
end structural;