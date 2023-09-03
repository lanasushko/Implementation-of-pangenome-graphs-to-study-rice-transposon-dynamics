#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=6G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="gamstats"
#SBATCH --partition=all

module load conda
conda activate vg

vg stats -a /scratch/074-arabidopsis-MITEs/Lana/rice_tips/genotyping/MH63map3_giraffe.gam -p 8 > /scratch/074-arabidopsis-MITEs/Lana/rice_tips/genotyping/MH63map3_giraffe.gam_stats.txt
