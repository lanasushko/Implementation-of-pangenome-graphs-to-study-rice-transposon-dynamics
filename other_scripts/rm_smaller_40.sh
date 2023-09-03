#!/bin/bash -l

# Removing variants that are smaller than 40bp

WGA_VC_PATH=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/wga_vc/

cd $WGA_VC_PATH'npb_to_'$1

cat <(awk '$3 ~ /svim_asm.DEL*/ {if(length($4)>40) print $0}' 'svim_variants_'$1'_annotated.vcf') <(awk '$3 ~ /svim_asm.INS*/ {if(length($5)>40) print $0}' 'svim_variants_'$1'_annotated.vcf') <(grep -v -E 'svim_asm.DEL*|svim_asm.INS*' 'svim_variants_'$1'_annotated.vcf') | sort > 'svim_variants_'$1'_annotated_>40bp.vcf'
