# ECE128-Lab7-FSM-UpCounter-and-MultiDigitDisplay-


This repository contains the Verilog source files, testbenches, and constraints for Lab 7 of ECE 128.
The lab combines finite state machines, a 12-bit up counter, a binary-to-BCD converter, and a seven-segment display driver.
All designs target the Basys3 FPGA board using Vivado 2023.1.

## Overview
- The lab consists of the following designs:
- Moore FSM sequence detector for pattern 1100
- Mealy FSM sequence detector for pattern 1101
- 12-bit synchronous up counter (0 to 4095)
- Binary-to-BCD converter using the Double Dabble algorithm
- Top module that displays the counter value on the Basys3 four-digit seven-segment display
  
All submodules were simulated individually. The top module was implemented on hardware as required.

## Module Summary

- The Moore FSM asserts its output after detecting the sequence 1100.
- The Mealy FSM asserts its output on the same cycle as the final bit of the sequence 1101.
- The 12-bit counter increments on each enabled clock cycle and wraps at 4095.
- The Binary-to-BCD converter shifts and adjusts digits according to the Double Dabble algorithm and outputs four BCD digits.
- The multi-digit seven-segment driver multiplexes four digits on Basys3 and displays the counter value.

## Hardware Implementation
The top-level module connects:
  counter → bin2bcd → multiseg_driver → an, seg, dp

The following Basys3 pins are enabled in the XDC:
- Clock: W5
- Segments: W7, W6, U8, V8, U5, V5, U7
- Decimal point: V7
- Anodes: U2, U4, V4, W4
When programmed, the display shows a decimal count from 0000 to 4095 repeatedly.

## How to Use

Open Vivado (2023.1 or later)
1- Create a new project and add all .v files from src/
2- Add the constraints file from constraints/
3- Set top_counter_display as the top module
4- Run simulation as needed
5- Synthesize, implement, and program the Basys3 board

### Author

Corina Saenz
ECE 128 – FPGA Laboratory
Fall 2025
