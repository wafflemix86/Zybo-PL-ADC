library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

entity Sampler_v1_0 is
	generic (
	   C_OUT_WIDTH : integer := 12;
	   C_AVG_COUNT : integer := 16
	);
	port (
		daddr_out : out std_logic_vector(6 downto 0);
		den_out : out std_logic;
		di_out : out std_logic_vector(15 downto 0);
		do_in : in std_logic_vector(15 downto 0);
		drdy_in : in std_logic;
		dwe_out : out std_logic;
		
		channel_in : in std_logic_vector(4 downto 0);
		eoc_in : in std_logic;
--		alarm_in: in std_logic;
--		eos_in : in std_logic;
		busy_in : in std_logic;
		
		dclk_in : in std_logic;
		rst_in : in std_logic;
		
		outputreg : out std_logic_vector(C_OUT_WIDTH - 1 downto 0);
		drdy_out : out std_logic
		
	);
	
    
end Sampler_v1_0;




architecture arch_imp of Sampler_v1_0 is

    constant C_MAX_NUM_BITS : integer := integer(ceil(log2(real(C_AVG_COUNT * ((2**12) - 1) ))));
    constant C_AVG_SHIFT : integer := integer(log2(real(C_AVG_COUNT)));

    type SM_STATE is (RESET_HIGH,WAIT_BUSY, WAIT_DRDY_P, WAIT_EOC_P, WAIT_EOC);
    type AVG_SM_STATE is (AVG_RESET, AVG_IDLE, AVG_ADD, AVG_SUB, AVG_DIV, AVG_CONVERT, AVG_WRITE);
    signal AVG_STATE : AVG_SM_STATE := AVG_RESET;
    signal STATE : SM_STATE := RESET_HIGH;

    signal daddr:  std_logic_vector(6 downto 0) := (others => '0');
    signal den:  std_logic := '0';
    signal di:  std_logic_vector(15 downto 0) := (others => '0');
    signal drdy:  std_logic := '0';
    signal dwe:  std_logic := '0';
    signal channel:  std_logic_vector(4 downto 0);
    signal eoc:  std_logic;
--    signal alarm:  std_logic;
--    signal eos:  std_logic;
    signal busy:  std_logic;
    signal dclk:  std_logic;

    signal reset : std_logic := '1';

    type samplebuffer is array(0 to C_AVG_COUNT - 1) of unsigned(11 downto 0);
    signal avg_buffer : samplebuffer := (others => (others => '0'));
    signal avg_buffer_idx : natural range 0 to C_AVG_COUNT := 0;
    signal avg_buffer_oldest_idx : natural range 0 to C_AVG_COUNT := 1;
    signal avg_output : std_logic_vector(C_OUT_WIDTH - 1 downto 0) := (others => '0');
    signal sumval : unsigned(C_MAX_NUM_BITS -1 downto 0) := (others => '0');
    signal avgval : unsigned(C_MAX_NUM_BITS - 1 downto 0) := (others => '0');
    signal avgvector : std_logic_vector(C_MAX_NUM_BITS - 1 downto 0) := (others => '0');
    
    attribute mark_debug : string;
    attribute mark_debug of avg_output : signal is "true";
    attribute mark_debug of drdy : signal is "true";
    attribute mark_debug of avg_buffer: signal is "true";
    attribute mark_debug of AVG_STATE: signal is "true";
    attribute mark_debug of STATE: signal is "true";
    attribute mark_debug of dclk: signal is "true";
    attribute mark_debug of busy: signal is "true";
    attribute mark_debug of eoc: signal is "true";
    attribute mark_debug of channel: signal is "true";
    

begin


reset <= rst_in;
dclk <= dclk_in;

daddr_out <= daddr;
--den_out <= den;
di_out <= di;
dwe_out <= dwe;
outputreg <= avg_output;



avg_window: process(dclk_in)
   -- to add G_FIL_L values is needed sumlog2(G_FIL_L) more bits for result
   variable v_sum     :natural := 0;
      
