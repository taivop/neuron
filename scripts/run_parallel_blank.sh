#!/bin/bash

# make file name
TIMESTAMP=$(date +%s)
FILENAME_BASE='out_parallel_'$TIMESTAMP

# go to script folder
cd ..

# Take one node
#SBATCH -N 1

# Take some CPUs
#SBATCH -c 1

# Take some memory
#SBATCH --mem=4096

# Set walltime
#SBATCH -t 00:01:00

# Set queue
#SBATCH -p main

for DELTAT in -13 37
do
	MATLAB_COMMAND="STDP_SingleRun(2000, "$DELTAT", 1, '"$FILENAME_BASE"')"
	srun /storage/software/MATLAB_R2013b/bin/matlab -nodisplay -nosplash -nojvm -r $MATLAB_COMMAND
done

exit