----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2026 13:06:55
-- Design Name: 
-- Module Name: tb_shift_register - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity tb_shift_register is
end tb_shift_register;

architecture Behavioral of tb_shift_register is

component fir_filter is
    
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           valid : in STD_LOGIC;
           x_in : in STD_LOGIC_VECTOR(11 downto 0);
           y_output : out STD_LOGIC_VECTOR(23 downto 0));
           
end component;

--Inputs
signal clk : STD_LOGIC := '0';
signal reset : STD_LOGIC := '1';
signal valid : STD_LOGIC := '0';
signal x_in : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');

--Output
signal y_output : STD_LOGIC_VECTOR(23 downto 0);

begin

dut : fir_filter PORT MAP (clk => clk, reset => reset, valid => valid, x_in => x_in, y_output => y_output);

--Clock generator
clk_process : process
begin
    while true loop
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
    end loop;
end process clk_process;

--Hardwire reset.
reset <= '0' after 10 ns;

--Generate pulse for valid.
valid_process : process
begin
    wait for 100 ns; --wait some time to start the pulse.
    valid <= '1'; wait for 300 ns; --50 ns is the pulse length.
    valid <= '0'; wait; --wait forever so that the process does not activate again.
end process valid_process;

--Input signal
x_in_process : process
begin
    for i in 0 to 20 loop
        wait for 10 ns;
        x_in <= std_logic_vector(unsigned(x_in) + 1);
    end loop;
end process x_in_process;


end Behavioral;
