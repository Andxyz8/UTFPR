LIBRARY ieee;

USE ieee.std_logic_1164.all;

ENTITY or2_lr IS
	PORT (a, b: IN STD_LOGIC; z : OUT STD_LOGIC);
END or2_lr;

ARCHITECTURE LogicFunction OF or2_lr IS

BEGIN
	z <= '1' WHEN a = '1' OR b = '1' ELSE '0';

END LogicFunction;