#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --output=syri.out.txt
#SBATCH --job-name="syri"

### SYRI ###

module load conda
source activate py38

syri -c /scratch/074-arabidopsis-MITEs/Lana/Nipponbare_to_MH63RS3/SVIM/npb_to_MH63RS3_sorted.bam -r /scratch/074-arabidopsis-MITEs/Lana/genomes/Npb.fasta -q /scratch/074-arabidopsis-MITEs/Lana/genomes/MH63RS3.fasta -F B --prefix MH63RS3 --nc 8