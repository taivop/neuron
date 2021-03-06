#!/bin/bash

cd ..

# Take one node
#SBATCH -N 1

# Take some CPUs
#SBATCH -c 1

# Take some memory
#SBATCH --mem=4096

# Set walltime
#SBATCH -t 00:10:00

# Set queue
#SBATCH -p main

srun /storage/software/MATLAB_R2013b/bin/matlab -nodisplay -nosplash -nojvm -r "SingleNeuron_IF_Taivo(2000, 10, 1, 'cluster_dummy')"

exit