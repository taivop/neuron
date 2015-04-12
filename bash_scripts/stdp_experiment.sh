#!/bin/bash

cd ../tests

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

srun sh single_STDP_run.sh

exit