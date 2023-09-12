#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --time=02:00:00
#SBATCH --output=svim.out.txt
#SBATCH --job-name="svim"

module load conda
source activate svim

samtools index npb_to_MH63RS3_sorted.bam;
svim-asm haploid /scratch/074-arabidopsis-MITEs/Lana npb_to_MH63RS3_sorted.bam Npb.fasta

