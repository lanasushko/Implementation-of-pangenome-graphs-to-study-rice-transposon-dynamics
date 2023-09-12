#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=24G
#SBATCH --time=02:00:00
#SBATCH --output=mumco.out.txt
#SBATCH --job-name="mumco"

### MUMCO ###

module load conda
source activate mumco

bash /scratch/074-arabidopsis-MITEs/Lana/MUMandCo-master/mumandco_v3.8.sh -r /scratch/074-arabidopsis-MITEs/Lana/genomes/Npb.fasta -q /scratch/074-arabidopsis-MITEs/Lana/genomes/MH63RS3.fasta -g 373245519 -o MH63RS3 -t 8
