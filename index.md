---
layout: home
title: FPGA VGA Driver Project
tags: fpga vga verilog
categories: demo
---

Welcome to the FPGA VGA Driver Project , where l explore and create a custom design for a VGA driver. This project demonstrates how to generate different colours and patterns on a monitor using an FPGA. The design involves synchronizing pixel data, generating RGB signals, and implementing a complete hardware design using vivado.

## **Template VGA Design**
### **Project Set-Up**
The project is divided into  four sections: Design sources, Constrains, Simulation sources and Utility sources.

Design Sources   : These contain the primary code that describes the hardware design for the for the VGA driver. During synthesis, this code is converted into a netlist. The u_clock(clock wizard) generates a 25MHz clock signal to synchronize the VGA display. The u_vga_sync handles the VGA synchronization signals and the u_colour_cycle manages VGA color transitions.These modules collectively generate the color patterns displayed on the monitor.
       
Contraints    : They are crucial during the implementation phase as they define timing requirements, pin assignments and physical specifications. The Basys3_Master.xdc is used to map logical signals to the physical pins on the FPGA board, making sure that both the simulation of the sofware and the synthesis on the hardware work properly.

Simulation  sources  :These verify the functionality of the VGA design. The testbench drives input signals which include the clk and rst , to simulate the behavior of modules such as VGASync, ColourCycle, and VGATop. This ensures proper design functionality before implementing it on hardware.

Utility sources  : The utility sources are not directly involved in synthesis or implementation but they contribute to automation or design configuration.

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/Screenshot%202024-11-12%20154634.png?raw=true">

### **Template Code**

The provided template code generates vertical color stripes based on pixel column positions on the VGA display. Each stripe corresponds to a specific range of column values, with colors determined by the RGB output. The eight colors displayed are: black, blue, green, cyan, red, magenta, yellow, and white.

Inputs:  The `clk `synchronizes operations, `rst` resets RGB outputs to zero,	`row, col` specifies the pixel’s position on the display (11-bit coordinates).
Outputs: The red, green, blue are 4-bit RGB signals representing pixel colors. The registers (red_reg, green_reg, blue_reg) and temporary variables (red_next, green_next, blue_next) are used to store and update color values.

