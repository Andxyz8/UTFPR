
-- cria borda em 640*480


LIBRARY ieee;
USE ieee.std_logic_1164.all; 


ENTITY reta IS 
	PORT
	(
		coluna :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		linha :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		
		a :  OUT  STD_LOGIC
	);
END reta;

ARCHITECTURE reta OF reta IS 
begin

process (coluna, linha)
begin

if (linha > 10d"20" and linha < 10d"460") then 
if (coluna = linha) then a<='1';
else  a <= '0';
end if;
end if;


end process;

END reta;