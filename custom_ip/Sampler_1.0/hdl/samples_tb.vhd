----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/06/2023 12:18:55 PM
-- Design Name: 
-- Module Name: samples_tb - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity samples_tb is
--  Port ( );
end samples_tb;

architecture Behavioral of samples_tb is

component Sampler_v1_0 is
	generic (
	   C_OUT_WIDTH : integer := 6;
	   C_AVG_COUNT : integer := 16
	);
	port (
		daddr_out     : out std_logic_vector(6 downto 0);
		den_out       : out std_logic;
		di_out        : out std_logic_vector(15 downto 0);
		do_in         : in std_logic_vector(15 downto 0);
		drdy_in       : in std_logic;
		dwe_out       : out std_logic;
		
		channel_in    : in std_logic_vector(4 downto 0);
		eoc_in        : in std_logic;
		alarm_in      : in std_logic;
		eos_in        : in std_logic;
		busy_in       : in std_logic;
		
		dclk_in       : in std_logic;
		rst_in        : in std_logic;
		
		outputreg : out std_logic_vector(C_OUT_WIDTH - 1 downto 0)
		
	);
	
    
end component Sampler_v1_0;


constant C_T_CLK_PERIOD_NS         : time := (1000000000 / 130000000) * 1 ns;
constant C_T_CLK_HALF_NS         : time := (C_T_CLK_PERIOD_NS / 2);
constant C_TB_OUT_WIDTH     : integer := 6;
constant C_TB_AVG_COUNT     : integer := 64;

signal s_daddr_out          : std_logic_vector(6 downto 0);
signal s_den_out            : std_logic;
signal s_di_out             : std_logic_vector(15 downto 0);
signal s_do_in              : std_logic_vector(15 downto 0);
signal s_drdy_in            : std_logic := '0';
signal s_dwe_out            : std_logic;

signal s_channel_in         : std_logic_vector(4 downto 0);
signal s_eoc_in             : std_logic;
signal s_alarm_in           : std_logic;
signal s_eos_in             : std_logic;
signal s_busy_in            : std_logic := '1';

signal s_dclk_in            : std_logic := '1';
signal s_rst_in             : std_logic := '1';

signal s_outputreg          : std_logic_vector(C_TB_OUT_WIDTH - 1 downto 0);

signal clk_counter : integer := 0;
signal sample_counter : integer := 0;
signal dataout : std_logic_vector(11 downto 0) := (others => '0');

constant C_ARRAY_SIZE : integer := 16;
type samplearray is array(0 to C_ARRAY_SIZE-1) of integer;
function initsamplearray return samplearray is
    variable asdf : samplearray;
begin
    for i in 0 to (C_ARRAY_SIZE/2) -1 loop
        asdf(i) := i*10;
    end loop;
    for i in (C_ARRAY_SIZE/2) to  C_ARRAY_SIZE-1 loop
        asdf(i) := (C_ARRAY_SIZE - i)*10;
    end loop;
    return asdf;
end function initsamplearray;

signal mysamples : samplearray := initsamplearray;




begin

dut : Sampler_v1_0
    generic map(
        C_OUT_WIDTH => C_TB_OUT_WIDTH,
        C_AVG_COUNT => C_TB_AVG_COUNT
    )
    port map(
        daddr_out  => s_daddr_out,  
        den_out    => s_den_out,
        di_out     => s_di_out,     
        do_in      => s_do_in,      
        drdy_in    => s_drdy_in,    
        dwe_out    => s_dwe_out,   
        channel_in => s_channel_in,
        eoc_in     => s_eoc_in,     
        alarm_in   => s_alarm_in,   
        eos_in     => s_eos_in,     
        busy_in    => s_busy_in,   
        dclk_in    => s_dclk_in,    
        rst_in     => s_rst_in     
);


-- roughly 130mhz clock
s_dclk_in <= not s_dclk_in after C_T_CLK_HALF_NS;
s_rst_in <= '0' after 10*C_T_CLK_PERIOD_NS;
dataout <= std_logic_vector(to_unsigned(mysamples(sample_counter),dataout'length));
s_do_in(15 downto 4) <= dataout;

shit:process(s_dclk_in)

begin
    
    if rising_edge(s_dclk_in) and s_rst_in = '0' then
        clk_counter <= clk_counter + 1;
        if clk_counter mod 130 = 0 then
            sample_counter <= (sample_counter + 1) mod C_ARRAY_SIZE;
            s_drdy_in <= '1';
        else
            s_drdy_in <= '0';
        end if;
        
    end if;

end process shit;


end Behavioral;
