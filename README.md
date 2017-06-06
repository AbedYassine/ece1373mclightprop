ECE 1373 Course Project - Monte-Carlo Simulator for Light Popagation in Turbid Media using HLS
==============================================================================================

Summary
-------
This project is an MC light simulator in turbid media on a Xilinx FPGA using High-level Synthesis (HLS).
It takes as input the geometry specification of the tissue (in a 3D equal-sized cube reperesentation),
along with the different material optical properties (absorption and scattering coefficients, refraction
index and anisotropy factor of each material). It also expects a light source position and a seed for
the random number generator. 

The output is a BRAM of the amount of energy absorbed in each volume element. 

The design is built with an assumption of 1 million photons to simulate, but this can be changed by 
re-synthesizing again, or you can run the HLS kernel multiple times. It also assumes a maximum data size of 
8000 elements, and this can also be changed but the design has to be resynthesized. 

The output absorption can be dumped and read to be converted to any format to visualize the results.

The design also supports multiple kernels running in parallel to speed the results up.

Design Charactersitics
----------------------
Target FPGA: Xilinx Kentex Ultrascale XCKU115-2-FLVA1517E  
Maximum Frequency: 167MHz for one HLS core, and 150 MHz for multiple kernels

How to use
----------
1- Build the HLS IP core:  
   a) Change your directory to the source directory, and then to one of the directories 
      that either build a 1-core design or an 8-core design.  
   b) In a Linux terminal or a Vivado HLS command prompt on Windows, type:
            
               vivado_hls -f build_hls_core.tcl
  
      You should see the Vivado HLS tool building the IP core, synthesizing and exporting it to IP-XACT.

2- Build the Vivado IP Integrator Project:  
   a) Start Vivado and in the TCL Console, navigate to the path of the corresponding source files.  
   b) Run the following command:
            
               source build_project.tcl

      The vivado tool will build the IP integrator design, generate HDL output products and wrap the design.

Now you can synthesize, impelement and generate the bitstream.  
Note: Add a "Performance Explore" stratget in your implementation settings to meet timing.

3- After generating the bitstream, export your hardware and launch the SDK. 

4- In the SDK, make a C++ project to program the Microblaze soft-processor. We have provided some sample SDK source code
   that shows how to program the Microblaze to give the required inputs to the system, and to initialize the input BRAMs.
   Note that the input data for the material_index should be partitioned in a cyclic manner by a factor of 8 for the 
   one-core implementation or a factor of 4 for the eight-core implementation. The material optical properties should be partitioned 
   in a cyclic manner by a factor of 4.  
   The material properties should be ordered one material at a time in the following way (based on the order the material index is specified):  
   i-   Absorption Coefficient (mu_a).  
   ii-  Scattering Coefficient (mu_s).  
   iii- Anisotropy factor (g).  
   iv-  Refraction index (n).  

6- After building your project, associate the ELF file in Vivado.

7- Program your FPGA from SDK with the generated bitstream.

8- Run the SDK program. You can also open the SDK system debugger to dump the final results from the XSCT console by using some simple TCL commands.

Repository Structure
--------------------
docs:  
Contains a report and a presentation on the project.

src:  
Contains the tcl scripts used to build the project, along with the HLS source code.

Authors
-------
Abudl-Amir Yassine, Omar Ismail, Yasmin Afsharnejad. 
