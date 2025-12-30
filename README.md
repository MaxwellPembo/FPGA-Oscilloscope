# Maxwell J. Pembo
# FPGA-Oscilloscope
FPGA based Oscilloscope and Function Generator using VHDL and C. The [Nexus Video FPGA](https://digilent.com/reference/programmable-logic/nexys-video/start) was used to implement this using AMD Xilinx Vivado. Project was created for Advanced Embedded Systems Class.


## Project Features
- Created Oscilloscope from FPGA that takes signal in from boards audio input port. 
    - Implemented in VHDL 
- Created Function generator that outputted signals using boards audio output port
    - Created Using the Microblaze softcore processor, coded in C
    - Held library of functions(waves) in FPGA BRAM

- Outputted a video display using the boards HDMI port that showed incomming wave
- Listened to commands to control the function generatior and the oscilloscope via the boards UART 

## Hardware schematics
This is the shematic that holds the hardware logic for the oscilloscope.
![Hardware Schematic](Images/newGC1.png)





These are the schematics that shows how the oscilloscope (my_oscope_ip_0) interacts with the microblaze processor.
![Hardware Schematic](Images/GC_1.2.png)
![Hardware Schematic](Images/Hardware.png)

## Result Videos & Images

##### Oscilloscope Functionality
https://youtu.be/GC_lx_L3_Rk
![Hardware Schematic](Images/GC_1.png)

##### Oscilloscope Functionality Pt.2
https://youtube.com/shorts/oO8TJ-WLmiQ

##### Function Generator Feature
https://youtube.com/shorts/6k0h5HHZdU4

##### BRAM and State Machine Testbench
![Hardware Schematic](Images/NewGC2.png)


## Code Locations:

#### [Function Generator](Lab_3.sdk/Lab_3/src/Lab_3.c)

### Hardware Components

#### [Control unit and Datapath](Lab_4.srcs/sources_1/new)

#### [Components](ip_repo/my_oscope_ip_1.0/src) 
