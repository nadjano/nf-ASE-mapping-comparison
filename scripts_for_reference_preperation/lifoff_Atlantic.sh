#conda activate liftoff


OUT="output/liftoff_v6"
INPUT="input"
REFERENCE="reference"


mkdir -p $INPUT/liftoff

mkdir -p $OUT
cd $OUT

echo -e "mRNA\nexon\nCDS" > $OUT/feature_types.txt

# chromosome list to iterate over
chromosomes=(01 02 03 04 05 06 07 08 09 10 11 12)

coverage=0.9
identity=0.9

# Put all sequence per gene region in one line to make is easier to extract sequences
perl -pe '/^>/ ? print "\n" : chomp' [input_dir]/ATL_v3.asm.fa | tail -n +2 > [input_dir]/ATL_v3.asm_oneline.fa

# Loop over haplotypes and chromosomes
for haplotype in 0 1 2 3 4; do
    # Clear or create a new chromosome map file for each haplotype
    chr_map_file="$OUT/chr_map_${haplotype}.csv"
    > $chr_map_file
    
    for chr in ${chromosomes[@]}; do
        echo $chr
        echo -e "chr${chr},chr${chr}_${haplotype}" >> $chr_map_file
        #echo -e "DMv6.1_chr${chr},chr${chr}_${haplotype}" >> $chr_map_file
    done

    # select only the haplotype assembly
    grep -f <(cut -d',' -f2 $chr_map_file) [input_dir]/ATL_v3.asm_oneline.fa -A 1 > $OUT/ATL_v3.asm_oneline_h${haplotype}.fa
    # if the haplotype is 0, we add the scaffolds that are not in the haplotype assembly
    if [ $haplotype -eq 0 ]; then
        grep "scf_" -A1 ATL_v3.asm_oneline.fa >> $OUT/ATL_v3.asm_oneline_h${haplotype}.fa
    fi
    liftoff -g $REFERENCE/v6.1/DM_1-3_516_R44_potato.v6.1.repr_hc_gene_models.gff3   -o $OUT/v6_2Atl_liftoff_${haplotype}_a${coverage}s${identity}.gff -f $OUT/feature_types.txt -chroms $chr_map_file -p 24 -a $coverage -s $identity -copies $OUT/ATL_v3.asm_oneline_h${haplotype}.fa $REFERENCE/v6.1/DM_1-3_516_R44_potato_genome_assembly.v6.1.fa

    
    # Add the haplotype in front of each 'Soltu.DM' appearance
    sed -i "s/Soltu.DM/hap${haplotype}_Soltu.DM/g" $OUT/v6_2Atl_liftoff_${haplotype}_a${coverage}s${identity}.gff
    # Add the haplotype in front of each 'PGSC' appearance
    sed -i "s/PGSC/hap${haplotype}_PGSC/g" $OUT/v6_2Atl_liftoff_${haplotype}_a${coverage}s${identity}.gff
    # Add the haplotype in front of each 'Sotub' appearance
    sed -i "s/Sotub/hap${haplotype}_Sotub/g" $OUT/v6_2Atl_liftoff_${haplotype}_a${coverage}s${identity}.gff

done

# Concatenate the files and ignore the header lines starting with #
grep -h -v '^#' $OUT/v6_2Atl_liftoff_1_a${coverage}s${identity}.gff \
    $OUT/v6_2Atl_liftoff_2_a${coverage}s${identity}.gff \
    $OUT/v6_2Atl_liftoff_3_a${coverage}s${identity}.gff \
    $OUT/v6_2Atl_liftoff_4_a${coverage}s${identity}.gff \
    $OUT/v6_2Atl_liftoff_0_a${coverage}s${identity}.gff \
    > $OUT/v6_2Atl_liftoff_a${coverage}s${identity}.gff

