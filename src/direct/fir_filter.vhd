----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 31.03.2026 10:36:16
-- Design Name: 
-- Module Name: shift_register - Behavioral
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

entity fir_filter is
    
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           valid : in STD_LOGIC;
           x_in : in STD_LOGIC_VECTOR(11 downto 0);
           y_output : out STD_LOGIC_VECTOR(23 downto 0));
           
end fir_filter;

architecture Behavioral of fir_filter is

--This module is a shift register, since the filtered output was shifted as observed in the MATLAB plots.

--An array is required to save incoming inputs (in this case 17).
--Each input is 12 bits long, since Q4.8 chosen and 4+8=12.
type my_array_of_inputs is array (0 to 16) of STD_LOGIC_VECTOR(11 downto 0);
signal temp_array : my_array_of_inputs;

--Another array of coefficients calculated in MATLAB is required.
 type my_array_of_coefficients is array (0 to 16) of STD_LOGIC_VECTOR(11 downto 0);
 signal temp_coeff : my_array_of_coefficients;
 
 --Another array of products.
 --Output is calculated based on the mathematical formula of the FIR filter.
 --Notice the prodcts need 24 bits to be stored.
 type my_array_of_products is array (0 to 16) of STD_LOGIC_VECTOR(23 downto 0);
 signal temp_products : my_array_of_products;
 
 --A temporary y_output.
 signal temp_y_output : STD_LOGIC_VECTOR(23 downto 0);
 
begin

proc1 : process(clk)
begin

    if (rising_edge(clk)) then
        if (reset) = '1' then
            temp_array <= (others => (others => '0'));
        else
            if (valid = '1') then 
                for i in 1 to 16 loop
                    temp_array(0) <= x_in;
                    temp_array(i) <= temp_array(i-1);
                end loop;
            end if;
        end if;         
    end if;

end process proc1;

--Hardwire the temporary coefficients from MATLAB.
--to_signed (x,12): From universal integer x, convert to signed x and use 12 bits.
temp_coeff(0) <= std_logic_vector(to_signed(9,12));
temp_coeff(1) <= std_logic_vector(to_signed(13,12));
temp_coeff(2) <= std_logic_vector(to_signed(25,12));
temp_coeff(3) <= std_logic_vector(to_signed(42,12));
temp_coeff(4) <= std_logic_vector(to_signed(63,12));
temp_coeff(5) <= std_logic_vector(to_signed(84,12));
temp_coeff(6) <= std_logic_vector(to_signed(102,12));
temp_coeff(7) <= std_logic_vector(to_signed(114,12));
temp_coeff(8) <= std_logic_vector(to_signed(118,12)); --After this it starts repeating itself.
temp_coeff(9) <= std_logic_vector(to_signed(114,12));
temp_coeff(10) <= std_logic_vector(to_signed(102,12));
temp_coeff(11) <= std_logic_vector(to_signed(84,12));
temp_coeff(12) <= std_logic_vector(to_signed(63,12));
temp_coeff(13) <= std_logic_vector(to_signed(42,12));
temp_coeff(14) <= std_logic_vector(to_signed(25,12));
temp_coeff(15) <= std_logic_vector(to_signed(13,12));
temp_coeff(16) <= std_logic_vector(to_signed(9,12));


proc2 : process(clk)
begin
    
    if (rising_edge(clk)) then
        if (reset = '1') then
            temp_products <= (others => (others => '0'));
            --temp_y_output <= (others => '0'); otherwise temp_y_output driven by 2 different processes!
        else
            if (valid = '1') then
                for i in 0 to 16 loop --do not forget 0 here.
                    temp_products(i) <= std_logic_vector(signed(temp_array(i)) * signed(temp_coeff(i)));
                    --temp_y_output <= std_logic_vector(signed(temp_y_output) + signed(temp_products(i)));
                end loop;
            end if;
        end if;
    end if;
    
end process proc2;


--Calculate the sum of all products:
proc3 : process(temp_products)
begin

    temp_y_output <= std_logic_vector(signed(temp_products(0)) + signed(temp_products(1)) + 
                                      signed(temp_products(2)) + signed(temp_products(3)) + 
                                      signed(temp_products(4)) + signed(temp_products(5)) + 
                                      signed(temp_products(6)) + signed(temp_products(7)) +
                                      signed(temp_products(8)) + signed(temp_products(9)) +
                                      signed(temp_products(10)) + signed(temp_products(11)) +
                                      signed(temp_products(12)) + signed(temp_products(13)) +
                                      signed(temp_products(14)) + signed(temp_products(15)) +
                                      signed(temp_products(16)));
end process proc3;


--Assign the temporary output to the real output.
y_output <= temp_y_output;

end Behavioral;