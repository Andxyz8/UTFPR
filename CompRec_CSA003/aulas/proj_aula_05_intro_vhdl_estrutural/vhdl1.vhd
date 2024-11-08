LIBRARY ieee;

USE ieee.std_logic_1164.all;

ENTITY Vhdl1 IS
	PORT (x1, x2: IN STD_LOGIC; f: OUT STD_LOGIC);
END Vhdl1;


ARCHITECTURE LogicFunction OF Vhdl1 IS

COMPONENT not_lr
	PORT (
		a: IN STD_LOGIC;
		z: OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT and2_lr
	PORT (
		a, b: IN STD_LOGIC;
		z: OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT or2_lr
	PORT (
		a, b: IN STD_LOGIC;
		z: OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL aux1, aux2, aux3, aux4: STD_LOGIC;

BEGIN

	N1: not_lr PORT MAP (a => x1, z => aux2);
	N2: not_lr PORT MAP (a => x2, z => aux1);
	A1: and2_lr PORT MAP (a => x1, b => aux1, z => aux3);
	A2: and2_lr PORT MAP (a => x2, b => aux2, z => aux4);
	O1: or2_lr PORT MAP (a => aux3, b => aux4, z=> f);

END LogicFunction;