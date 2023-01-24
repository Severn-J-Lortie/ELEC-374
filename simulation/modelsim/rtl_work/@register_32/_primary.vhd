library verilog;
use verilog.vl_types.all;
entity Register_32 is
    generic(
        INITIAL_VAL     : integer := 0
    );
    port(
        clr             : in     vl_logic;
        clk             : in     vl_logic;
        enable          : in     vl_logic;
        D               : in     vl_logic_vector(31 downto 0);
        Q               : out    vl_logic_vector(31 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INITIAL_VAL : constant is 1;
end Register_32;
