#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=24G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="rmadt"
#SBATCH --partition=all


cd /scratch/074-arabidopsis-MITEs/Lana/PanGene_set

grep -vE '\.0[2-9]|\.1[0-9]|\.[2-9]|_0[2-9]|_1[0-9]|\-0[2-9]\s|\-1[0-9]\s' idlist.txt > idlist_filtered.txt

echo Finished removal

module load conda
conda activate seqkit

seqkit grep -n --pattern-file idlist_filtered.txt allcdna.fa > cluster_cdna.fa