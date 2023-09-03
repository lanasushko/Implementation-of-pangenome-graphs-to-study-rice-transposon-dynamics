#!/bin/bash -l

# Annotating the VCF file 
# Usage: vcfannotate.sh genome_name

WGA_VC_PATH=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/wga_vc/

cd $WGA_VC_PATH'npb_to_'$1

# 1. Obtaining a file containing 2 columns: variant ID and TE annotation of the variant
awk '{print $1,$10}' 'svim_variants_'$1'_insanddels_annotation.gff' | sed 's/"//g' | sed 's/Motif://g' > temp_id_info.txt
awk '{print $1,";TE_ANNOT="$2}' temp_id_info.txt > id_info.txt

# 2. Add the INFO line to the header (after the last INFO line printed by SVIM)
sed '/##INFO=<ID=SVLEN,Number=1,Type=Integer,Description="Difference in length between REF and ALT alleles">/a ##INFO=<ID=TE_ANNOT,Number=1,Type=String,Description="Transposable element annotation">' 'svim_variants_'$1'.vcf' > temp_variants.vcf

# 3. Separate the header in another temp file
grep '#' temp_variants.vcf > temp_header.txt

# 4. Separate the variant lines in another temp file
grep -v "#" temp_variants.vcf > temp_variants_nohead.vcf

# 5. Add TE annotation to the VCF file
awk 'FNR==NR{a[$1]=$2;next}{if(a[$3]==""){a[$3]=na}; printf "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",$1,"\t",$2,"\t",$3,"\t",$4,"\t",$5,"\t",$6,"\t",$7,"\t",$8,a[$3],"\t",$9,"\t",$10}' id_info.txt temp_variants_nohead.vcf > temp_variants_annot.vcf

# 6. Concatenate header and variants into a single VCF
cat temp_header.txt temp_variants_annot.vcf > variants_annotated.vcf

# Remove temporal files
rm temp*
rm id_info.txt

# Renaming some files
#mv svim_variants_insanddels.fasta 'svim_variants_insanddels_'$1'.fasta'
mv variants_annotated.vcf 'svim_variants_'$1'_annotated.vcf'