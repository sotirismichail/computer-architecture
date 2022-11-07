library IEEE;
use IEEE.STD_LOGIC_1164.all;

package array_32bit is
	type array_32bit is array (0 to 31) of std_logic_vector (31 downto 0);
end array_32bit;