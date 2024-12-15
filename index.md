---
layout: home
title: FPGA VGA Driver Project
tags: fpga vga verilog
categories: demo
---

Add a short welcome message or introduction here. Aim to get the viewer interested in what follows! Guideline: 1 or 2 sentences.

Welcome to the FPGA VGA Driver Project , where l get to learn and produce my own design. This project demonstrates how to create a working VGA driver to display colours and patterns using an FPGA. The design involves synchronizing pixel data and generating RGB signals for a monitor using vivado.

## **Template VGA Design**
### **Project Set-Up**
The project is divided into 4 sections: Design sources, Constrains, Simulation sources and utility sources.

Design Sources   : They contain the primary code that describes the hardware design for the for the VGA driver and is synthesized into a netlist during the synthesis process. In the design sources, the u_clock(clock wizard) is set to 25.000 and this controls the clock signals of the synthesis.The u_vga_sync handles the VGA synchronization and the u_colour_cycle manages VGA color transitions.The files in this section are responsible for the colour gerenation on the screen.

                
Contraints    : They are crucial during the implementation phase. They define timing requirements, pin assignments and physical specifications. It consists of the Basys3_Master.xdc which is used to map logical signals to the physical pins on the board. This is to make sure that both the simulation of the sofware and the synthesis on the hardware work properly.


Simulation    :The simulation sources are used in the verification process to simulate the software. It simulates the design but interfacing with the VGASync, ColourCycle and the VGATop. The Testbench tests all components.

Utility  : The utility sources are not directly involved in synthesis or implementation unless they contribute to automation or design configuration.

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/Screenshot%202024-11-12%20154634.png?raw=true">

### **Template Code**

The template code generated vertical color stripes based on the pixel's column(col) positions on the vga diplay which is the monitor. Each stripe is mapped onto a range of column values and every colour is determined by the red, green and blue outputs. The 8 colours that were created were black, blue, green, cyan, red, white, yellow and Magenta. These were based on the RGV values that were assigned.

The code had inputs and outputs. The inputs include the clk, rst, row and col. The clk is the clock signal used to synchronize operations.The rst is the reset signal which is used to initialize or reset RGB outputs to zero. The row,col are 11-bit inputs which are used to specify the row and column coordinates of the pixel on the display. The outputs include the reg, green and blue which are the 4-bit RGB signals for the colour of thr current pixel. The red_reg, green_reg, blue_reg are registers used to hold the current RGB values. The red_next, green_next and blue_next are temporary registers used to hold the next RGB values that will be assigned.

