# This script will reannotate and refilter all the files inside a selected wga_vc folder from a new .lengths file

echo 'Reannotating '$1
cd '/scratch/074-arabidopsis-MITEs/Lana/rice_tips/wga_vc/npb_to_'$1
# Change some names of previously-generated annotation files to make them compatible
mv 'svim_variants_'$1'.vcf' variants.vcf 


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
paste -d ' ' <(cat svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength.gff) <(awk '{print ($5-$4+1)}' svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength.gff) > svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif.gff
rm svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength.gff

#sorting uniquely by SV name and RepeatMasker annotation overlap
sort -k1V,1 -k13nr,13 svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif.gff | awk -F" " '!_[$1]++' > svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_su.gff
rm svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif.gff
head svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_su.gff

#intersect hit>0.5*SV
awk '$13>$12*0.5{print $0}' svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_su.gff > svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV.gff
printf '\n'
wc -l svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV.gff
rm svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_su.gff

#intersect hit>0.8*TE
awk '$13>$11*0.8{print $0}' svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV.gff > svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV_0.8TE.gff

printf '\n'
wc -l svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV_0.8TE.gff
printf '\n'
rm svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV.gff

# Remove false positive families from the TE lib
grep -v -E 'Os0414_INT|Os2860|Os0943|Os0674|Os2340|Os1611|Os0027|DTX_incomp_Osati_B_G2045_Map6|DTX_incomp_chim_Osati_B_R4158_Map18|6035756|22531107|16542740|DTX_comp_Osati_B_R475_Map20' svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV_0.8TE.gff > svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV_0.8TE_removedfamilies.gff

echo 'Number of TIPs in '$1
wc -l svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV_0.8TE_removedfamilies.gff
printf '\n'

rm svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV_0.8TE.gff

# ----------------------------- the format of the output file is (tab separated except last three columns):-------------------------------------#
# variant_name tool mechanism identification_start identification_end divergence strand frame TE_name TE_full_length SV_full_length Overlap


# Annotating the VCF file 

# 1. Obtaining variant ID + TE annotation file
awk '{print $1,$10}' svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV_0.8TE_removedfamilies.gff | sed 's/"//g' | sed 's/Motif://g' > temp_id_info.txt
awk '{print $1,";TE_ANNOT="$2}' temp_id_info.txt > id_info.txt
head id_info.txt

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
mv svim_variants_insanddels.fasta.out_sorted_9cols_withTElengths_withSVlength_withDif_0.5SV_0.8TE_removedfamilies.gff 'svim_variants_'$1'_insanddels_annotation.gff'
mv variants_annotated.vcf 'svim_variants_'$1'_annotated.vcf'

echo 'Finished reannotating '$1
printf '\n\n'