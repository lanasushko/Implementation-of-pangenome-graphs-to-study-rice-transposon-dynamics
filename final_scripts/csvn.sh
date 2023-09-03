#!/bin/bash -l

#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=6G
#SBATCH --time=12:00:00
#SBATCH --output=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/out/out_%x.%j.out
#SBATCH --job-name="csvn"

# CSVN = change SV name & compress

module load conda
conda activate bcftools

# WGA_VC_PATH=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/wga_vc/

# cd $WGA_VC_PATH

# N=1

# for x in npb_to_*; do
#     cd $x; 
#     GNAME=$(echo $x | sed 's/npb_to_//g');
#     # Replace the name of each variant to identify it with the name of the genome
#     sed 's/svim_asm/'$N'/g' 'svim_variants_'$GNAME'_annotated.vcf' > 'svim_variants_'$GNAME'_annotated_csvn.vcf';
#     bgzip 'svim_variants_'$GNAME'_annotated_csvn.vcf';
#     tabix -p vcf 'svim_variants_'$GNAME'_annotated_csvn.vcf.gz';
#     cp -t /scratch/074-arabidopsis-MITEs/Lana/rice_tips/pangenome/full_png 'svim_variants_'$GNAME'_annotated_csvn.vcf.gz.tbi' 'svim_variants_'$GNAME'_annotated_csvn.vcf.gz';
#     N=$((N+1));
#     cd ..;
# done

WGA_VC_PATH=/scratch/074-arabidopsis-MITEs/Lana/rice_tips/wga_vc/

cd $WGA_VC_PATH

DIRS='npb_to_117425
npb_to_117534
npb_to_125619
npb_to_125827
npb_to_127518
npb_to_127564
npb_to_127652
npb_to_127742
npb_to_128077
npb_to_132278
npb_to_132424
npb_to_Azucena
npb_to_HZ
npb_to_IR64
npb_to_J4155S
npb_to_LK638S
npb_to_MH63RS3
npb_to_XL628S
npb_to_ZS97RS3
npb_to_Lemont
npb_to_NamRoo
npb_to_02428
npb_to_LJ
npb_to_DHX2
npb_to_ZH11
npb_to_KY131
npb_to_Kosh
npb_to_9311
npb_to_Basmati1
npb_to_CN1
npb_to_DG
npb_to_CG14
npb_to_FS32
npb_to_G46
npb_to_D62
npb_to_FH838
npb_to_G8
npb_to_R527
npb_to_G630
npb_to_TM
npb_to_II32
npb_to_Tumba
npb_to_S548
npb_to_Y3551
npb_to_YX1
npb_to_R498
npb_to_WSSM
npb_to_Y58S
npb_to_GWHBFHN00000000
npb_to_GWHBFHO00000000
npb_to_GWHBFHQ00000000
npb_to_GWHBFJC00000000
npb_to_GWHBFJD00000000
npb_to_GWHBFJH00000000
npb_to_GWHBFJO00000000
npb_to_GWHBFJP00000000
npb_to_GWHBFKA00000000
npb_to_GWHBFKB00000000
npb_to_GWHBFKL00000000
npb_to_GWHBFKM00000000
npb_to_GWHBFMI00000000
npb_to_GWHBFMO00000000
npb_to_GWHBFND00000000
npb_to_GWHBFNF00000000
npb_to_GWHBFNI00000000
npb_to_GWHBFNU00000000
npb_to_GWHBFNY00000000
npb_to_GWHBFOE00000000
npb_to_GWHBFOS00000000
npb_to_GWHBFPC00000000
npb_to_GWHBFPS00000000
npb_to_GWHBFPV00000000
npb_to_GWHBFQV00000000
npb_to_GWHBFQW00000000
npb_to_GWHBFQX00000000'

N=1

for x in $DIRS; do
    cd $x; 
    GNAME=$(echo $x | sed 's/npb_to_//g');
    # Replace the name of each variant to identify it with the name of the genome
    rm *_csvn.vcf.gz*;
    sed 's/svim_asm/'$N'/g' 'svim_variants_'$GNAME'_annotated_nosvimdups.vcf' > 'svim_variants_'$GNAME'_annotated_csvn.vcf';
    bgzip 'svim_variants_'$GNAME'_annotated_csvn.vcf';
    tabix -p vcf 'svim_variants_'$GNAME'_annotated_csvn.vcf.gz';
    cp -t /scratch/074-arabidopsis-MITEs/Lana/rice_tips/pangenome/variation_total 'svim_variants_'$GNAME'_annotated_csvn.vcf.gz' 'svim_variants_'$GNAME'_annotated_csvn.vcf.gz.tbi';
    N=$((N+1));
    echo 'Moved '$GNAME
    cd ..;
done

