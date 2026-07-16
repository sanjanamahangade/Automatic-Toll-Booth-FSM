`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.09.2025 15:47:31
// Design Name: 
// Module Name: toll_simple
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


module toll_simple(
    input  wire clk,        // clock signal
    input  wire rst,        // reset (active high)
    input  wire vehicle,    // 1 = a vehicle is present
    input  wire payment,    // 1 = payment is done
    output reg  gate,       // 1 = gate open
    output reg  charge      // 1 = charge signal (just 1 clock pulse)
);
    // 00 = IDLE, 01 = WAITING FOR PAYMENT, 10 = OPEN, 11 = CLOSE
    reg [1:0] state;
    // Reset or move between states
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state  <= 2'b00;  // go to IDLE on reset
            gate   <= 0;
            charge <= 0;
        end else begin
            case (state)
                2'b00: begin // IDLE
                    gate   <= 0;
                    charge <= 0;
                    if (vehicle) 
                        state <= 2'b01; // move to WAIT_PAY
                end
                2'b01: begin // WAIT_PAY
                    gate   <= 0;
                    charge <= 0;
                    if (payment) begin
                        state  <= 2'b10; // move to OPEN
                        charge <= 1;     // generate charge
                    end
                end
                2'b10: begin // OPEN
                    gate   <= 1;  // open the gate
                    charge <= 0;
                    state  <= 2'b11; // next go to CLOSE
                end
                2'b11: begin // CLOSE
                    gate   <= 0;  // close the gate
                    charge <= 0;
                    state  <= 2'b00; // back to IDLE
                end
                default: state <= 2'b00; // safety: go to IDLE
            endcase
        end
    end
endmodule

