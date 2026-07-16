`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2025 15:50:37
// Design Name: 
// Module Name: tb_toll_simple
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


module tb_toll_simple;
    reg clk;
    reg rst;
    reg vehicle;
    reg payment;
  
    wire gate;
    wire charge;
    // Connect DUT 
    toll_simple dut (
        .clk(clk),
        .rst(rst),
        .vehicle(vehicle),
        .payment(payment),
        .gate(gate),
        .charge(charge)
    );
    // Clock generation: toggle every 5ns ? 100 MHz clock
    always #5 clk = ~clk;
    
    initial begin
        // Dump waves for simulation
        $dumpfile("toll_simple.vcd");
        $dumpvars(0, tb_toll_simple);
        // Step 1: Initial values
        clk     = 0;
        rst     = 1;   // start in reset
        vehicle = 0;
        payment = 0;
        // Step 2: Release reset
        #10 rst = 0;   // after 10ns, release reset
        // Step 3: Vehicle arrives
        #20 vehicle = 1;
        // Step 4: Make payment after some time
        #30 payment = 1;
        #10 payment = 0;  // turn payment back to 0
        // Step 5: Vehicle leaves (optional)
        #40 vehicle = 0;
        // Step 6: End simulation
        #100 $finish;
    end
endmodule

