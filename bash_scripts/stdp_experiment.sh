#!/bin/bash

# Take one node
#SBATCH -N 1

# Take some CPUs
#SBATCH -c 2

# Take some memory
#SBATCH --mem=16000

# Set walltime
#SBATCH -t 01:40:00

# Set queue
#SBATCH -p testing

# Set array of amp indexes
#SBATCH --array=1-8

srun sh single_STDP_run.sh

exit