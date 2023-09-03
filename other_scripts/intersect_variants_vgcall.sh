
bcftools view  -i  'MIN(FMT/DP)>3' MH63map3_giraffe_genotypes.vcf > MH63map3_giraffe_genotypes_filtered.vcf

#intersect with variants from pangenome
bedtools intersect -a MH63map3_giraffe_genotypes_filtered.vcf -b /scratch/074-arabidopsis-MITEs/Lana/rice_tips/pangenome/constructed_75_newparamsandreannot/tru-merged.vcf -header -wao -f 1 -r > intersectMH63.vcf

paste <(cut -f1,2,3,4,5,6,7,8,9,10 intersectMH63.vcf) <(cut -f18 intersectMH63.vcf | cut -f3 -d ';') | grep -v '#' | grep 'TE_ANNOT' > intersectMH63_onlyTIPs.vcf
#luego pegar el header del archivo original añadiendo la una INFO con TE_ANNOT

#reformat
awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$5"\t"$6"\t"$7"\t"$8";"$11"\t"$9"\t"$10}' intersectMH63_onlyTIPs.vcf > intersectMH63_onlyTIPs_reformat.vcf

# count number of INS TIPS in vcf
bcftools view --types indels intersectMH63_onlyTIPs_reformat_2.vcf | bcftools filter --include 'strlen(REF)<strlen(ALT)' | bcftools view -H | wc -l
