# get the gene ids on the X, Y and M chromosomes
GFF=/blue/mcintyre/share/potato_ASE/orang_utan_references/AG06213_PAB.hap1.refseq.liftoff.v2_only_gene.gff   
OUT=/blue/mcintyre/share/potato_ASE/nf-ASE-mapping-comparison/noChrXYM

grep -E  "chrX|chrY|"NC_002083.1"" $GFF | awk '{print $9}' | cut -d ";" -f 1 | cut -d "=" -f 2 | sort | uniq > $OUT/chrXY_genes.txt



# extract lines containing these genes from the merged file
grep -f $OUT/chrXY_genes.txt /blue/mcintyre/share/potato_ASE/nf-ASE-mapping-comparison/out_ms/scatter_plots/Orangutan_P_tsv/Orangutan_P_allreads_merged.tsv | awk '{print $1}' > $OUT/chrXY_read_ids.txt


# extract these reads from the merged file without the X, Y and M chromosomes and check where they map
grep -wFf "$OUT/chrXY_read_ids.txt" /blue/mcintyre/share/potato_ASE/nf-ASE-mapping-comparison/out_ms/scatter_plots/Orangutan_noXYM_P_tsv/Orangutan_noXYM_P_allreads_merged.tsv \
  | awk '{print $9}' \
  | LC_ALL=C sort \
  | uniq -c > $OUT/chrXY_read_mapping_cats.txt

# genes on chromosome X, Y and M: 1507

# read mapping to chromosome X, Y and M: 636996

