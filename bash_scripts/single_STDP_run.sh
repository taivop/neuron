cd ../tests

/storage/software/MATLAB_R2013b/bin/matlab -nodisplay -nosplash -nojvm -r "exp_STDP($SLURM_ARRAY_TASK_ID)"