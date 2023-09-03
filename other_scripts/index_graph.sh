#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=6G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="vg_fin"

cd /scratch/074-arabidopsis-MITEs/Lana/rice_tips/pangenome/2ndtry/

module load conda
conda activate vg

echo indexing simplified graph
vg index -t 8 -x chr01_mod.xg -g chr01_mod.gcsa -k 16 chr01_mod.vg
echo finished