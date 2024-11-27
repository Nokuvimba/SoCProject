---
layout: home
title: FPGA VGA Driver Project
tags: fpga vga verilog
categories: demo
---

Add a short welcome message or introduction here. Aim to get the viewer interested in what follows! Guideline: 1 or 2 sentences.

## **Template VGA Design**
### **Project Set-Up**
The project is divided into 4 sections: Design sources, Constrains, Simulation sources and utility sources.
Design Sources: In the design sources the u_clock is set to 25.000 and this controls the clock signals of the synthesis.The u_vga_sync handles the VGA synchronization and the u_colour_cycle manages VGA color transitions.
                The files in this section are responsible for the colour gerenation on the screen.
Contraints    : it consists of the Basys3_Master.xdc which is used to map logical signals to the physical pins on the board. This is to makes sure that both the simulation of the sofware and the synthesis on the hardwark                 work properly.
Simulation    : it is used to simulates the software. It simulates the design but intyerfacing with the VGASync, ColourCycle and the VGATop. The Testbench tests all components.

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/Screenshot%202024-11-12%20154634.png">

### **Template Code**
Outline the structure and design of the Verilog code templates you were given. What do they do? Include reference to how a VGA interface works. Guideline: 2/3 short paragraphs, consider including screenshot(s).
### **Simulation**
The screenshot below show the simulation of the code we were given initially. This shows that the Testbench file is used to drive input signals which include clk (clock) and rst (reset) to simulate the VGATop.v. The outputs are the combinations of the 3 colours: red, blue and green. The waveforms confirm that the VGA controller cycles through pixel rows(row) and columns(col). There are ---rows and --- columns. I also could see that there are 8 states (from 0 to 7). ALL the outputs were displayed in decimal form so l changed the colours to be represented in binary form and the state to ---. Each state is a combination of different binary numbers, representing the 3 colours. For example in state 0 , all the colours are assigned 0000 and in state 5, red and green have the binary number 0000 and blue has the binary number 1111.
The simulation is a vitual environment that helps to validate the functionality before programming the FVGA, errors and unexpected outputs can be debugged.

<img src="https://github.com/Nokuvimba/SoCProject/blob/main/images/SIMULATION%20WITH%20STATES.png">

### **Synthesis**
Describe the synthesis and implementation processes. Consider including 1/2 useful screenshot(s). Guideline: 1/2 short paragraphs.
### **Demonstration**
Perhaps add a picture of your demo. Guideline: 1/2 sentences.

## **My VGA Design Edit**
Introduce your own design idea. Consider how complex/achievabble this might be or otherwise. Reference any research you do online (use hyperlinks).
### **Code Adaptation**
Briefly show how you changed the template code to display a different image. Demonstrate your understanding. Guideline: 1-2 short paragraphs.
### **Simulation**
Show how you simulated your own design. Are there any things to note? Demonstrate your understanding. Add a screenshot. Guideline: 1-2 short paragraphs.
### **Synthesis**
Describe the synthesis & implementation outputs for your design, are there any differences to that of the original design? Guideline 1-2 short paragraphs.
### **Demonstration**
If you get your own design working on the Basys3 board, take a picture! Guideline: 1-2 sentences.

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
