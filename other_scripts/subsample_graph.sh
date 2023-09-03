#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=12G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="subsample"
#SBATCH --partition=all

cd /scratch/074-arabidopsis-MITEs/Lana/rice_tips/pangenome/constructed_75_newparamsandreannot

module load conda
conda activate vg

# subsample graph
echo subsampling graph
vg find -x ricepangenome75_min0_anyoverlap_reannot_nodups.vg -p Chr01:100000-200000 -E > chr01_100000_200000.vg
vg mod -t 8 -u chr01_100000_200000.vg -X 256 > chr01_100000_200000_mod.vg
vg view chr01_100000_200000_mod.vg > chr01_100000_200000_mod.gfa

echo finished





