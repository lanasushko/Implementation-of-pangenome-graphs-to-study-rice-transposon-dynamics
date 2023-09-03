

#### PIPELINE TO CONCATENATE EDTA AND REPEATMASKER TE ANNOTATIONS ####

#Convert EDTA gff to bed
gff2bed < magic16.EDTA.intact.gff > magic16.EDTA.intact.bed

#Remove TSD and LTR, and leave it at 6 columns (like the RepeatMasker version)
grep -vE 'target_site_duplication|long_terminal_repeat' magic16.EDTA.intact.bed | awk '{print $1,$2,$3,$4,$5,$6}' > magic16.EDTA.intact.nostd_noltr_6cols.bed

#Concatenate both files
cat magic16.EDTA.intact.nostd_noltr_6cols.bed magic16.fa.bed > magic16_TE.bed

#Sort
bedtools sort 