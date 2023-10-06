library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Combiner_v1_0 is
	generic (
	   C_OUTPUT_WIDTH : integer range 1 to 16 := 4
	);
	port (
	   b0 : in std_logic;
	   b1 : in std_logic;
	   b2 : in std_logic;
	   b3 : in std_logic;
	   b4 : in std_logic;
	   b5 : in std_logic;
	   b6 : in std_logic;
	   b7 : in std_logic;
	   b8 : in std_logic;
	   b9 : in std_logic;
	   b10 : in std_logic;
	   b11 : in std_logic;
	   b12 : in std_logic;
	   b13 : in std_logic;
	   b14 : in std_logic;
	   b15 : in std_logic;
	   b16 : in std_logic;
	   dout : out std_logic_vector(C_OUTPUT_WIDTH - 1 downto 0) := (others => '0')
	);
end Combiner_v1_0;

architecture arch_imp of Combiner_v1_0 is

signal outval : std_logic_vector(15 downto 0);
	-- component declaration
begin
    outval(0) <= b0;
    outval(1) <= b1;
    outval(2) <= b2;
    outval(3) <= b3;
    outval(4) <= b4;
    outval(5) <= b5;
    outval(6) <= b6;
    outval(7) <= b7;
    outval(8) <= b8;
    outval(9) <= b9;
    outval(10) <= b10;
    outval(11) <= b11;
    outval(12) <= b12;
    outval(13) <= b13;
    outval(14) <= b14;
    outval(15) <= b15;
    
	-- Add user logic here
    dout <= outval(C_OUTPUT_WIDTH-1 downto 0);
	-- User logic ends

end arch_imp;
