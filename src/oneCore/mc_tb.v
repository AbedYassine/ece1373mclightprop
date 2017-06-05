`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/03/2017 06:34:01 PM
// Design Name: 
// Module Name: mc_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mc_tb(

    );
    
    reg reset_rtl;
    reg sys_clock;
       
    // Instantiate DUT
    mclp_block_design_wrapper dut
           (  reset_rtl, sys_clock); 
        
    // Make clock
    always
        #3 sys_clock = ~sys_clock;
    
    // Initialize and toggle reset
    initial
    begin
        sys_clock = 1'b0;
        reset_rtl = 1'b0;
        #45
        reset_rtl = 1'b1;
    end

endmodule
