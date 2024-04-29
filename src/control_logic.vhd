-- Quartus Prime VHDL Template
-- Single-port RAM with single read/write address

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_logic is

	

	port 
	(
		instruction     : in std_logic_vector(31 downto 0);
		RegDst		: out std_logic;
		Jump		: out std_logic;
		--Branch		: out std_logic;
		MemtoReg	: out std_logic;
		MemWr		: out std_logic;
		bne		: out std_logic;
		beq		: out std_logic;
		o_Op		: out std_logic_vector(3 downto 0);
		ALUSrc		: out std_logic;
                --s_LR            : out std_logic;
                --s_LA            : out std_logic;
                --s_amt           : out std_logic_vector(4 downto 0);
		RegWr		: out std_logic;
		o_sign		: out std_logic;
		jal		: out std_logic;
		jr		: out std_logic;
		Halt		: out std_logic;
		lui		: out std_logic;
		shift		: out std_logic
	);

end control_logic;



architecture mixed of control_logic is

	signal opCode : std_logic_vector(31 downto 26);
	signal func : std_logic_vector(5 downto 0);
        signal samt : std_logic_vector(4 downto 0);  

begin
	opCode <= instruction(31 downto 26);
	func <= instruction(5 downto 0);
        samt <= instruction(10 downto 6);
	--repl_qb <= instruction(23 downto 16);

	process(opCode, func) is
	begin
	if opCode = "000000" then  -- R format
		if func = "100000" then --ADD
			ALUSrc <= '0';
			o_Op <= "1000";
			MemtoReg <= '0';
			MemWr <= '0';
			RegWr <= '1';
			RegDst <= '1';
			Jump <= '0';
			--Branch <= '0';
			o_sign <= '1';
			Halt <= '0';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jr <= '0';
			lui <= '0';
			shift <= '0';

		elsif func = "100001" then --ADDU
			ALUSrc <= '0';
			o_Op <= "1000";
			MemtoReg <= '0';
			MemWr <= '0';
			RegWr <= '1';
			RegDst <= '1';
			Jump <= '0';
			--Branch <= '0';
			o_sign <= '0';
			Halt <= '0';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jr <= '0';
			lui <= '0';
			shift <= '0';

		elsif func = "100010" then --SUB
			ALUSrc <= '0';
			o_Op <= "1001";
			MemtoReg <= '0';
			MemWr <= '0';
			RegWr <= '1';
			RegDst <= '1';
		        Jump <= '0';
			--Branch <= '0';
			o_sign <= '1';
			Halt <= '0';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jr <= '0';
			lui <= '0';
			shift <= '0';

		elsif func = "100011" then --SUBU
			ALUSrc <= '0';
			o_Op <= "1001";
			MemtoReg <= '0';
			MemWr <= '0';
			RegWr <= '1';
			RegDst <= '1';
			Jump <= '0';
			--Branch <= '0';
			o_sign <= '0';
			Halt <= '0';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jr <= '0';
			lui <= '0';
			shift <= '0';

		elsif func = "100100" then --AND
			ALUSrc <= '0';
			o_Op <= "0000";
			MemtoReg <= '0';
			MemWr <= '0';
			RegWr <= '1';
			RegDst <= '1';
			Jump <= '0';
			--Branch <= '0';
			o_sign <= '0';
			Halt <= '0';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jr <= '0';
			lui <= '0';
			shift <= '0';

		elsif func = "100111" then --NOR
			ALUSrc <= '0';
			o_Op <= "0100";
			MemtoReg <= '0';
			MemWr <= '0';
			RegWr <= '1';
			RegDst <= '1';
			Jump <= '0';
			--Branch <= '0';
			o_sign <= '0';
			Halt <= '0';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jr <= '0';
			lui <= '0';
			shift <= '0';

		elsif func = "100110" then --XOR
			ALUSrc <= '0';
			o_Op <= "0111";
			MemtoReg <= '0';
			MemWr <= '0';
			RegWr <= '1';
			RegDst <= '1';
			Jump <= '0';
			--Branch <= '0';
			o_sign <= '0';
			Halt <= '0';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jr <= '0';
			lui <= '0';
			shift <= '0';

		elsif func = "100101" then --OR
			ALUSrc <= '0';
			o_Op <= "0011";
			MemtoReg <= '0';
			MemWr <= '0';
			RegWr <= '1';
			RegDst <= '1';
			Jump <= '0';
			--Branch <= '0';
			o_sign <= '0';
			Halt <= '0';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jr <= '0';
			lui <= '0';
			shift <= '0';

		elsif func = "101010" then --SLT
			ALUSrc <= '0';
			o_Op <= "1011";
			MemtoReg <= '0';
			MemWr <= '0';
			RegWr <= '1';
			RegDst <= '1';
			Jump <= '0';
			--Branch <= '0';
			o_sign <= '1';
			Halt <= '0';
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jr <= '0';
			lui <= '0';
			shift <= '0';

		elsif func = "000000" then --SLL
			ALUSrc <= '0';
			o_Op <= "1110"; 
			MemtoReg <= '0';
			MemWr <= '0';
			RegWr <= '1';
			RegDst <= '1';
			Jump <= '0';
			--Branch <= '0';
			o_sign <= '0';
			Halt <= '0';
                        --s_LR <= '0';
                        --s_LA <= '0';
                        --s_amt <= samt;
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jr <= '0';
			lui <= '0';
			shift <= '1';
		
		elsif func = "000011" then --SRA
			ALUSrc <= '0';
			o_Op <= "1101";
			MemtoReg <= '0';
			MemWr <= '0';
			RegWr <= '1';
			RegDst <= '1';
			Jump <= '0';
			--Branch <= '0';
			o_sign <= '0';
			Halt <= '0';
                        --s_LR <= '1';
                        --s_LA <= '1';
                        --s_amt <= samt;
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jr <= '0';
			lui <= '0';
			shift <= '1';

		elsif func = "000010" then --SRL
			ALUSrc <= '0';
			o_Op <= "1100"; -- change
			MemtoReg <= '0';
			MemWr <= '0';
			RegWr <= '1';
			RegDst <= '1';
			Jump <= '0';
			--Branch <= '0';
			o_sign <= '0';
			Halt <= '0';
                        --s_LR <= '1';
                        --s_LA <= '0';
                        --s_amt <= samt;
			beq <= '0';
			bne <= '0';
			jal <= '0';
			jr <= '0';
			lui <= '0';
			shift <= '1';

		elsif func = "001000" then --JR
			ALUSrc <= '0';
			o_Op <= "1000";
			MemtoReg <= 'X';
			MemWr <= '0';
			RegWr <= '0';
			RegDst <= 'X';
			Jump <= '1';
			--Branch <= 'X';
			o_sign <= 'X';
			Halt <= '0';
                        --s_LR <= 'X';
                        --s_LA <= 'X';
                        --s_amt <= samt;
			beq <= 'X';
			bne <= 'X';
			jal <= '0';
			jr <= '1';
			lui <= '0';
			shift <= '0';

		end if;
		
		
	elsif opCode = "000010" then --J
		ALUSrc <= 'X';
		o_Op <= "1000";
		MemtoReg <= '0';
		MemWr <= '0';
		RegWr <= '0';
		RegDst <= '0';
		Jump <= '1';
		--Branch <= '0';
		o_sign <= '0';
		Halt <= '0';
		beq <= '0';
		bne <= '0';
		jal <= '0';
		jr <= '0';
		lui <= '0';
		shift <= '0';

	elsif opCode = "000011" then --JAL
		o_Op <= "1000";
		ALUSrc <= 'X';		
		MemtoReg <= '0';
		MemWr <= '0';
		RegWr <= '1';
		RegDst <= '0';
		Jump <= '1';
		--Branch <= '0';
		o_sign <= '0';
		Halt <= '0';
		beq <= '0';
		bne <= '0';
		jal <= '1';
		jr <= '0';
		lui <= '0';
		shift <= '0';

	elsif opCode = "001000" then --ADDI
		ALUSrc <= '1';
		o_Op <= "1000";
		MemtoReg <= '0';
		MemWr <= '0';
		RegWr <= '1';
		RegDst <= '0';
		Jump <= '0';
		--Branch <= '0';
		o_sign <= '1';
		Halt <= '0';
		beq <= '0';
		bne <= '0';
		jal <= '0';
		jr <= '0';
		lui <= '0';
		shift <= '0';

	elsif opCode = "001001" then --ADDIU
		ALUSrc <= '1';
		o_Op <= "1000";
		MemtoReg <= '0';
		MemWr <= '0';
		RegWr <= '1';
		RegDst <= '0';
		Jump <= '0';
		--Branch <= '0';
		o_sign <= '1';
		Halt <= '0';
		beq <= '0';
		bne <= '0';
		jal <= '0';
		jr <= '0';
		lui <= '0';
		shift <= '0';

	elsif opCode = "001100" then --ANDI
		ALUSrc <= '1';
		o_Op <= "0000";
		MemtoReg <= '0';
		MemWr <= '0';
		RegWr <= '1';
		RegDst <= '0';
		Jump <= '0';
		--Branch <= '0';
		o_sign <= '0';
		Halt <= '0';
		beq <= '0';
		bne <= '0';
		jal <= '0';
		jr <= '0';
		lui <= '0';
		shift <= '0';

	elsif opCode = "001111" then --LUI
		ALUSrc <= '1';
		o_Op <= "1000";
		MemtoReg <= '0';
		MemWr <= '0';
		RegWr <= '1';
		RegDst <= '0';
		Jump <= '0';
		--Branch <= '0';
		o_sign <= '0';
		Halt <= '0';
		beq <= '0';
		bne <= '0';
		jal <= '0';
		jr <= '0';
		lui <= '1';
		shift <= '0';
	
	elsif opCode = "100011" then --LW
		ALUSrc <= '1';
		o_Op <= "1000";
		MemtoReg <= '1';
		MemWr <= '0';
		RegWr <= '1';
		RegDst <= '0';
		Jump <= '0';
		--Branch <= '0';
		o_sign <= '1';
		Halt <= '0';
		beq <= '0';
		bne <= '0';
		jal <= '0';
		jr <= '0';
		lui <= '0';
		shift <= '0';

	elsif opCode = "001110" then --XORI
		ALUSrc <= '1';
		o_Op <= "0111";
		MemtoReg <= '0';
		MemWr <= '0';
		RegWr <= '1';
		RegDst <= '0';
		Jump <= '0';
		--Branch <= '0';
		o_sign <= '0';
		Halt <= '0';
		beq <= '0';
		bne <= '0';
		jal <= '0';
		jr <= '0';
		lui <= '0';
		shift <= '0';

	elsif opCode = "001101" then --ORI
		ALUSrc <= '1';
		o_Op <= "0011";
		MemtoReg <= '0';
		MemWr <= '0';
		RegWr <= '1';
		RegDst <= '0';
		Jump <= '0';
		--Branch <= '0';
		o_sign <= '0';
		Halt <= '0';
		beq <= '0';
		bne <= '0';
		jal <= '0';
		jr <= '0';
		lui <= '0';
		shift <= '0';

	elsif opCode = "001010" then --SLTI
		ALUSrc <= '1';
		o_Op <= "1011";
		MemtoReg <= '0';
		MemWr <= '0';
		RegWr <= '1';
		RegDst <= '0';
		Jump <= '0';
		--Branch <= '0';
		o_sign <= '1';
		Halt <= '0';
		beq <= '0';
		bne <= '0';
		jal <= '0';
		jr <= '0';
		lui <= '0';
		shift <= '0';

	elsif opCode = "101011" then --SW
		ALUSrc <= '1';
		o_Op <= "1000";
		MemtoReg <= '0';
		MemWr <= '1';
		RegWr <= '0';
		RegDst <= '0';
		Jump <= '0';
		--Branch <= '0';
		o_sign <= '1';
		Halt <= '0';
		beq <= '0';
		bne <= '0';
		jal <= '0';
		jr <= '0';
		lui <= '0';
		shift <= '0';

	elsif opCode = "000100" then --BEQ
		ALUSrc <= '0'; -- Changed from 1 to 0; 
		o_Op <= "1001";
		MemtoReg <= '0';
		MemWr <= '0';
		RegWr <= '0';
		RegDst <= '0';
		Jump <= '0';
		--Branch <= '1';
		o_sign <= '1';
		Halt <= '0';
		beq <= '1';
		bne <= '0';
		jal <= '0';
		jr <= '0';
		lui <= '0';
		shift <= '0';

	elsif opCode = "000101" then --BNE
		ALUSrc <= '0';
		o_Op <= "1001";
		MemtoReg <= '0';
		MemWr <= '0';
		RegWr <= '0';
		RegDst <= '0';
		Jump <= '0';
		--Branch <= '1';
		o_sign <= '1';
		Halt <= '0';
		beq <= '0';
		bne <= '1';
		jal <= '0';
		jr <= '0';
		lui <= '0';
		shift <= '0';

	elsif opCode = "010100" then --HALT
		ALUSrc <= '1';
		o_Op <= "1000"; -- change
		MemtoReg <= '0';
		MemWr <= '0';
		RegWr <= '0';
		RegDst <= '0';
		Jump <= '0';
		--Branch <= '1';
		o_sign <= '1';
		Halt <= '1';
		beq <= '0';
		bne <= '0';
		jal <= '0';
		jr <= '0';
		lui <= '0';
		shift <= '0';

	end if;
	end process;

end mixed;
