#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=02:00:00
#SBATCH --output=svim.out.txt
#SBATCH --job-name="vc_rice"

### MINIMAP ###

module load conda
source activate minimap

minimap2 -t 8 -ax asm5 path_to_npb path_to_query > path_to_npb_to_query.sam

samtools view -@ 8 -b path_to_npb_to_query.sam -o path_to_npb_to_query.bam
samtools sort -@ 8 path_to_npb_to_query.bam -o path_to_npb_to_query_sorted.bam

### SVIM ###

source activate svim

samtools index path_to_npb_to_query_sorted.bam
svim-asm haploid path_to_npb_to_query_sorted.bam path_to_npb

#SVIM intersect

grep -E '##|SVTYPE=DEL' variants.vcf > svim_dels.vcf
bedtools intersect -a path_to_npb_annot.bed -b path_to_vcf.vcf -F 0.5 -f 0.8 -wo -nonamecheck > intersect.bed
#Extract the needed columns for .bed
awk '{print $7,$8,$14,$4,$5,$6}' intersect.bed > intersect_cols.bed
cut -f 3 -d ' ' intersect_cols.bed | cut -f2 -d ';' | cut -f2 -d '=' > end.bed
cut -f 3 -d ' ' intersect_cols.bed | cut -f3 -d ';' | cut -f2 -d '=' > len.bed
paste intersect_cols.bed end.bed len.bed | awk '{print $1,$2,$7,$4,$5,$6,$8}' > intersect_final.bed
rm len.bed end.bed

#Sort uniquely by 1,2,3 columns
sort -k1 -k2 -k3 intersect_final.bed > intersect_final_sorted.bed
awk -F" " '!_[$1,$2,$3]++' intersect_final_sorted.bed > intersect_final_sorted_uniq.bed


### MUM&CO ###
source activate mumco

bash /scratch/074-arabidopsis-MITEs/Lana/MUMandCo-master/mumandco_v3.8_Lana.sh -r path_to_Npb.fasta -q path_to_query.fasta -g 373245519 -o query_name_sufix -t 8

#filtering deletions and intersection with annotation
grep deletion output.SVs_all.tsv | awk '{print $1,$3,$4,$6}' | grep -v complicated | tr ' ' '\t' > output_dels.bed
bedtools intersect -a /home/lana/Documents/annotation/nipponbare_TE_sorted.bed -b query_SVs_dels.bed -F 0.5 -f 0.8 -wo -nonamecheck | awk '{print $7,$8,$9,"Deletion="$4,$6}' | sort | uniq | tr ' ' '\t' > query_TIP_dels.bed

#filtering insertions and intersection with annotation
grep insertion output.SVs_all.tsv | grep -v complicated | awk '{if ($4-$3 < 10 && $5 > 150)  print $1,$3,$4,$2,$7,$8}' | awk '{print $0,"target="$3-$2,"Insertion="$6-$5}' | tr ' ' '\t' > MH63RS3_insertion_summary.txt
awk '{print $4,$5,$6,$1";"$2";"$3}' insertion_summary.txt | tr ' ' '\t' > insertion_seq.bed
bedtools intersect -a MH63RS3_SVs_ins.bed -b /home/lana/Documents/annotation/RepeatMasker.bed/MH63RS3.fa.bed -F 0.5 -f 0.8 -wo -nonamecheck | cut -f 4,8,10 | tr ';' '\t' | awk '{print $1,$2,$3,"Insertion="$4";"$5,$6}' | tr ' ' '\t' | sort | uniq > MH63RS3_TIP_ins.bed

cat IR64_TIP_dels.bed IR64_TIP_ins.bed | sort -k1,1 -k2,2n | tr '=' '\t' | awk '{print $1,$2,$3,$5,$4,$6}' | tr ' ' '\t'  > IR64_TIPs.bed

### MINIMAP ###

# if we want to use SYRI with minimap2 output, use -eqx option for adequate CIGAR string (write =/X CIGAR operators)
source activate minimap

minimap2 -t 8 -ax -eqx asm5 path_to_npb path_to_query > path_to_npb_to_query.sam

### SYRI ###

source activate py38

python3 syri -c out.sam -r refgenome -q qrygenome -F S -prefix prefix_ --nc 8


