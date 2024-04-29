-------------------------------------------------------------------------
-- Liam Anderson
-------------------------------------------------------------------------


-- OnesComp.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: VHDl Multiplexor design.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity OnesComp is
  generic(n : integer := 32);
  port(iA                         : in std_logic_vector(n-1 downto 0);
       oB 		          : out std_logic_vector(n-1 downto 0));
end OnesComp;

architecture structure of OnesComp is

  component invg is
    port(i_A          	: in std_logic;
       o_F          	: out std_logic);
  end component;



begin
	Inst_OnesComp: for i in 0 to n-1 generate
		OnesC: invg port map(
				i_A	=> iA(i),
				o_F	=> oB(i));
	end generate Inst_OnesComp;
	 


  end structure;
