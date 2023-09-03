
#### ==== Pipeline 1:  to identify TIPs on assemblies based on Minimap2 and SVIM-ASM  ==============


# 1) Run the intact module of EDTA: https://github.com/oushujun/EDTA   # Not needed if TE annotation is available

perl /home/rcastanera/bin/EDTA/EDTA.pl --genome $1 --sensitive 0 --anno 0 --threads 12

	# 1.2) Concat the intact EDTA elements with any available TE annotation (ie, coming from repeatMasker).

# 2) Align genomes with minimap2: https://lh3.github.io/minimap2/minimap2.html

minimap2 -ax asm5 /scratch/074-arabidopsis-MITEs/newalmondgenome/Texas_1/Texas_F1_K80_chr.fasta /scratch/074-arabidopsis-MITEs/newalmondgenome/Texas_0/Texas_F0_K80_chr.fasta > texasF0_to_F1.sam;

samtools view -@ 8 -b texasF0_to_F1.sam -o texasF0_to_F1.bam;
samtools sort -@ 8 -o texasF0_to_F1.bam texasF0_to_F1_sorted.bam


# 2) detect SVs with SVIM-asm: https://github.com/eldariont/svim-asm

samtools index texasF0_to_F1_sorted.bam;
svim-asm haploid /scratch/074-arabidopsis-MITEs/newalmondgenome/Genome_alignment/minimap2 texasF0_to_F1_sorted.bam /scratch/074-arabidopsis-MITEs/newalmondgenome/Texas_1/Texas_F1_K80_chr.fasta

# 3) Identify heterozygous TEs from deletions (Intersect deletions with TEannot).  
# IMPORTANT. In this case I retreived the positions of the TE annot from the Bedtools intersect, but in most cases is better to retreive the original positions from the SV. (use bedtools -wo and awk to filter the columns)

grep -E '##|SVTYPE=DEL' svim_variants.vcf > svim_dels.vcf
bedtools intersect -a /scratch/074-arabidopsis-MITEs/newalmondgenome/db/Texas_F1_HiConf_TE_v3.gff3 -b svim_dels.vcf -F 0.5 -f 0.8 -wa > Hetero_TE_F1_F05_f08.gff3     # Present in F0
bedtools intersect -a /scratch/074-arabidopsis-MITEs/newalmondgenome/db/Texas_F0_HiConf_TE_v3.gff3 -b F0_ref_dels.vcf -F 0.5 -f 0.8 -wa > Hetero_TE_F0_F05_f08.gff3   # Present in F1

# When multiple genomes are available, insertions sould be checked instead of doing reciprocal analyses of deletions.
# ej, grep the insertions, retreive the positions and overlap them with the same intersct parameters (-F 0.5 -f 0.8). 
# If the posion of the insertion is not available, then the sequence must be extracted and we will look for TEs inside (ie, with RepeatMasker: https://www.repeatmasker.org/ )



#### ==== Pipeline 2: Alternative method using Nucmer and MUM&Co  ==============


# 1) Align genomes with nucmer from the Mummer4 package

https://github.com/mummer4/mummer

	#Parameters:

nucmer -c 250 -b 200 -l 50   
							 #c = minimum length of a cluster of matches (65)
							 #b = distance an alignment extension will attempt to extend poor scoring regions before giving up (200)
							 #l = minimum length of a single exact match (20)
							 #MUMCO uses --maxmatch as default = Use all anchor matches regardless of their uniqueness (false)

delta-filter -m -i 90 -l 100
							 #m = Many-to-many alignment allowing for rearrangements
							 #i = minimum alignment identity [0, 100], default 0
							 #l = minimum alignment length, default 0

# 2) Use MUM&Co to detect Structural variants (output is a ".tsvfile")

https://github.com/SAMtoBAM/MUMandCo

	# extract DELs (150bp-30Kb) from mummer and intersect with TEs

grep deletion NPB_IR64_Z.SVs_all.tsv | awk '{print $1,$3,$4,$6}' | grep -v complicated | tr ' ' '\t' > IR64_dels.bed
bedtools intersect -a /Users/raulcastanera/Documents/Manuscripts/3D-genome_rice/TIPs/IRGSP/IRGSP-1.0_genome.fasta.out.bed -b IR64_dels.bed -F 0.5 -f 0.8 -wo -nonamecheck | awk '{print $7,$8,$9,"Deletion="$4,$6}' | sort | uniq | tr ' ' '\t' > IR64_TIP_dels.bed

	# extract INS from mummer and intersect with TEs

grep insertion NPB_IR64_Z.SVs_all.tsv | grep -v complicated | awk '{if ($4-$3 < 10 && $5 > 150)  print $1,$3,$4,$2,$7,$8}' | awk '{print $0,"target="$3-$2,"Insertion="$6-$5}' | tr ' ' '\t' > insertion_summary.txt
awk '{print $4,$5,$6,$1";"$2";"$3}' insertion_summary.txt | tr ' ' '\t' > insertion_seq.bed
bedtools intersect -a insertion_seq.bed -b OsIR64RS1_genomic.fasta.out.bed -F 0.5 -f 0.8 -wo -nonamecheck | cut -f 4,8,10 | tr ';' '\t' | awk '{print $1,$2,$3,"Insertion="$4";"$5,$6}' | tr ' ' '\t' | sort | uniq > IR64_TIP_ins.bed

	# Combine INS and DELs into a single TIP file

cat IR64_TIP_dels.bed IR64_TIP_ins.bed | sort -k1,1 -k2,2n | tr '=' '\t' | awk '{print $1,$2,$3,$5,$4,$6}' | tr ' ' '\t'  > IR64_TIPs.bed

