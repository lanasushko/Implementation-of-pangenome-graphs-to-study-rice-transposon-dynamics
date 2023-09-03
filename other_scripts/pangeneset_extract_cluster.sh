#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=24G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="xtrclPGS"
#SBATCH --partition=all

cd /scratch/074-arabidopsis-MITEs/Lana/PanGene_set

#cut -f1 pangene_matrix.tr.tab > cluster_ids.txt

date
echo Extracting cluster ids
grep -f cluster_ids.txt <(grep '>' allprots.fa) | sed 's/^>//g' > protidlist.txt
date
printf '\n\n'

module load conda
conda activate seqkit

date
echo Extracting cluster prots
seqkit grep -n --pattern-file protidlist.txt allprots.fa > cluster_prots.fa
date