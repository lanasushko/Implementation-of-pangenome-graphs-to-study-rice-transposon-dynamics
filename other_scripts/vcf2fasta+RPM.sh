#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=2G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="vcf2fasta+RPM"

# Usage: vcf2fasta+RPM.sh variants.vcf
# $1 = vcf output of SVIM

# This part of the script will extract a fasta file from variants.vcf that will contain the variant sequences (only for insertions and deletions)

grep 'SVTYPE=INS' $1 > svim_variants_ins.vcf
grep 'SVTYPE=DEL' $1 > svim_variants_dels.vcf

# for dels
grep -v '##' svim_variants_dels.vcf | cut -f3,4 | tr "\t" "\n"  | sed -e '/^svim/ s/./>&/' > svim_variants_dels.fasta

# for ins
grep -v '##' svim_variants_ins.vcf | cut -f3,5 | tr "\t" "\n" | sed -e '/^svim/ s/./>&/' > svim_variants_ins.fasta

cat svim_variants_dels.fasta svim_variants_ins.fasta > svim_variants_insordels.fasta
rm svim_variants_dels.fasta svim_variants_ins.fasta


# This part of the script will run repeatmasker to identify the SV sequences in the fasta file

module load wublast
module load hmmer
module load trf
module load repeatmasker


RepeatMasker -s -nolow -norna -no_is -div 25 -pa 8 -e wublast -gff -lib /scratch/074-arabidopsis-MITEs/Lana/rice_tips/RPM_library/MAGIC16_panTElib_v1.fa svim_variants_insordels.fasta

