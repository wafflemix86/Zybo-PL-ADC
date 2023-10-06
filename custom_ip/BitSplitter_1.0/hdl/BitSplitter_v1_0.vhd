library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Splitter_v1_0 is
	generic (
	   C_INPUT_WIDTH : integer range 1 to 16 := 4
	);
	port (
	   b0 : out std_logic := '0';
	   b1 : out std_logic := '0';
	   b2 : out std_logic := '0';
	   b3 : out std_logic := '0';
	   b4 : out std_logic := '0';
	   b5 : out std_logic := '0';
	   b6 : out std_logic := '0';
	   b7 : out std_logic := '0';
	   b8 : out std_logic := '0';
	   b9 : out std_logic := '0';
	   b10 : out std_logic := '0';
	   b11 : out std_logic := '0';
	   b12 : out std_logic := '0';
	   b13 : out std_logic := '0';
	   b14 : out std_logic := '0';
	   b15 : out std_logic := '0';
	   din : in std_logic_vector(C_INPUT_WIDTH - 1 downto 0)
	);
end Splitter_v1_0;

architecture arch_imp of Splitter_v1_0 is

signal inval : std_logic_vector(15 downto 0) := (others => '0');
	-- component declaration
begin
    b0 <= inval(0);
    b1 <= inval(1);
    b2 <= inval(2);
    b3 <= inval(3);
    b4 <= inval(4);
    b5 <= inval(5);
    b6 <= inval(6);
    b7 <= inval(7);
    b8 <= inval(8);
    b9 <= inval(9);
    b10 <= inval(10);
    b11 <= inval(11);
    b12 <= inval(12);
    b13 <= inval(13);
    b14 <= inval(14);
    b15 <= inval(15);
    
	-- Add user logic here
    inval(C_INPUT_WIDTH - 1 downto 0) <= din(C_INPUT_WIDTH - 1 downto 0);
	-- User logic ends

end arch_imp;
