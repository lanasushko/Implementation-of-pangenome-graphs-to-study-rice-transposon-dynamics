#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=24G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="grphgenotype"
#SBATCH --partition=all

# This script maps short reads to the pangenome graph from vg and performs variant calling to genotype the variants

module load conda
conda activate vg

cd /scratch/074-arabidopsis-MITEs/Lana/rice_tips/pangenome/constructed_75_newparamsandreannot

### MAP ###
# Giraffe to map reads to the graph
echo mapping giraffe
date
vg giraffe -x ricepangenome75_newindex.xg -t 8 -f /scratch/074-arabidopsis-MITEs/Lana/rice_tips/genotyping/SRR3234369sub15x_1.fastq -f /scratch/074-arabidopsis-MITEs/Lana/rice_tips/genotyping/SRR3234369sub15x_2.fastq > /scratch/074-arabidopsis-MITEs/Lana/rice_tips/genotyping/MH63map3_giraffe.gam
date

# vg map to map reads to the graph
# echo mapping vgmap
# date
# vg map -x pangenome75.xg -g index.gcsa -t 8 -f /scratch/074-arabidopsis-MITEs/Lana/genotyping/SRR3234369sub15x_1.fastq -f /scratch/074-arabidopsis-MITEs/Lana/genotyping/SRR3234369sub15x_2.fastq > /scratch/074-arabidopsis-MITEs/Lana/genotyping/MH63map_vgmap.gam
# date

### GENOTYPE ###
# Compute the support (we could also reuse aln.pack from above) [is it needed?]
echo pack giraffe
date
vg pack -t 8 -x ricepangenome75_newindex.xg -g /scratch/074-arabidopsis-MITEs/Lana/rice_tips/genotyping/MH63map3_giraffe.gam -o /scratch/074-arabidopsis-MITEs/Lana/rice_tips/genotyping/MH63map3_giraffe.pack
date
# echo pack vgmap
# vg pack -t 8 -x pangenome75.xg -g /scratch/074-arabidopsis-MITEs/Lana/genotyping/MH63map_vgmap.gam -o /scratch/074-arabidopsis-MITEs/Lana/genotyping/MH63map_vgmap.pack

# Genotype the VCF (use -v)
echo call giraffe
date
vg call -t 8 ricepangenome75_newindex.xg -k /scratch/074-arabidopsis-MITEs/Lana/rice_tips/genotyping/MH63map3_giraffe.pack > /scratch/074-arabidopsis-MITEs/Lana/rice_tips/genotyping/MH63map3_giraffe_genotypes.vcf
date
# echo call vgmap
# vg call -t 8 pangenome75.xg -k /scratch/074-arabidopsis-MITEs/Lana/genotyping/MH63map_vgmap.pack > /scratch/074-arabidopsis-MITEs/Lana/genotyping/MH63map_vgmap_genotypes.vcf

date
echo finished 