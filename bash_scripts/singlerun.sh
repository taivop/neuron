#!/bin/bash

cd ..

# Take one node
#SBATCH -N 1

# Take some CPUs
#SBATCH -c 2

# Take some memory
#SBATCH --mem=16000

# Set walltime
#SBATCH -t 00:30:00

# Set queue
#SBATCH -p testing

srun /storage/software/MATLAB_R2013b/bin/matlab -nodisplay -nosplash -nojvm -r "SingleNeuron_IF_Taivo(100, 60, 'singlerun_60Hz_withmeta', 'enable_metaplasticity', 1)"

exit