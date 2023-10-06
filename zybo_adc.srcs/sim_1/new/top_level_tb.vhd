----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/02/2023 04:24:32 PM
-- Design Name: 
-- Module Name: top_level_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level_tb is
--  Port ( );
end top_level_tb;



architecture Behavioral of top_level_tb is

constant CLK_PERIOD_NS         : time := (1000000000 / 130000000) * 1 ns;

component design_1 is
  port (
    btn : in STD_LOGIC_VECTOR ( 3 downto 0 );
    clk : in STD_LOGIC;
    ja_n : in STD_LOGIC_VECTOR ( 0 to 0 );
    ja_p : in STD_LOGIC_VECTOR ( 0 to 0 );
    jb_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    led : out STD_LOGIC_VECTOR ( 3 downto 0 );
    reset_switch : in STD_LOGIC;
    vga_g : out STD_LOGIC_VECTOR ( 5 downto 0 );
    vn : in STD_LOGIC_VECTOR ( 0 to 0 );
    vp : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end component design_1;


   signal s_btn :  STD_LOGIC_VECTOR ( 3 downto 0 ) := (others => '0');
   signal s_clk :  STD_LOGIC := '0';
   signal s_ja_n :  STD_LOGIC_VECTOR ( 0 to 0 );
   signal s_ja_p :  STD_LOGIC_VECTOR ( 0 to 0 );
   signal s_jb_p :  STD_LOGIC_VECTOR ( 0 to 0 );
   signal s_led :  STD_LOGIC_VECTOR ( 3 downto 0 );
   signal s_reset_switch :  STD_LOGIC := '1';
   signal s_vga_g :  STD_LOGIC_VECTOR ( 5 downto 0 );

begin

design_1_inst : design_1
port map(
    btn => s_btn,
    clk => s_clk,
    ja_n => s_ja_n,
    ja_p => s_ja_p,
    jb_p => s_jb_p,
    led => s_led,
    reset_switch => s_reset_switch,
    vga_g => s_vga_g,
    vn => (others => '0'),
    vp => (others => '0')
);

s_clk <= (not s_clk) after (CLK_PERIOD_NS/2);

s_reset_switch <= '0' after 800*CLK_PERIOD_NS;
s_ja_n <= (others => '0');
s_ja_p <= (others => '0');

end Behavioral;
