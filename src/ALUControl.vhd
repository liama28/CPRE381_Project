-------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------
-- ALUControl.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity ALUControl is
	port(
	i_ALUOp		: in std_logic_vector(2 downto 0);
	i_F		: in std_logic_vector(5 downto 0);
	o_ALUOp		: out std_logic_vector(3 downto 0));
end ALUControl;

architecture structure of ALUControl is

	component org2 is
  	port(
	i_A          	: in std_logic;
 	i_B          	: in std_logic;
       	o_F          	: out std_logic
	);
  	end component;

  	component andg2 is
  	port(
	i_A          	: in std_logic;
       	i_B          	: in std_logic;
       	o_F          	: out std_logic);
  	end component;

  	component invg is
  	port(
	i_A          	: in std_logic;
       	o_F       	: out std_logic);
  	end component;

	component mux2t1_N is
	generic(N : integer := 32);
	port(
	i_S          : in std_logic;
       	i_D0         : in std_logic_vector(N-1 downto 0);
       	i_D1         : in std_logic_vector(N-1 downto 0);
       	o_O          : out std_logic_vector(N-1 downto 0));
	end component;

	signal s_n_op0, s_n_op1, s_n_op2, s_n_f5, s_n_f1	: std_logic;
	signal s_and_and, s_and_or0, s_and_or1		: std_logic;
	signal s_and_mux0, s_and_mux1			: std_logic;
	signal s_mux0, s_mux1				: std_logic_vector(3 downto 0);

	begin
		

		g_not_op0 : invg
		port map(
		i_A	=> i_ALUOp(0),
		o_F	=> s_n_op0);

		g_not_op1 : invg
		port map(
		i_A	=> i_ALUOp(1),
		o_F	=> s_n_op1);

		g_not_op2 : invg
		port map(
		i_A	=> i_ALUOp(2),
		o_F	=> s_n_op2);

		g_not_f5 : invg
		port map(
		i_A	=> i_F(5),
		o_F	=> s_n_f5);

		g_not_f1 : invg
		port map(
		i_A	=> i_F(1),
		o_F	=> s_n_f1);
	
		g_and_o3 : andg2
		port map(
		i_A	=> i_ALUOp(0),
		i_B	=> s_n_op2,
		o_F	=> s_mux0(3));

		g_and_o2: andg2
		port map(
		i_A	=> i_ALUOp(2),
		i_B	=> i_ALUOp(0),
		o_F	=> s_mux0(2));	

		g_and_and: andg2
		port map(
		i_A	=> s_n_op2,
		i_B	=> i_ALUOp(1),
		o_F	=> s_and_and);

		g_and_or0: andg2
		port map(
		i_A	=> i_ALUOp(2),
		i_B	=> s_n_op1,
		o_F	=> s_and_or0);

		g_and_or1: andg2
		port map(
		i_A	=> s_and_and,
		i_B	=> i_ALUOp(0),
		o_F	=> s_and_or1);

		g_and_mux0 : andg2
		port map(
		i_A	=> s_n_op2,
		i_B	=> s_n_op1,
		o_F	=> s_and_mux0);

		g_and_mux1: andg2
		port map(
		i_A	=> s_n_op0,
		i_B	=> s_and_mux0,
		o_F	=> s_and_mux1);

		g_and_o0_1 : andg2
		port map(
		i_A	=> s_n_f5,
		i_B	=> i_F(0),
		o_F	=> s_mux1(0));

		g_and_o1_1: andg2
		port map(
		i_A	=> s_n_f5,
		i_B	=> s_n_f1,
		o_F	=> s_mux1(1));

		g_or_o1: org2
		port map(
		i_A	=> s_and_or0,
		i_B	=> s_and_or1,
		o_F	=> s_mux0(1));


		s_mux0(0) 	<= '1';		
		s_mux1(3)	<= '1';
		s_mux1(2)	<= s_n_f5;

		g_mux: mux2t1_N
		generic map(N => 4)
		port map(
		i_S	=> s_and_mux1,
		i_D0	=> s_mux0,
		i_D1	=> s_mux1,
		o_O	=> o_ALUOp);

		
		
end structure;