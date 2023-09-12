#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --time=02:00:00
#SBATCH --output=sort.out.txt
#SBATCH --job-name="minimap"

module load conda
source activate minimap

minimap2 -t 8 -ax asm5 --eqx /scratch/074-arabidopsis-MITEs/Lana/genomes/Npb.fasta /scratch/074-arabidopsis-MITEs/Lana/genomes/MH63RS3_12chr.fasta > /scratch/074-arabidopsis-MITEs/Lana/Nipponbare_to_MH63RS3/SYRI/npb_to_MH63RS3_eqx.sam;

samtools view -@ 8 -b /scratch/074-arabidopsis-MITEs/Lana/Nipponbare_to_MH63RS3/SYRI/npb_to_MH63RS3_eqx.sam -o /scratch/074-arabidopsis-MITEs/Lana/Nipponbare_to_MH63RS3/SYRI/npb_to_MH63RS3_eqx.bam;
samtools sort -@ 8 /scratch/074-arabidopsis-MITEs/Lana/Nipponbare_to_MH63RS3/SYRI/npb_to_MH63RS3_eqx.bam -o /scratch/074-arabidopsis-MITEs/Lana/Nipponbare_to_MH63RS3/SYRI/npb_to_MH63RS3_eqx_sorted.bam
