LIBRARY ieee;

USE ieee.std_logic_1164.all;

ENTITY and2_lr IS
	PORT (a, b: IN STD_LOGIC; z : OUT STD_LOGIC);
END and2_lr;

ARCHITECTURE LogicFunction OF and2_lr IS

BEGIN
	z <= '1' WHEN a = '1' AND b = '1' ELSE '0';

END LogicFunction;