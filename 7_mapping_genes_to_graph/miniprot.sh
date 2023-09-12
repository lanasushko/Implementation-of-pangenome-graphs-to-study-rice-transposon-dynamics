#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=24G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="miniprot"
#SBATCH --partition=all

cd /scratch/074-arabidopsis-MITEs/Lana/RPAN_proteins/

# date 
# echo Mapping to linear pangenome + unmapped
# /home/ssushko/miniprot/miniprot -t8 --gff /scratch/074-arabidopsis-MITEs/Lana/rice_tips/pangenome/linear_pangenome/linear_png75_andLemontunmapped.fa  /scratch/074-arabidopsis-MITEs/Lana/rice_tips/unmapped_regions/Lemontprots_protmapping/Lemont.IGDBv1.Allset.pros_onlyprimary.fasta > miniprot_Lemontprots-linearpngandunmappedLemont.gff
# date

date 
echo Mapping RPAN prots to linear pangenome
/home/ssushko/miniprot/miniprot -t8 --gff /scratch/074-arabidopsis-MITEs/Lana/rice_tips/pangenome/linear_pangenome/linear_png75.fa /scratch/074-arabidopsis-MITEs/Lana/RPAN_proteins/rpan_proteins.fa > miniprot_rpanprots-linearpng.gff
date