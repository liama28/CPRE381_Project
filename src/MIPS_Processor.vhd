-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity MIPS_Processor is
  generic(N : integer := 32);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

    --components

  component register_pc is 
    port(i_clk            : in std_logic;
         i_writeEn        : in std_logic;
         i_reset          : in std_logic;
         i_D              : in std_logic_vector(31 downto 0);
         o_D          	  : out std_logic_vector(31 downto 0));
  end component;

  component reg_file is
    port(i_RS		: in std_logic_vector(4 downto 0);
         i_RT		: in std_logic_vector(4 downto 0);
         i_RD		: in std_logic_vector(4 downto 0);
         i_D		: in std_logic_vector(31 downto 0);
         i_CLK		: in std_logic;
         i_reset	: in std_logic;
         i_WE		: in std_logic;
         o_RS		: out std_logic_vector(31 downto 0);
         o_RT		: out std_logic_vector(31 downto 0));
  end component;

  component pipelined_fetch_logic is
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
  end component;

  component extender is
    port(i_data      	: in std_logic_vector(15 downto 0);
         extend_with 	: in std_logic;
         o_data   	: out std_logic_vector(31 downto 0));
  end component;

  component control_logic is
     port(instruction   : in std_logic_vector(31 downto 0);
	o_Op           	: out std_logic_vector(3 downto 0);
	RegDst, beq, bne, jal, Jump, jr, MemtoReg, MemWr, ALUSrc, RegWr : out std_logic;
	o_sign, Halt, lui, shift : out std_logic); --, o_AorL, o_shift_LR, o_ALUorShift, o_up_imm
  end component;


  component ALU is
	port(
	i_A		: in std_logic_vector(31 downto 0);	-- 32-Bit operand A
       	i_B		: in std_logic_vector(31 downto 0);	-- 32-Bit operand B
       	i_ALUOP		: in std_logic_vector(3 downto 0);	-- 4-Bit ALU Operation Code 
       	o_F		: out std_logic_vector(31 downto 0);	-- 32-Bit Result ouput
       	o_CO		: out std_logic;			-- Carryout output
	o_OF		: out std_logic;			-- Overflow output
	o_Zero		: out std_logic);
  end component;


  -- signals
    signal s_dummy			: std_logic_vector(1 downto 0);
    --IF Data
    signal s_branchlogic_t_pcmux	: std_logic_vector(31 downto 0);
    signal s_pc4_adder_out		: std_logic_vector(31 downto 0);

    --ID Data
    signal s_ID_Inst			: std_logic_vector(31 downto 0); 
    signal s_ID_RS			: std_logic_vector(31 downto 0);
    signal s_ID_RT			: std_logic_vector(31 downto 0);    
    signal s_ID_extend_out		: std_logic_vector(31 downto 0);    
    signal s_ID_pc4			: std_logic_vector(31 downto 0);   

    --EX Data
    signal s_EX_Inst			: std_logic_vector(31 downto 0);
    signal s_EX_pc4			: std_logic_vector(31 downto 0);  
    signal s_EX_RS			: std_logic_vector(31 downto 0);
    signal s_EX_RT			: std_logic_vector(31 downto 0);  
    signal s_EX_shamt			: std_logic_vector(31 downto 0);
    signal s_EX_ALU_A_input		: std_logic_vector(31 downto 0);  
    signal s_EX_ALU_B_input		: std_logic_vector(31 downto 0);
    signal s_EX_extend_out		: std_logic_vector(31 downto 0);
    signal s_EX_ALU_Res			: std_logic_vector(31 downto 0);
    signal s_EX_LUI_Val			: std_logic_vector(31 downto 0);      
    signal s_EX_DMemAddr		: std_logic_vector(31 downto 0);
    signal s_EX_DMemData		: std_logic_vector(31 downto 0);
 
    --MEM Data
    signal s_MEM_Inst			: std_logic_vector(31 downto 0);
    signal s_MEM_pc4			: std_logic_vector(31 downto 0);

    --WB Data
    signal s_WB_Inst			: std_logic_vector(31 downto 0);
    signal s_WB_pc4			: std_logic_vector(31 downto 0);
    signal s_WB_DMemAddr		: std_logic_vector(31 downto 0);
    signal s_WB_DMemOut			: std_logic_vector(31 downto 0);
    signal s_DMemMux_t_JALDataMux	: std_logic_vector(31 downto 0);
    signal s_regDstMux_t_jalDstMux	: std_logic_vector(31 downto 0);


  -- Controls
    --ID controls
    signal s_JAL_ctrl		: std_logic;
    signal s_regDst_ctrl	: std_logic;
    signal s_MemtoReg_ctrl	: std_logic;
    signal s_lui		: std_logic;
    signal s_ALUSrc_ctrl	: std_logic;
    signal s_ALUOp		: std_logic_vector(3 downto 0);
    signal s_shift		: std_logic;

    signal s_extend_ctrl	: std_logic;
    signal s_jump		: std_logic;
    signal s_jr			: std_logic;
    signal s_branch		: std_logic;
    signal s_beq		: std_logic;
    signal s_bne		: std_logic;
    signal s_zero		: std_logic;
    signal s_carryout		: std_logic;

    --EX controls
    signal s_EX_JAL_ctrl	: std_logic;
    signal s_EX_regDst_ctrl	: std_logic;
    signal s_EX_MemtoReg_ctrl	: std_logic;
    signal s_EX_MemWr		: std_logic;
    signal s_EX_lui		: std_logic;
    signal s_EX_ALUSrc_ctrl	: std_logic;
    signal s_EX_ALUOp		: std_logic_vector(3 downto 0);
    signal s_EX_shift		: std_logic;

    --MEM controls
    signal s_MEM_JAL_ctrl	: std_logic;
    signal s_MEM_regDst_ctrl	: std_logic;
    signal s_MEM_MemtoReg_ctrl	: std_logic;
    --signal s_DMemWr		: std_logic; Already declared above?

    --WB controls 
    signal s_WB_JAL_ctrl	: std_logic;
    signal s_WB_regDst_ctrl	: std_logic;
    signal s_WB_MemtoReg_ctrl	: std_logic;


begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;

--IF---------------------------------------------------------------------

  pcmux: mux2t1_N
    generic map(N => 5)
    port Map(i_s   		=> s_jump,
	     i_D0  		=> s_pc4_adder_out,
	     i_D1  		=> s_branchlogic_t_pcmux,
	     o_O   		=> s_pcmux_t_pc);
  
  pc: register_pc
    port Map(i_clk   	=> i_CLK,
	     i_writeEn  => '1',
	     i_reset  	=> i_RST,
	     i_D  	=> s_iFiD_t_pcmux,
	     o_D   	=> s_NextInstAddr);
  --o_pc <= s_pc_O;

  IMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);

  adder_pc_4: adder_ripple_carry_N
    port MAP(i_D0   => s_NextInstAddr,
	     i_D1   => x"00000004",
	     i_cin  => '0',
	     o_sum  => s_pc4_adder_out,
	     o_cout => s_dummy(0));

--IF/ID Reg--------------------------------------------------------------



--ID---------------------------------------------------------------------

   controlLogic: control_logic
    port Map(instruction	=> s_ID_Inst,
             o_Op		=> s_ALUOp,
             RegDst	 	=> s_regDst_ctrl,
             beq	 	=> s_beq,    
             bne		=> s_bne,
             Jump		=> s_jump,
	     Halt		=> s_Halt,
             jr			=> s_jr,
	     jal		=> s_JAL_ctrl,
             MemtoReg	 	=> s_MemtoReg_ctrl,
             MemWr		=> s_DMemWr,
             ALUSrc		=> s_ALUSrc_ctrl,
             RegWr		=> s_RegWr,
             o_sign		=> s_extend_ctrl,
   	     shift		=> s_shift,
	     lui		=> s_lui);

   ext: extender 
    port MAP(i_data      	=> s_ID_Inst(15 downto 0),
             extend_with 	=> s_extend_ctrl,
             o_data   		=> s_ID_extend_out);

   fetchLogic: pipelined_fetch_logic
    port Map(i_jump_amt		=> s_ID_extend_out,
             i_rs		=> s_ID_RS,
	     i_pc_plus4		=> s_ID_pc4,
             i_imem		=> s_ID_Inst(25 downto 0),
             i_jump	 	=> s_jump,
             i_jr	 	=> s_jr,
             i_beq		=> s_beq,
             i_bne		=> s_bne,
             i_zero	 	=> s_zero,
             i_CLK		=> iCLK,
             i_RST		=> iRST,
             o_pc		=> s_branchlogic_t_pcmux);

   regFile: reg_file
    port Map(i_RS		=> s_ID_Inst(25 downto 21),
             i_RT		=> s_ID_Inst(20 downto 16),
             i_RD		=> s_RegWrAddr,
             i_D		=> s_RegWrData,
             i_CLK		=> iCLK,
             i_reset		=> iRST,
             i_WE		=> s_RegWr,
             o_RS		=> s_ID_RS,
             o_RT		=> s_ID_RT);

   s_zero <= "1" when (s_ID_RS = s_ID_RT) else "0";

