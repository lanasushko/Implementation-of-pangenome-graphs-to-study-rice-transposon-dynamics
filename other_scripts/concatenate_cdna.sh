#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=6G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="cat"
#SBATCH --partition=all

cd /scratch/074-arabidopsis-MITEs/Lana/PanGene_set/oryzasativanipponbaremerged/

date
# There are 84530 .cds.faa files
cat $(ls | grep '.cds.faa' | head -n 42265) > ../allprots_1.fa
date
cat $(ls | grep '.cds.faa' | tail -n 42265) > ../allprots_2.fa
date
cd ..

cat allprots_1.fa allprots_2.fa > allprots_fa