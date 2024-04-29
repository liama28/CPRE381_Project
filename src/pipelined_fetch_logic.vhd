-- pipelined_fetch_logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation for the fetch logic
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity pipelined_fetch_logic is
  generic(N : integer := 32);
  port(i_jump_amt	: in std_logic_vector(31 downto 0);
       i_rs		: in std_logic_vector(31 downto 0);
       i_pc_plus4	: in std_logic_vector(31 downto 0);
       i_imem		: in std_logic_vector(25 downto 0);
       i_jump	 	: in std_logic;
       i_jr	 	: in std_logic;
       i_beq		: in std_logic;
       i_bne		: in std_logic;
       i_zero	 	: in std_logic;
       i_CLK		: in std_logic;
       i_RST		: in std_logic;
       o_pc		: out std_logic_vector(31 downto 0));
end pipelined_fetch_logic;

architecture structure of pipelined_fetch_logic is

  entity org2 is
    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  end org2;

  component mux2t1_N is
    port(i_S          : in std_logic;
         i_D0         : in std_logic_vector(N-1 downto 0);
         i_D1         : in std_logic_vector(N-1 downto 0);
         o_O          : out std_logic_vector(N-1 downto 0));
  end component;

  component adder_ripple_carry_N is
    port(i_D0             : in std_logic_vector(N-1 downto 0);
         i_D1             : in std_logic_vector(N-1 downto 0);
         i_cin         	  : in std_logic;
         o_sum            : out std_logic_vector(N-1 downto 0);
         o_cout           : out std_logic);
  end component;

  component register_pc is 
    port(i_clk            : in std_logic;
         i_writeEn        : in std_logic;
         i_reset          : in std_logic;
         i_D              : in std_logic_vector(31 downto 0);
         o_D          	  : out std_logic_vector(31 downto 0));
  end component;

  signal s_shifted_imem		: std_logic_vector(27 downto 0);
  signal s_shifted_jump_amt	: std_logic_vector(31 downto 0);
  signal s_jump_amt_add_pc	: std_logic_vector(31 downto 0);
  signal s_mux_adders_out	: std_logic_vector(31 downto 0);
  signal s_jump_address_cnctd	: std_logic_vector(31 downto 0);
  signal s_jump_address		: std_logic_vector(31 downto 0);
  signal s_dummy		: std_logic_vector(2 downto 0);
  signal should_branch		: std_logic;
  signal s_i_branch		: std_logic;


begin

  s_shifted_jump_amt <= i_jump_amt(29 downto 0) & "00";

  adder_jump_amt: adder_ripple_carry_N
    port MAP(i_D0   => i_pc_plus4,
	     i_D1   => s_shifted_jump_amt,
	     i_cin  => '0',
	     o_sum  => s_jump_amt_add_pc,
	     o_cout => s_dummy(2));

  entity org2 is
    port(i_A          => i_beq,
         i_B          => i_bne,
         o_F          => s_i_branch);
  end org2;

  -- branch logic module
  should_branch <= '1' when((i_zero and i_beq and s_i_branch) OR (not i_zero and i_bne and s_i_branch)) = '1'
  else '0';

  mux_adders: mux2t1_N
    port Map(i_s   => should_branch,
	     i_D0  => i_pc_plus4,
	     i_D1  => s_jump_amt_add_pc,
	     o_O   => s_mux_adders_out);

  s_shifted_imem <= i_imem(25 downto 0) & "00";
  
  s_jump_address_cnctd <= i_pc_plus4(31 downto 28) & s_shifted_imem;

  mux_jr: mux2t1_N
    port Map(i_s   => i_jr,
	     i_D0  => s_jump_address_cnctd,
	     i_D1  => i_rs,
	     o_O   => s_jump_address);

  mux_t_pc: mux2t1_N
    port Map(i_s   => i_jump,
	     i_D0  => s_mux_adders_out,
	     i_D1  => s_jump_address,
	     o_O   => o_pc);

end structure;