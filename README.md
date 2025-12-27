# Maxwell J. Pembo
# FPGA-Oscilloscope
FPGA based Oscilloscope and Function Generator using VHDL and C. Project for Advanced Embedded Systems Class


## By Maxwell J. Pembo

  

## Table of Contents 

1. [Objectives or Purpose](#objectives-or-purpose)

2. [Preliminary Design](#preliminary-design)

3. [Software flow chart or algorithms](#software-flow-chart-or-algorithms)

4. [Hardware schematic](#hardware-schematic)

5. [Debugging](#debugging)

6. [Testing methodology or results](#testing-methodology-or-results)

7. [Answers to Lab Questions](#answers-to-lab-questions)

8. [Observations and Conclusions](#observations-and-conclusions)

9. [Documentation](#documentation)



  

## Table of Contents 

1. [Objectives or Purpose](#objectives-or-purpose)

2. [Preliminary Design](#preliminary-design)

3. [Software flow chart or algorithms](#software-flow-chart-or-algorithms)

4. [Hardware schematic](#hardware-schematic)

5. [Debugging](#debugging)

6. [Testing methodology or results](#testing-methodology-or-results)

7. [Answers to Lab Questions](#answers-to-lab-questions)

8. [Observations and Conclusions](#observations-and-conclusions)

9. [Documentation](#documentation)



### Objectives or Purpose

The Goal of this lab was to use the Nexus Video FPGA to create a function generator that outputs 2 different signals one being a sin wave. Some functionality of this projects should be changing the amplitude and the phase of the wave using the FPGAs buttons and switches. Later in the project we will use a soft core processor to change the waveform in C.

### Software flow chart or algorithms

An important part of this project was designing a state machine for the control unit. I kept my FSM simple for this lab that only had 2 states, one that watches for the ready signal then increments the counter, and one to wait for the ready signal.

### Hardware schematic

My inital design of the Lab was handwritten before writing any code.

![Hardware Schematic](Images/newGC1.PNG)

### Debugging

Some problems that I had with this project were mainly with the code and xilinx. My first problem I had were with errors I got when trying to generate my bitstream, the problem was still having XDC components in my code for the VGA, I fixed this commenting out the signals. The next error I had was after generating my bitstream I would not get a signal out of my FPGA I eventualy wrote a piazza post for help and fixed it by changing my breakout board.

### Testing methodology or results


#### Gate Check 1

Gate check 1 was to create a block diagram to help us with the rest of the Lab. I hand drew the inital diagram while planning the BRAM and the audio codec.

![Hardware Schematic](Images/newGC1.PNG)

#### Gate Check 2

Gate check 2 required us to start the VHDL code to initalize the BRAM with calculated values of the wave. To show we have correct functionality I wrote a testbench that simulated the counters and the overall functions.

![Waveform](Images/newGC2.PNG)

#### Required Functionality

For required functionality the goal was to put the waveform on the board and use huskerscope to see the wave. also using the switches and the buttons to change the frequency of the wave.

https://youtube.com/shorts/6k0h5HHZdU4

NOTE: Falkinburg saw required functionality done before due date.

#### B Functionality

For the B Functionality the goal was to use the buttons and the switches to change the apmlitude of the wave

https://youtube.com/shorts/6k0h5HHZdU4

### Observations and Conclusions

In this Lab I learned how to create a function generator using a FPGA. While doing this project I learned about how to instantiate a signal in BRAM. To start this lab I first had to learn about look up tables and direct digital synthasis.

### Documentation

For this Lab I refered to the Lab Manual, I also asked questions to the proffessor using piazza.

### Objectives or Purpose

The Goal of this lab was to use the Nexus Video FPGA to create a function generator that outputs 2 different signals one being a sin wave. Some functionality of this projects should be changing the amplitude and the phase of the wave using the FPGAs buttons and switches. Later in the project we will use a soft core processor to change the waveform in C.

### Software flow chart or algorithms

An important part of this project was designing a state machine for the control unit. I kept my FSM simple for this lab that only had 2 states, one that watches for the ready signal then increments the counter, and one to wait for the ready signal.

### Hardware schematic

My inital design of the Lab was handwritten before writing any code.

![Hardware Schematic](Images/newGC1.PNG)

### Debugging

Some problems that I had with this project were mainly with the code and xilinx. My first problem I had were with errors I got when trying to generate my bitstream, the problem was still having XDC components in my code for the VGA, I fixed this commenting out the signals. The next error I had was after generating my bitstream I would not get a signal out of my FPGA I eventualy wrote a piazza post for help and fixed it by changing my breakout board.

### Testing methodology or results


#### Gate Check 1

Gate check 1 was to create a block diagram to help us with the rest of the Lab. I hand drew the inital diagram while planning the BRAM and the audio codec.

![Hardware Schematic](Images/newGC1.PNG)

#### Gate Check 2

Gate check 2 required us to start the VHDL code to initalize the BRAM with calculated values of the wave. To show we have correct functionality I wrote a testbench that simulated the counters and the overall functions.

![Waveform](Images/newGC2.PNG)

#### Required Functionality

For required functionality the goal was to put the waveform on the board and use huskerscope to see the wave. also using the switches and the buttons to change the frequency of the wave.

https://youtube.com/shorts/6k0h5HHZdU4

NOTE: Falkinburg saw required functionality done before due date.

#### B Functionality

For the B Functionality the goal was to use the buttons and the switches to change the apmlitude of the wave

https://youtube.com/shorts/6k0h5HHZdU4

### Observations and Conclusions

In this Lab I learned how to create a function generator using a FPGA. While doing this project I learned about how to instantiate a signal in BRAM. To start this lab I first had to learn about look up tables and direct digital synthasis.

