#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=6G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="build_graph"
#SBATCH --partition=all

# This script merges VCF files and creates a pangenome with VG inside a folder called constructed_

cd /scratch/074-arabidopsis-MITEs/Lana/rice_tips/pangenome/full_png/variation_total

module load conda
conda activate bcftools

mkdir constructed_japonica

INPUT=$(cat variantfiles_japonica.txt)

echo $INPUT
# To start, we merge multiple VCFs (each with their own sample) and ensure there are no multi-allelic entries via:
# Parameters:
#   -m, --merge <string>               allow multiallelic records for <snps|indels|both|all|none|id>#·
#   Error: Duplicate sample names (Sample), use --force-samples to proceed anyway. ---> this is why I added --force-samples
bcftools merge -m none --force-samples -o constructed_japonica/merged.vcf $INPUT

cd constructed_japonica/

bgzip merged.vcf

# index bcftools merged
tabix -p vcf merged.vcf.gz

# merge highly similar variants with truvari
conda activate truvari

# truvari collapse to merge similar variants
truvari collapse -i merged.vcf.gz -p 0.8 -P 0.5 -o tru-merged.vcf.gz

# index the file
conda activate bcftools

tabix -p vcf tru-merged.vcf.gz

# pangenome construction
# conda activate vg

# construct graph wih vg
# vg construct -r /scratch/074-arabidopsis-MITEs/Lana/rice_tips/genomes/Npb.fasta -v tru-merged.vcf.gz -a -S -f -t 8 > pangenome27.vg

# store the graph in the xg/gcsa index pair
# echo indexing full graph
# vg index -t 8 -x pangenome27.xg -g pangenome27.gcsa -k 16 pangenome27.vg

# subsample graph
# echo subsampling graph
# vg find -x pangenome1.xg -p Chr01:100000-100500 -E > chr01_100000_100500.vg
# vg index -t 8 -x chr01_100000_100500.xg -g chr01_100000_100500.gcsa -k 16 chr01_100000_100500.vg

# # simplify graph (join 32bp nodes)
# echo simplifying graph
# vg mod -t 8 -u chr01_100000_100500.vg -X 256 > chr01_100000_100500_mod.vg
# vg view chr01_100000_100500_mod.vg > chr01_100000_100500_mod.gfa

# echo indexing simplified graph
# vg index -t 8 -x chr01_100000_100500_mod.xg -g chr01_100000_100500_mod.gcsa -k 16 chr01_100000_100500_mod.vg

echo finished

# vg viz -x 2chr01_100000_105000_mod.vg -o graph3.svg -X 1000 -Y 1000



