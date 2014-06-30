cd ..
#SBATCH -N 1
#SBATCH --mem=4096
#SBATCH -t 00:00:30
#SBATCH -p testing

srun /storage/software/MATLAB_R2013b/bin/matlab -nodisplay -nosplash -nojvm -r "SingleNeuron_IF_Taivo(2000, 10, 1, 'cluster_dummy')"