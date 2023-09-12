#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="mnm_svim"

# This pipeline will run minimap2 and svim-asm on Npb.fasta in 'genomes' folder x query genome provided
# It will create a folder called <npb_to_queryname> inside wga_vc folder where all the output files will be stored

# INPUT VARIABLE:
# $1 = full name of query fasta file in 'genomes' folder (with .fasta particle)

echo 'Aligning and variant-calling for' $1

GENOMES_PATH=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/genomes/
WGA_VC_PATH=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/wga_vc/

REFERENCE_PATH=$GENOMES_PATH'Npb.fasta'
QUERY_PATH=$GENOMES_PATH$1

#extract only the name of query genome (without .fasta particle)
QUERYNAME=$(echo $1 | cut -d'.' -f1)

#create the working directory
mkdir $WGA_VC_PATH'npb_to_'$QUERYNAME

cd $WGA_VC_PATH'npb_to_'$QUERYNAME

WORKINGDIR=$WGA_VC_PATH'npb_to_'$QUERYNAME'/'

module load conda
conda activate minimap

minimap2 -t 8 -ax asm5 $REFERENCE_PATH $QUERY_PATH > 'npb_to_'$QUERYNAME'.sam'

samtools view -@ 8 -b 'npb_to_'$QUERYNAME'.sam' -o 'npb_to_'$QUERYNAME'.bam'
samtools sort -@ 8 'npb_to_'$QUERYNAME'.bam' -o 'npb_to_'$QUERYNAME'_sorted.bam'

conda activate svim

samtools index 'npb_to_'$QUERYNAME'_sorted.bam'
svim-asm haploid $WORKINGDIR 'npb_to_'$QUERYNAME'_sorted.bam' $REFERENCE_PATH
