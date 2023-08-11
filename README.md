# Lehnert_et_al_Attention
Code and data to produce the reverse correlation kernels for mouse 3590 shown in Figure 3B in Lehnert et al, Visual attention to features and space in mice using reverse correlation (2023).

Code developed on an 8-core 64GB Linux (Ubuntu) using MATLAB (R2020a) Update 1 with all toolboxes. Approximate run time is 15 hours and requires ~6 GB of hard disk space for the mouse data (included in this download) and to save the stimulus energy.

Contact erik.cook@mcgill.ca for questions about the data format and analysis code.

In Matlab, run the main script mainCreateKernelFig3BMouse3590.m.  The analysis script is composed of three parts: 

1) Compute the stimulus energy from the raw data file (DATA/MICE/ 3590_extracted_small_nocomp.mat).  This takes a very long time to run and generates about 2.5 GB of intermediate data files containing the stimulus energy (saved in the folder DATA/ENERGY).

2) Estimate and save the reverse correlation kernels using the created intermediate data files.

3) Plot kernels.

Details of how energy and kernels are computed can be found in the Methods of the paper.
![3590](https://github.com/Swamylab/Lehnert_et_al_Attention/assets/33532310/21c293ea-e66d-4aee-b651-9fe68e6a9e1b)
