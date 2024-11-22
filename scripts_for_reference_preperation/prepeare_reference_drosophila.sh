
# add prefix
sed -i 's/>FB/>w1118_FB/' w1118_12272_snp_upd_genome_gene_plusMinus100.fasta


sed -i 's/>FB/>12272_FB/' ril_12272_snp_0.5_upd_genome_gene_plusMinus100.fasta


cat w1118_12272_snp_upd_genome_gene_plusMinus100.fasta ril_12272_snp_0.5_upd_genome_gene_plusMinus100.fasta > upd_w1118_ril_12272.fasta