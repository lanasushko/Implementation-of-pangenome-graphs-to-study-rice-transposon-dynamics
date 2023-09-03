#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --output=mummer.out.txt
#SBATCH --job-name="mummer"

### MUMMER ###
module load conda 
source activate mumco

nucmer -t 8 -c 250 -b 200 -l 50 /scratch/074-arabidopsis-MITEs/Lana/genomes/Npb.fasta /scratch/074-arabidopsis-MITEs/Lana/genomes/MH63RS3.fasta
delta-filter -m -i 90 -l 100 out.delta > npb_to_MH63RS3.delta

