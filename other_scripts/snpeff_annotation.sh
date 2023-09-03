#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=40G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="snpeff_annot"
#SBATCH --partition=all

module load conda
conda activate snpeff

cd /scratch/074-arabidopsis-MITEs/Lana/rice_tips/snpEff_annotation

echo Annotating snpeff
date

# snpEff ann Oryza_sativa tru-merged_forsnpeff.vcf > tru-merged13jul_annotated.vcf
snpEff eff -csvStats snpeff_stats_SVs.csv Oryza_sativa tru-merged_forsnpeff_onlySVs.vcf > tru-merged13jul_onlySVs_effects.vcf

date
echo finished