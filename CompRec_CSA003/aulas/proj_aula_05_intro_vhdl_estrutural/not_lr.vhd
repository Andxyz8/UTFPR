LIBRARY ieee;

USE ieee.std_logic_1164.all;

ENTITY not_lr IS
	PORT (
		a: IN STD_LOGIC;
		z : OUT STD_LOGIC
	);
END not_lr;

ARCHITECTURE LogicFunction OF not_lr IS

BEGIN
	z <= NOT a;
END LogicFunction;