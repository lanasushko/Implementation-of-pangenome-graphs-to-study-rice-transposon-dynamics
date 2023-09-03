#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=24G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="gmap"
#SBATCH --partition=all

cd /scratch/074-arabidopsis-MITEs/Lana/PanGene_set

module load conda
source activate gmap

#date
#echo Building database
#gmap_build -t 8 -d png75 -D gmap75 -k 13 /scratch/074-arabidopsis-MITEs/Lana/rice_tips/pangenome/linear_pangenome/linear_png75.fa

date 
echo Mapping
gmap -t 8 -n 1 -d png75 -D gmap75 --max-intronlength-middle 1000 --max-intronlength-ends 1000 -f 2 cluster_cdna_nonredundant.fa > PGScdnamap_2.gff3

date
echo Finished