Inside the always @* determines where each colour is placed in each specific column range, for the range that is not mentioned a white colour would be displayed instead. The code inside the :`always@(posedge clk, posedge rst)`  is responsible for for updating the RGB values. When rst is high (1'b1), all the RGB ouputs would be set to zero(0000). The ouput would be black then(blank screen).

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/Screenshot%202024-11-26%20154637.png?raw=true">

### **Simulation**
The screenshot below show the simulation of the code we were given initially. This shows that the Testbench file is used to drive input signals which include clk (clock) and rst (reset) to simulate the VGATop.v. The outputs are the combinations of the 3 colours: red, blue and green. The waveforms confirm that the VGA controller cycles through pixel rows(row) and columns(col). There are 640 rows and 480 columns. I also could see that there are 8 states (from 0 to 7). ALL the outputs were displayed in decimal form so l changed the colours to be represented in binary form and the state to ---. Each state is a combination of different binary numbers, representing the 3 colours. For example in state 0 , all the colours are assigned 0000 and in state 5, red and green have the binary number 0000 and blue has the binary number 1111.
The simulation is a vitual environment that helps to validate the functionality before programming the FVGA, errors and unexpected outputs can be debugged.

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/SIMULATION%20WITH%20STATES.png?raw=true">

### **Synthesis and implementation process**

Synthesis :  The synthesis process converts the hardware design code into a lower-level form that the FPGA can use. This step checks for errors, assigns resources, and ensures the design works correctly, meeting the timing and synchronization needs of the VGA driver. Without this process, you cannot implement.

implementation :  The implementation process places and connects the synthesized design to the FPGA's hardware resources, like logic blocks, memory, and I/O pins. It ensures everything is set up to handle the VGA signal timing properly. After implementation, the design is loaded onto the FPGA, and you can test it using a monitor to check if the VGA driver works as expected.

### **Demonstration**

After going through the code l decided to first edit the Colourstripes code in the most simpler way to try and understand how each colour is mapped on each pixel. I changed the code by specifying the row sections l wanted each colour to be mapped on.I used the notes app to visualise what i expected to see on the monitor. This gave me a good understanging of counting pixels and how important it is to specify correctly the ranges of rows and columns a colour should be placed.

<img src="https://raw.githubusercontent.com/Nokuvimba/SoCProject/refs/heads/main/images/Image.png">

This is a snippet of the code. I used if statements to specify the ranges of rows and colomns l wanted each colour to be placed.

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/today2.png?raw=true">

This was the output on the monitor:
<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/Image%20(2).jpg?raw=true">


## **My VGA Design Edit**
Introduce your own design idea. Consider how complex/achievabble this might be or otherwise. Reference any research you do online (use hyperlinks).

The idea l has was creating a colour wheel and add the switching of colours as the colour cycle code to create an illusion of a moving wheel. I used the `https://www.pixilart.com/draw` to sketch my idea. I used the 64 by 48 pixel canvas , so that it would be easy to map the design on the 640 by 480 monitor. I was going to use the atan function for angle calculation and calculate the radius as the euclidean distance from the center.

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/pixel.jpg?raw=true">

### **Code Adaptation**

I defined the centre of the wheel at 320 by 240 and calculated the x and y offsets for each pixel relative to the centre of the display. The radius was calculated as the square of the Euclidean distance.
`wire signed [10:0] center_x = 320;
wire signed [10:0] center_y = 240;t
wire signed [11:0] x = col - center_x;
wire signed [11:0] y = row - center_y;`
The code ` wire [15:0] max_radius= 100*100` is defined to set the boundary for the circular region.
To calculate the angle I used the atan function at first but then l got the error "`illegal argument of type wire in math function  atan2(); expected real type `". I used chatgpt to find out the cause of the error and this was because the function atan is not often used in high level software programming and is not directly supported in hardware synthesis.  

The atan function `wire [31:0] angle = (x == 0 && y == 0) ? 0 : ($atan2(y, x) + rotation_offset);`was replaced by using simplified approximation that does not compute the true arctangent. `wire signed [15:0] atan_angle = (x ==0 && y ==0) ? 16'b0 : (x* 16'd180 / 16'd320);`The y component is ignored  in this calculation hence  the lack of true angular accuracy.

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/Screenshot%202024-12-10%20155418.png?raw=true">

A case statement was used to assign colours depending on the high-oder bits of the angle `atan_angle[15:12]`. If a pixel's radius exceeds the maximum radius, it would be set to black. 
Briefly show how you changed the template code to display a different image. Demonstrate your understanding. Guideline: 1-2 short paragraphs.

### **Simulation**
Show how you simulated your own design. Are there any things to note? Demonstrate your understanding. Add a screenshot. Guideline: 1-2 short paragraphs.

### **Synthesis**
<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/SynthesizedDesign.png?raw=true">

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/implementedDesign.png?raw=true">

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/ImplementedDesign2.png?raw=true">



Describe the synthesis & implementation outputs for your design, are there any differences to that of the original design? Guideline 1-2 short paragraphs.
### **Demonstration**

If you get your own design working on the Basys3 board, take a picture! Guideline: 1-2 sentences.

# **Monitor output**
The pattern that was generated was radial with a ripple effect of red and black circles.  This mainly because of how the atan angle was calculated leading to inaccurate colour mapping.The simplified equation only focused on x alone instead of the true arctangent computation.

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/finalOutput.jpg?raw=true">

# **RTL Analysis**
Below is a view of the Register Transfer level of the edited FPGA design.
<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/RtlAnalysis.png?raw=true">

The u_clock block generates a 25MHz clock (clk_out1) from an input clock `clk_in1`, the `clk_in1` is the input from the FPGA board and `reset` resets the clock module. The u_vga_sync(VGA Sync) block generates the synchronization signals (hSync, vSync) and pixel coordinates (row,col) required for the VGA output. It determines the horizontal and vertical pixel positions on the screen. The `u_colour_stripes` figures out the RGB colour values for each pixel based on the (row,col) position using the code l edited. The RTL_MUX are multiplexers which are used 


## **More Markdown Basics**
This is a paragraph. Add an empty line to start a new paragraph.

Font can be emphasised as *Italic* or **Bold**.

Code can be highlighted by using `backticks`.

Hyperlinks look like this: [GitHub Help](https://help.github.com/).

A bullet list can be rendered as follows:
- vectors
- algorithms
- iterators

Images can be added by uploading them to the repository in a /docs/assets/images folder, and then rendering using HTML via githubusercontent.com as shown in the example below.

<img src="https://raw.githubusercontent.com/melgineer/fpga-vga-verilog/main/docs/assets/images/VGAPrjSrcs.png">
