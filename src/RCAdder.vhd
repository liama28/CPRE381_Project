-------------------------------------------------------------------------
-- Liam Anderson
-------------------------------------------------------------------------
-- RCAdder.vhd


library IEEE;
use IEEE.std_logic_1164.all;


entity RCAdder is
  generic(n : integer := 32);
  port(iA                         : in std_logic_vector(n-1 downto 0);
       iB			  : in std_logic_vector(n-1 downto 0);
       iC			  : in std_logic;
       oC 		          : out std_logic;
       oS			  : out std_logic_vector(n-1 downto 0));
end RCAdder;

architecture structure of RCAdder is

  component full_adder is
    port(iA          	: in std_logic;
	iB		: in std_logic;
	iC		: in std_logic;
	oC		: out std_logic;
       	oS          	: out std_logic);
  end component;

  signal s_C	: std_logic_vector(n-2 downto 0); 

begin
	fadder1: full_adder port map(
			iA	=> iA(0),
			iB	=> iB(0),
			iC	=> iC,
			oC	=> s_C(0),
			oS	=> oS(0));
	Inst_RCAdder: for i in 1 to n-2 generate
		fadder2: full_adder port map(
				iA	=> iA(i),
				iB	=> iB(i),
				iC	=> s_C(i-1),
				oC	=> s_C(i),
				oS	=> oS(i));
	end generate Inst_RCAdder;

	fadder3: full_adder port map(
			iA	=> iA(n-1),
			iB	=> iB(n-1),
			iC	=> s_C(n-2),
			oC	=> oC,
			oS	=> oS(n-1));
	 
  end structure;