Inside the always @* determines where each colour is placed in each specific column range, for the range that is not mentioned a white colour would be displayed instead. The code inside the :`always@(posedge clk, posedge rst)`  is responsible for updating the RGB values. When rst is high (1'b1), all the RGB ouputs would be set to zero(0000). The ouput would be black then(blank screen).

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/Screenshot%202024-11-26%20154637.png?raw=true">

### **Simulation**
The screenshot below show the simulation of the code we were given initially. This shows that the Testbench file is used to drive input signals which include clk (clock) and rst (reset) to simulate the VGATop.v. The outputs are the combinations of the 3 colours: red, blue and green. The waveforms confirm that the VGA controller cycles through pixel rows(row) and columns(col). There are 640 rows and 480 columns. I also could see that there are 8 states (from 0 to 7). The outputs were initially displayed in decimal form so l changed the colours to be represented in binary form for clarity. Each state is a combination of different binary numbers, representing the 3 colours. For example in state 0 , all the colours are assigned 0000 and in state 5, red and green have the binary number 0000 and blue has the binary number 1111.
The simulation is a vitual environment that helps to validate the functionality before programming the FVGA, errors and unexpected outputs can be debugged.

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/SIMULATION%20WITH%20STATES.png?raw=true">

### **Synthesis and implementation process**

Synthesis :  The synthesis process converts the hardware design code into a lower-level form that the FPGA can use. This step checks for errors, assigns resources, and ensures the design works correctly, meeting the timing and synchronization needs of the VGA driver. Without this process, the design cannot be implement.

Implementation :  The implementation process maps the synthesized design to the FPGA's hardware resources,which include logic blocks, memory, and I/O pins. It ensures that everything is set up to handle the VGA signal timing properly. After implementation, the design is loaded onto the FPGA, where it can be tested on a monitor.

### **Demonstration**
After going through the code l decided to first edit the Colourstripes code in the most simpler way to try and understand how each colour is mapped on each pixel. I changed the code by specifying the row sections l wanted each colour to be mapped on.I used the notes app to visualise what l expected to see on the monitor. This gave me a good understanging of counting pixels and how important it is to specify correctly the ranges of rows and columns a colour should be placed.

<img src="https://raw.githubusercontent.com/Nokuvimba/SoCProject/refs/heads/main/images/Image.png">

This is a snippet of the code. I used if statements to specify the ranges of rows and colomns l wanted each colour to be placed.

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/today2.png?raw=true">

This was the output on the monitor:
<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/Image%20(2).jpg?raw=true">


## **My VGA Design Edit**

I aimed to create a colour wheel which would consist of different colours. I used the `https://www.pixilart.com/draw` to sketch my idea. I used the 64 by 48 pixel canvas , so that it would be easy to map the design on the 640 by 480 monitor. This design would involve using the atan function calculations to assign colours based on angle and radius.

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/pixel.jpg?raw=true">

### **Code Adaptation**

I centered the wheel at 320 by 240 and calculated the x, y offsets for each pixel relative to the centre of the display. The radius was calculated as the square of the Euclidean distance.
`wire signed [10:0] center_x = 320;
wire signed [10:0] center_y = 240;t
wire signed [11:0] x = col - center_x;
wire signed [11:0] y = row - center_y;`
The code ` wire [15:0] max_radius= 100*100` is defined to set the boundary for the circular region.
Initially l used the atan function `wire [31:0] angle = (x == 0 && y == 0) ? 0 : ($atan2(y, x) + rotation_offset);` but l got the error: "`illegal argument of type wire in math function  atan2(); expected real type `". I used chatgpt to find out the cause of the error and I found out that vivado does not support this for hardware synthesis.  

Instead, I approximated the angle: `wire signed [15:0] atan_angle = (x ==0 && y ==0) ? 16'b0 : (x* 16'd180 / 16'd320);`. 
<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/Screenshot%202024-12-10%20155418.png?raw=true">

A case statement was used to assign colours depending on the high-oder bits of the angle `atan_angle[15:12]`. If a pixel's radius exceeds the maximum radius, it is be set to black. 

### **Simulation**
I simulated my design to verify functionality. The inaccuracies in the angle approximation caused some color mismapping. Instead of getting the the colour wheel l ripple was created. Looking back at my angle and radii calculation, the calculation focused on the x component, ignoring the y component hence the lack of true angular accuracy.

### **Synthesis**
The synthesised design layout shows how the design logic is physically mapped onto the FPGA hardware.
<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/SynthesizedDesign.png?raw=true">

#### **Implementation**
Below is the implementation schematic design . It shows how the verilog module is mapped onto the FPGA flip-flops, logic gates and buffers. The `IBUF` are buffers that are added to stabilize and standardize input signals (the clock and reset). The `OBUF` buffers ensure the output signals are strong enough to drive the monitor.
<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/ImplementedDesign2.png?raw=true">


### **Demonstration**

#### **Monitor output**
The pattern that was generated was radial with a ripple effect of red and black circles.  As I have mentioned above, this is mainly because of how the atan angle was calculated leading to inaccurate colour mapping. 

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/finalOutput.jpg?raw=true">

#### **RTL Analysis**
Below is a view of the Register Transfer level of the edited FPGA design.
<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/RtlAnalysis.png?raw=true">

The u_clock block generates a 25MHz clock (clk_out1) from an input clock `clk_in1`, the `clk_in1` is the input from the FPGA board and `reset` resets the clock module. The u_vga_sync(VGA Sync) block generates the synchronization signals (hSync, vSync) and pixel coordinates (row,col) required for the VGA output. It determines the horizontal and vertical pixel positions on the screen. The `u_colour_stripes` figures out the RGB colour values for each pixel based on the (row,col) position using the code l edited. The RTL_MUX are multiplexers.

#### **Power used**
The total power that was consumed by the FPGA design was 0.19W, this includes 62% of dynamic power (0.118W) and 38% of static power (0.072W). It shows that most of the power is drawn by the MMCM(Mixed-Mode Clock Manage) which has 98% of the total power. Everything else like logic and I/O uses very little power.
<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/Power.png?raw=true">

