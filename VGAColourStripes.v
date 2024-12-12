`timescale 1ns / 1ps

// File: VGAColourStripes.v
// Author: Michelle Lynch
// Copyright Michelle Lynch 2024
//
// Adapting Author: 
// Date:
module ColourStripes #(

    parameter COUNTER_WIDTH = 32,
   parameter COUNT_FROM = 0,
   parameter COUNT_TO = 32'b1 << 26,
   parameter COUNT_RESET = 32'b1 << 27
)(
   input clk, rst,
   input [10:0] row, col,
   output [3:0] red, green, blue
);
   reg [3:0] red_reg, green_reg, blue_reg, red_next, green_next, blue_next;
   // Compute polar coordinates from (row, col)
   wire signed [10:0] center_x = 320; // Center of the wheel (X)
   wire signed [10:0] center_y = 240; // Center of the wheel (Y)
   wire signed [11:0] x = col - center_x; // Horizontal offset from center
   wire signed [11:0] y = row - center_y; // Vertical offset from center
   wire [15:0] radius = x * x + y * y;   // Distance squared from center
   wire [15:0] max_radius = 100 * 100;   // Maximum radius squared for the wheel
   wire [15:0] angle;  // Angle based on x and y
   // Calculate angle based on x and y (simplified version)
   // Normalize x and y to an angle (this is a rudimentary approach)
   wire signed [15:0] atan_angle = (x == 0 && y == 0) ? 16'b0 : (x * 16'd180 / 16'd320); // Very simplified
   // Next state logic to assign colors based on angle
   always @* begin
       if (radius > max_radius) begin
           red_next = 4'b0000;
           green_next = 4'b0000;
           blue_next = 4'b0000; // Background color (black)
       end else begin
           // Map angle to colors using basic angle regions
           case (atan_angle[15:12]) // Use part of angle for color determination
               4'b0000: begin red_next = 4'b1111; green_next = 4'b0000; blue_next = 4'b0000; end // Red
               4'b0001: begin red_next = 4'b1111; green_next = 4'b1111; blue_next = 4'b0000; end // Yellow
               4'b0010: begin red_next = 4'b0000; green_next = 4'b1111; blue_next = 4'b0000; end // Green
               4'b0011: begin red_next = 4'b0000; green_next = 4'b1111; blue_next = 4'b1111; end // Cyan
               4'b0100: begin red_next = 4'b0000; green_next = 4'b0000; blue_next = 4'b1111; end // Blue
               4'b0101: begin red_next = 4'b1111; green_next = 4'b0000; blue_next = 4'b1111; end // Magenta
               default: begin red_next = 4'b1111; green_next = 4'b1111; blue_next = 4'b1111; end // White
           endcase
       end
   end
   // Register RGB outputs
   always @(posedge clk or posedge rst) begin
       if (rst) begin
           red_reg   <= 4'b0000;
           green_reg <= 4'b0000;
           blue_reg  <= 4'b0000;
       end else begin
           red_reg   <= red_next;
           green_reg <= green_next;
           blue_reg  <= blue_next;
       end
   end
   // Assign output wires
   assign red = red_reg;
   assign green = green_reg;
   assign blue = blue_reg;
endmodule