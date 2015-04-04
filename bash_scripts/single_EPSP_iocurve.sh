cd ../tests

/storage/software/MATLAB_R2013b/bin/matlab -nodisplay -nosplash -nojvm -r "exp_InputRate_EPSP($SLURM_ARRAY_TASK_ID)"