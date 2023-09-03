#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --time=02:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="bam2paf"
#SBATCH --partition=all

module load conda
source activate minimap

cd /scratch/074-arabidopsis-MITEs/Lana/rice_tips/wga_vc/npb_to_Lemont/

samtools view -@ 8 -h npb_to_Lemont_sorted.bam -o npb_to_Lemont_sorted.sam
paftools.js sam2paf npb_to_Lemont_sorted.sam > npb_to_Lemont_sorted.paf
