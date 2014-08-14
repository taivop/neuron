#!/bin/bash

cd ../fig3c

# Take one node
#SBATCH -N 1

# Take some CPUs
#SBATCH -c 2

# Take some memory
#SBATCH --mem=16000

# Set walltime
#SBATCH -t 01:00:00

# Set queue
#SBATCH -p testing

srun /storage/software/MATLAB_R2013b/bin/matlab -nodisplay -nosplash -nojvm -r "exp_STDP"

exit