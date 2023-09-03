#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=2G
#SBATCH --time=12:00:00
#SBATCH --output=RMout1.txt
#SBATCH --job-name="RepeatMasker_1"


# $1 = TE library
# $2 = Assembly

module load wublast
module load hmmer
module load trf
module load repeatmasker


RepeatMasker -s -nolow -norna -no_is -div 25 -pa 8 -e wublast -gff -lib MAGIC16_panTElib_v1.fa svim_ins.fasta