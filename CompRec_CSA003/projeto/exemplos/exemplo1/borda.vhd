
-- cria borda em 640*480


LIBRARY ieee;
USE ieee.std_logic_1164.all; 


ENTITY borda IS 
	PORT
	(
		coluna :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		linha :  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		a :  OUT  STD_LOGIC
	);
END borda;

ARCHITECTURE borda OF borda IS 
begin

process (coluna, linha)
begin
if (((coluna = 10d"10" or coluna = 10d"630") and (linha > 10d"10" and linha < 10d"470"))  or ((linha = 10d"10" or linha = 10d"470") and (coluna > 10d"10" and coluna < 10d"630"))) then a <= '1';
elsif (((coluna = 10d"15" or coluna = 10d"625") and (linha > 10d"15" and linha < 10d"465"))  or ((linha = 10d"15" or linha = 10d"465") and (coluna > 10d"15" and coluna < 10d"625"))) then a <= '1';
else  a <= '0';
end if;

end process;

END borda;