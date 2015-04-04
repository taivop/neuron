#!/bin/bash

# Take one node
#SBATCH -N 1

# Take some CPUs
#SBATCH -c 2

# Take some memory
#SBATCH --mem=16000

# Set walltime
#SBATCH -t 03:00:00

# Set queue
#SBATCH -p testing

# Set array of amp indexes
#SBATCH --array=1-7

# amp indexes 1-7
srun sh single_EPSP_iocurve.sh

exit