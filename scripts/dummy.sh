cd ..
sbatch -N 1 --mem=4096 -t 00:00:30 -p testing
/storage/software/MATLAB_R2013b/bin/matlab -nodisplay -nosplash -nojvm -r "SingleNeuron_IF_Taivo(2000, 10, 1, 'cluster_dummy')"