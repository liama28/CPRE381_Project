-------------------------------------------------------------------------
-- Liam Anderson
-------------------------------------------------------------------------
-- AdderSubtractor.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;


entity AdderSubtractor is
  port(i_A                        : in std_logic_vector(31 downto 0);
       i_B			  : in std_logic_vector(31 downto 0);
       nAdd_Sub			  : in std_logic;
       o_OF			  : out std_logic;
       o_CO			  : out std_logic;
       o_S			  : out std_logic_vector(31 downto 0));
end AdderSubtractor;

architecture structure of AdderSubtractor is
  

  component mux2t1_N is
  generic(N : integer := 32); 
  port(i_S          : in std_logic;
       i_D0         : in std_logic_vector(N-1 downto 0);
       i_D1         : in std_logic_vector(N-1 downto 0);
       o_O          : out std_logic_vector(N-1 downto 0));
  end component;


  component OnesComp is
  generic(n : integer := 32);
  port(iA                         : in std_logic_vector(n-1 downto 0);
       oB 		          : out std_logic_vector(n-1 downto 0));
  end component;

  component RCAdder is
  generic(n : integer := 32);
  port(iA                         : in std_logic_vector(n-1 downto 0);
       iB			  : in std_logic_vector(n-1 downto 0);
       iC			  : in std_logic;
       oC 		          : out std_logic;
       oS			  : out std_logic_vector(n-1 downto 0));
  end component;

  component org2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  component andg2 is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
  end component;

  component invg is
  port(i_A          : in std_logic;
       o_F          : out std_logic);
  end component;

  component mux2t1 is
  port(i_S          : in std_logic;
       i_D0         : in std_logic;
       i_D1         : in std_logic;
       o_O          : out std_logic);
  end component;

  signal s_oc, s_mux0, s_osa, s_osb : std_logic_vector(31 downto 0);
  signal s_and, s_or, s_nor, s_ca 		    : std_logic;
  constant SIZE: integer := 32;

begin
 
  g_mux_0: mux2t1_N
    generic map(N => SIZE)
    port MAP(i_S     		=> nAdd_Sub,
	     i_D0		=> i_B,
             i_D1      		=> s_osa,
	     o_O		=> s_mux0);



  g_onesComp: OnesComp
    generic map(N => SIZE)
    port MAP(iA             	=> i_B,
             oB              	=> s_oc);
  
  g_RCAb: RCAdder
    generic map(N => SIZE)
    port MAP(iA			=> s_oc,
             iB       		=> x"00000000",
             iC			=> '1',
	     oC			=> s_ca,
	     oS			=> s_osa);

  g_RCAa: RCAdder
    generic map(N => SIZE)
    port MAP(iA			=> i_A,
             iB       		=> s_mux0,
             iC			=> '0',
	     oC			=> o_CO,
	     oS			=> s_osb);


  g_and: andg2
  port MAP(i_A    		=> i_A(31),
       i_B       		=> s_mux0(31),
       o_F        		=> s_and);

  g_or: org2
  port map(i_A        		=> i_A(31),
       i_B         		=> s_mux0(31),
       o_F          		=> s_or);

  g_not: invg
  port map(i_A          => s_or,
           o_F          => s_nor);

  g_muxc: mux2t1
    port MAP(i_S     		=> s_osb(31),
	     i_D0		=> s_and,
             i_D1      		=> s_nor,
	     o_O		=> o_OF);

  o_S	<= s_osb;

  

  end structure;
