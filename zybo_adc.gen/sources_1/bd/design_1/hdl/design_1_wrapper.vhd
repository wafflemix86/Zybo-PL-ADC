--Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2021.2 (win64) Build 3367213 Tue Oct 19 02:48:09 MDT 2021
--Date        : Fri Oct 13 13:06:03 2023
--Host        : DESKTOP-7RJTUE9 running 64-bit major release  (build 9200)
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
  port (
    clk : in STD_LOGIC;
    ja_n : in STD_LOGIC_VECTOR ( 0 to 0 );
    ja_p : in STD_LOGIC_VECTOR ( 0 to 0 );
    jb_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    reset_switch : in STD_LOGIC;
    vga_g : out STD_LOGIC_VECTOR ( 5 downto 0 );
    vn : in STD_LOGIC_VECTOR ( 0 to 0 );
    vp : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    clk : in STD_LOGIC;
    vga_g : out STD_LOGIC_VECTOR ( 5 downto 0 );
    reset_switch : in STD_LOGIC;
    ja_p : in STD_LOGIC_VECTOR ( 0 to 0 );
    ja_n : in STD_LOGIC_VECTOR ( 0 to 0 );
    jb_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    vp : in STD_LOGIC_VECTOR ( 0 to 0 );
    vn : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component design_1;
begin
design_1_i: component design_1
     port map (
      clk => clk,
      ja_n(0) => ja_n(0),
      ja_p(0) => ja_p(0),
      jb_p(0) => jb_p(0),
      reset_switch => reset_switch,
      vga_g(5 downto 0) => vga_g(5 downto 0),
      vn(0) => vn(0),
      vp(0) => vp(0)
    );
end STRUCTURE;
