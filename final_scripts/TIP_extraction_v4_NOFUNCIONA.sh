#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=2G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="TIPxtrct"

# Usage: TIP_extraction_v3.sh folder
# $1 = name of an already processed genome (aligned to Npb (rice reference) and variants called with SVIM) that has a folder 'npb_to_<query>' inside wga_vc that contains the variants.vcf file for this genome. $1 is only the <query> part of the folder name!

echo 'TIP extraction from the VCF output of' $1

WGA_VC_PATH=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/wga_vc/

cd $WGA_VC_PATH'npb_to_'$1

#### REPEATMASKER SCRIPT ####

# This part of the script will extract a fasta file from variants.vcf that will contain the variant sequences (only for insertions and deletions)

grep 'SVTYPE=INS' variants.vcf > svim_variants_ins.vcf
grep 'SVTYPE=DEL' variants.vcf > svim_variants_dels.vcf

# for dels
grep -v '##' svim_variants_dels.vcf | cut -f3,4 | tr "\t" "\n"  | sed -e '/^svim/ s/./>&/' > svim_variants_dels.fasta

# for ins
grep -v '##' svim_variants_ins.vcf | cut -f3,5 | tr "\t" "\n" | sed -e '/^svim/ s/./>&/' > svim_variants_ins.fasta

cat svim_variants_dels.fasta svim_variants_ins.fasta > svim_variants_insanddels.fasta
rm svim_variants_dels.vcf svim_variants_ins.vcf svim_variants_dels.fasta svim_variants_ins.fasta


# This part of the script will run repeatmasker to identify the SV sequences in the fasta file

module load wublast
module load hmmer
module load trf
module load repeatmasker


RepeatMasker -s -nolow -norna -no_is -div 25 -pa 8 -e wublast -gff -lib /scratch/074-arabidopsis-MITEs/Lana/rice_tips/RPM_library/MAGIC16_panTElib_v3.fa svim_variants_insanddels.fasta



#### TIP EXTRACTION ####

#sort the file by "name with numbers" 
grep -v '##' svim_variants_insanddels.fasta.out.gff | sort -V > svim_variants_insanddels.fasta.out_sorted.gff

#remove extra characters from field 9 (this is necessary to remove anything from field 9 except the TE name -> to be able to add TE lengths later)
sed -i 's/Target "Motif://g' svim_variants_insanddels.fasta.out_sorted.gff
sed -i 's/"//g' svim_variants_insanddels.fasta.out_sorted.gff
sed -i 's/-int//g' svim_variants_insanddels.fasta.out_sorted.gff

#remove extra fields: this removes the fields 10 and 11 that contain TE match coordinates
paste <(cut -f1,2,3,4,5,6,7,8 svim_variants_insanddels.fasta.out_sorted.gff) <(cut -f9 svim_variants_insanddels.fasta.out_sorted.gff | cut -d' ' -f1) > svim_variants_insanddels.fasta.out_sorted_9cols.gff
rm svim_variants_insanddels.fasta.out_sorted.gff

#add TE lengths (MAGIC16_panTElib_v3.lengths contains TE names and their lengths)
awk 'FNR==NR{a[$1]=$2;next}{if(a[$9]==""){a[$9]=na}; printf "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",$1,"\t",$2,"\t",$3,"\t",$4,"\t",$5,"\t",$6,"\t",$7,"\t",$8,"\t",$9," ",a[$9]}' /scratch/074-arabidopsis-MITEs/Lana/rice_tips/RPM_library/MAGIC16_panTElib_v3.lengths svim_variants_insanddels.fasta.out_sorted_9cols.gff > svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths.gff
rm svim_variants_insanddels.fasta.out_sorted_9cols.gff 

#obtain lengths of variants (variants.vcf is the original SVIM output)
paste <(grep -v '#' variants.vcf | awk '{print $3}') <(grep -v '#' variants.vcf | awk '{print $8}' | cut -f3 -d ';' | cut -f2 -d '=' | sed 's/-//g') > svim_variants_length.txt

#add the SV lengths to the gff file
awk 'FNR==NR{a[$1]=$2;next}{if(a[$1]==""){a[$1]=na}; printf "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",$1,"\t",$2,"\t",$3,"\t",$4,"\t",$5,"\t",$6,"\t",$7,"\t",$8,"\tTarget \"Motif:",$9,"\" ",$10," ",a[$1]}' svim_variants_length.txt svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths.gff > svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength.gff
rm svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths.gff svim_variants_length.txt

#add the SV-TE overlap column
paste -d ' ' <(cat svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength.gff) <(awk '{print $5-$4}' svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength.gff) > svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif.gff
rm svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength.gff

#sorting uniquely by SV name and RepeatMasker annotation overlap
sort -k1V,1 -k13nr,13 svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif.gff | awk -F" " '!_[$1]++' > svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_su.gff
rm svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif.gff

#intersect TE>0.5*SV
awk '$11>$12*0.5{print $0}' svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_su.gff > svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV.gff
rm svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_su.gff

#intersect SV>0.8*TE
awk '$12>$11*0.8{print $0}' svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV.gff > svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV_0.8TE.gff
rm svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV.gff


# ----------------------------- the format of the output file is (tab separated except last three columns):-------------------------------------#
# variant_name tool mechanism identification_start identification_end divergence strand frame TE_name TE_full_length SV_full_length Overlap


# Annotating the VCF file 

# 1. Obtaining variant ID + TE annotation file
awk '{print $1,$10}' svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV_0.8TE.gff | sed 's/"//g' | sed 's/Motif://g' > temp_id_info.txt
awk '{print $1,";TE_ANNOT="$2}' temp_id_info.txt > id_info.txt

# 2. Add the INFO line to the header
sed '/##INFO=<ID=SVLEN,Number=1,Type=Integer,Description="Difference in length between REF and ALT alleles">/a ##INFO=<ID=TE_ANNOT,Number=1,Type=String,Description="Transposable element annotation">' variants.vcf > temp_variants.vcf

# 3. Separate the header
grep '#' temp_variants.vcf > temp_header.txt

# 4. Separate the variant lines
grep -v "#" temp_variants.vcf > temp_variants_nohead.vcf

# 5. Add TE annotation
awk 'FNR==NR{a[$1]=$2;next}{if(a[$3]==""){a[$3]=na}; printf "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",$1,"\t",$2,"\t",$3,"\t",$4,"\t",$5,"\t",$6,"\t",$7,"\t",$8,a[$3],"\t",$9,"\t",$10}' id_info.txt temp_variants_nohead.vcf > temp_variants_annot.vcf

# 6. Concatenate header and variants
cat temp_header.txt temp_variants_annot.vcf > variants_annotated.vcf

# Remove temporal files
rm temp*
rm id_info.txt

# Renaming some files
mv variants.vcf 'svim_variants_'$1'.vcf'
mv svim_variants_insanddels.fasta 'svim_variants_insanddels_'$1'.fasta'
mv svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV_0.8TE.gff 'svim_variants_'$1'_insanddels_annotation.gff'
mv variants_annotated.vcf 'svim_variants_'$1'_annotated.vcf'
