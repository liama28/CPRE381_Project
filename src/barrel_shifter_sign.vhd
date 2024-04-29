-- barrel_shifter_sign.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a barrel shifter
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity barrel_shifter_sign is
  port(i_data      	: in std_logic_vector(31 downto 0);
       shift_amt	: in std_logic_vector(4 downto 0);
       go_left		: in std_logic;
       sign_shift	: in std_logic; 			-- Added
       o_data   	: out std_logic_vector(31 downto 0));

end barrel_shifter_sign;

architecture behavioral of barrel_shifter_sign is

  component mux2t1 is
    port(i_S                  : in std_logic;
         i_D0                 : in std_logic;
         i_D1                 : in std_logic;
         o_O                  : out std_logic);
  end component;

  component andg2 is
 	port(i_A		: in std_logic;
	i_B			: in std_logic;
	o_F			: out std_logic);
  end component;

  component invg is
	port(i_A          : in std_logic;
       	o_F          	  : out std_logic);
  end component;

  signal s_flip_t_16	      : std_logic_vector(31 downto 0);
  signal s_16_t_8	      : std_logic_vector(31 downto 0);
  signal s_8_t_4	      : std_logic_vector(31 downto 0);
  signal s_4_t_2	      : std_logic_vector(31 downto 0);
  signal s_2_t_1	      : std_logic_vector(31 downto 0);
  signal s_1_t_flip	      : std_logic_vector(31 downto 0);

  signal s_and		      : std_logic;
  signal s_not		      : std_logic;
  signal s_sign		      : std_logic := '0'; 

begin

  inv0: invg port map(
	i_A	=> go_left,
	o_F	=> s_not);

  and0: andg2 port map(
	i_A	=> s_not,
	i_B	=> sign_shift,
	o_F	=> s_and);

  and1: andg2 port map(
	i_A	=> s_and,
	i_B	=> i_data(31),
	o_F	=> s_sign);

  -- Instantiate 32 mux instances to flip bits around
  G_flip1_bit_lower_MUX: for i in 0 to 15 generate
    MUXI: mux2t1 port map(
              i_S      => go_left,
              i_D0     => i_data(i),
              i_D1     => i_data(31-i),
              o_O      => s_flip_t_16(i));
  end generate G_flip1_bit_lower_MUX;

  G_flip1_bit_upper_MUX: for i in 31 downto 16 generate
    MUXI: mux2t1 port map(
              i_S      => go_left,
              i_D0     => i_data(i),
              i_D1     => i_data(31-i),
              o_O      => s_flip_t_16(i));
  end generate G_flip1_bit_upper_MUX;

  -- Instantiate 32 mux instances for the 16 bit shift amt op
  G_16bit_lower_MUX: for i in 0 to 15 generate
    MUXI: mux2t1 port map(
              i_S      => shift_amt(4),
              i_D0     => s_flip_t_16(i),
              i_D1     => s_flip_t_16(i+16),
              o_O      => s_16_t_8(i));
  end generate G_16bit_lower_MUX;

  G_16bit_upper_MUX: for i in 16 to 31 generate
    MUXI: mux2t1 port map(
              i_S      => shift_amt(4),
              i_D0     => s_flip_t_16(i),
              i_D1     => s_sign,
              o_O      => s_16_t_8(i));
  end generate G_16bit_upper_MUX;


  -- Instantiate 32 mux instances for the 8 bit shift amt op
  G_8bit_lower_MUX: for i in 0 to 23 generate
    MUXI: mux2t1 port map(
              i_S      => shift_amt(3),
              i_D0     => s_16_t_8(i),
              i_D1     => s_16_t_8(i+8),
              o_O      => s_8_t_4(i));
  end generate G_8bit_lower_MUX;

  G_8bit_upper_MUX: for i in 24 to 31 generate
    MUXI: mux2t1 port map(
              i_S      => shift_amt(3),
              i_D0     => s_16_t_8(i),
              i_D1     => s_sign,
              o_O      => s_8_t_4(i));
  end generate G_8bit_upper_MUX;


  -- Instantiate 32 mux instances for the 4 bit shift amt op
  G_4bit_lower_MUX: for i in 0 to 27 generate
    MUXI: mux2t1 port map(
              i_S      => shift_amt(2),
              i_D0     => s_8_t_4(i),
              i_D1     => s_8_t_4(i+4),
              o_O      => s_4_t_2(i));
  end generate G_4bit_lower_MUX;

  G_4bit_upper_MUX: for i in 28 to 31 generate
    MUXI: mux2t1 port map(
              i_S      => shift_amt(2),
              i_D0     => s_8_t_4(i),
              i_D1     => s_sign,
              o_O      => s_4_t_2(i));
  end generate G_4bit_upper_MUX;


  -- Instantiate 32 mux instances for the 2 bit shift amt op
  G_2bit_lower_MUX: for i in 0 to 29 generate
    MUXI: mux2t1 port map(
              i_S      => shift_amt(1),
              i_D0     => s_4_t_2(i),
              i_D1     => s_4_t_2(i+2),
              o_O      => s_2_t_1(i));
  end generate G_2bit_lower_MUX;

  G_2bit_upper_MUX: for i in 30 to 31 generate
    MUXI: mux2t1 port map(
              i_S      => shift_amt(1),
              i_D0     => s_4_t_2(i),
              i_D1     => s_sign,
              o_O      => s_2_t_1(i));
  end generate G_2bit_upper_MUX;


  -- Instantiate 32 mux instances for the 1 bit shift amt op
  G_1bit_lower_MUX: for i in 0 to 30 generate
    MUXI: mux2t1 port map(
              i_S      => shift_amt(0),
              i_D0     => s_2_t_1(i),
              i_D1     => s_2_t_1(i+1),
              o_O      => s_1_t_flip(i));
  end generate G_1bit_lower_MUX;

  G_1bit_upper_MUX: for i in 31 to 31 generate
    MUXI: mux2t1 port map(
              i_S      => shift_amt(0),
              i_D0     => s_2_t_1(i),
              i_D1     => s_sign,
              o_O      => s_1_t_flip(i));
  end generate G_1bit_upper_MUX;

  -- Instantiate 32 mux instances to flip bits around
  G_flip2_bit_lower_MUX: for i in 0 to 15 generate
    MUXI: mux2t1 port map(
              i_S      => go_left,
              i_D0     => s_1_t_flip(i),
              i_D1     => s_1_t_flip(31-i),
              o_O      => o_data(i));
  end generate G_flip2_bit_lower_MUX;

  G_flip2_bit_upper_MUX: for i in 31 downto 16 generate
    MUXI: mux2t1 port map(
              i_S      => go_left,
              i_D0     => s_1_t_flip(i),
              i_D1     => s_1_t_flip(31-i),
              o_O      => o_data(i));
  end generate G_flip2_bit_upper_MUX;



--remove this
--o_data <= s_2_t_1;

end behavioral;