--ID/EX Reg--------------------------------------------------------------



--EX---------------------------------------------------------------------

  s_EX_shamt <= "000000000000000000000000000" & s_EX_Inst(10 downto 6);

  shiftMux: mux2t1_N
    generic map(N => 32)
    port Map(i_s   		=> s_EX_shift,
	     i_D0  		=> s_EX_RS,
	     i_D1  		=> s_EX_shamt,
	     o_O   		=> s_EX_ALU_A_input);


  ALUSrcMux: mux2t1_N
    generic map(N => 32)
    port Map(i_s   		=> s_EX_ALUSrc_ctrl,
	     i_D0  		=> s_EX_RT,
	     i_D1  		=> s_EX_extend_out,
	     o_O   		=> s_EX_ALU_B_input);

  alu_unit: ALU
    port Map(i_A   		=> s_EX_ALU_A_input,
	     i_B  		=> s_EX_ALU_B_input,
	     i_ALUOP  		=> s_EX_ALUOp,
	     o_F  		=> s_EX_ALU_Res,
	     o_CO  		=> s_dummy(0),
	     o_OF  		=> s_Ovfl,
	     o_Zero   		=> );

   s_EX_LUI_Val <= s_EX_Inst(15 downto 0) & x"0000";

   luiMux: mux2t1_N
    generic map(N => 32)
    port Map(i_s   		=> s_EX_lui,
	     i_D0  		=> s_EX_ALU_Res,
	     i_D1  		=> s_EX_LUI_Val,
	     o_O   		=> s_EX_DMemAddr);

   s_EX_DMemData <= s_EX_RT;


--EX/MEM Reg--------------------------------------------------------------



--MEM---------------------------------------------------------------------
  
DMem: mem
    generic map(ADDR_WIDTH => 10,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

--MEM/WB Reg--------------------------------------------------------------



--WB----------------------------------------------------------------------

  dMemMux: mux2t1_N
    generic map(N => 32)
    port Map(i_s   		=> s_WB_MemtoReg_ctrl,
	     i_D0  		=> s_WB_DMemAddr,
	     i_D1  		=> s_WB_DMemOut,
	     o_O   		=> s_DMemMux_t_JALDataMux);

  jalDataMux: mux2t1_N
    generic map(N => 32)
    port Map(i_s   		=> s_WB_JAL_ctrl,
	     i_D0  		=> s_DMemMux_t_JALDataMux,
	     i_D1  		=> s_WB_pc4,
	     o_O   		=> s_RegWrData);

  regDstMux: mux2t1_N
    generic map(N => 5)
    port Map(i_s   		=> s_WB_regDst_ctrl,
	     i_D0  		=> s_WB_Inst(20 downto 16),
	     i_D1  		=> s_WB_Inst(15 downto 11),
	     o_O   		=> s_regDstMux_t_jalDstMux);

  jalDstMux: mux2t1_N
    generic map(N => 5)
    port Map(i_s   		=> s_WB_JAL_ctrl,
	     i_D0  		=> s_regDstMux_t_jalDstMux,
	     i_D1  		=> "11111",
	     o_O   		=> s_RegWrAddr);


  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 

end structure;

