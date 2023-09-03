#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=6G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="extractpaths"
#SBATCH --partition=all

module load conda
conda activate vg

vg paths -x /scratch/074-arabidopsis-MITEs/Lana/rice_tips/pangenome/constructed_75_newparamsandreannot/ricepangenome75_newindex.xg -E > /scratch/074-arabidopsis-MITEs/Lana/rice_tips/pangenome/constructed_75_newparamsandreannot/ricepangenome75_path_lengths.txt