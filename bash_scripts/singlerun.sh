#!/bin/bash

cd ..

# Take one node
#SBATCH -N 1

# Take some CPUs
#SBATCH -c 2

# Take some memory
#SBATCH --mem=16000

# Set walltime
#SBATCH -t 01:30:00

# Set queue
#SBATCH -p testing

srun /storage/software/MATLAB_R2013b/bin/matlab -nodisplay -nosplash -nojvm -r "SingleNeuron_IF_Taivo(20, 10, 'singlerun_groupedinputs_correlated', 'enable_groupedinputs', 1, 'enable_100x_speedup', 0);"

exit