begin
    if rising_edge(dclk_in) then
      if rst_in = '1' then
        avg_buffer <= (others =>(others => '0'));
        avg_output <= (others => '0');
        avg_buffer_idx <= 0;
        avg_buffer_oldest_idx <= 1;
        sumval <= (others => '0');
        avgval <= (others => '0');
        avgvector <= (others => '0');
        AVG_STATE <= AVG_RESET;
        drdy_out <= '0';
      else
        -- check if new sample value
        if drdy_in = '1' and drdy = '0' then
--            samp_in <= sample_reg;
--            samp_in <= do_in(15 downto 4);
            avg_buffer(avg_buffer_idx) <= unsigned(do_in(15 downto 4));
            AVG_STATE <= AVG_ADD;
        else
            drdy_out <= '0';
            if AVG_STATE /= AVG_IDLE then
                case AVG_STATE is
                    when AVG_ADD=>
                        sumval <= sumval + avg_buffer(avg_buffer_idx);
                        AVG_STATE <= AVG_SUB;
                    when AVG_SUB=>
                        sumval <= sumval - avg_buffer(avg_buffer_oldest_idx);
                        AVG_STATE <= AVG_DIV;
                    when AVG_DIV=>
                        avgval <= shift_right(sumval,C_AVG_SHIFT);
                        AVG_STATE <= AVG_CONVERT;
                    when AVG_CONVERT =>
                        avg_buffer_idx <= (avg_buffer_idx + 1) mod C_AVG_COUNT;
                        avg_buffer_oldest_idx <= (avg_buffer_oldest_idx + 1) mod C_AVG_COUNT;
                        avgvector <= std_logic_vector(avgval);
                        AVG_STATE <= AVG_WRITE;
                        
                    when AVG_WRITE =>
                        avg_output <= avgvector(C_OUT_WIDTH - 1 downto 0);
                        drdy_out <= '1';
                        AVG_STATE <= AVG_IDLE;
                    when others =>
                        -- do nothing
                end case;
            else
            end if;
        end if;
        
--        divavgval <= shift_right(avgval,integer(6));
--        avgvector <= std_logic_vector(divavgval);
--        avg_output <= avgvector(C_OUT_WIDTH - 1 downto 0);
      end if;
    end if;

      
end process;


sm : process(dclk_in) is
variable busy_in_state : std_logic;
variable eoc_in_state : std_logic;
variable drdy_in_state : std_logic;
begin
   if rising_edge(dclk_in) then
       if rst_in = '1' then
            STATE <= RESET_HIGH;
            daddr <= (others => '0');
            di <= (others => '0');
            dwe <= '0';
            den_out <= '0';
       else
            daddr <= "00" & channel_in;
            di <= (others => '0');
            dwe <= '0';
            den_out <= eoc_in;
            
--            eos <= eos_in;
            busy <= busy_in;
            drdy <= drdy_in;
            channel <= channel_in;
            eoc <= eoc_in;
--            alarm <= alarm_in;
             
           case STATE is
               when RESET_HIGH =>
                    if rst_in = '0' then
                        STATE <= WAIT_BUSY;
                    end if;
               when WAIT_BUSY =>
                   -- wait for falling edge of busy_in
                   if busy_in = '0' and busy = '1' then
                       STATE <= WAIT_EOC_P;
                   end if;
                when WAIT_EOC_P =>
                    -- wait for rising edge of eoc_in
                    if eoc_in = '1' and eoc = '0' then
                        STATE <= WAIT_EOC;
                    end if;
                when WAIT_EOC =>
                    -- wait for falling edge of eoc_in
                    if eoc_in = '0' and eoc = '1' then
                        STATE <= WAIT_DRDY_P;
                    end if;
                when WAIT_DRDY_P =>
                    if to_integer(unsigned(channel)) = 30 then
--                        if drdy_in = '1' and drdy = '0' then
--                            -- data is ready to be read in the output register
--                        end if;
                        STATE <= WAIT_DRDY_P;
                    else
                        STATE <= WAIT_BUSY;
                    end if;
 
           end case;
       end if;
   end if;
end process sm;


    

    
end arch_imp;
