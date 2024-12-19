#!/bin/bash
#SBATCH --mail-user=nadja.nolte@ufl.edu
#SBATCH --mail-type=FAIL
#SBATCH --job-name=map
#SBATCH --output=/blue/mcintyre/share/potato_ASE/map.out
#SBATCH --error=/blue/mcintyre/share/potato_ASE/map.err
#SBATCH --cpus-per-task=16
#SBATCH --time=2:00:00
#SBATCH --ntasks=1
#SBATCH --mem=50gb

module load minimap2


        minimap2 \
                    -t 16 \
                    -a \
                    -K 25g \
                    -x splice \
                    -uf \
                    --for-only \
                    --secondary=yes \
                    -P \
                    /blue/mcintyre/share/potato_ASE/nf-ASE-mapping-comparison/hap_genomes/upd_w1118_ril_12272.fasta \
                    /blue/mcintyre/share/potato_ASE/nf-ASE-mapping-comparison/fastq_reads/dm12272_01h_rep1.fastq \
                    > /blue/mcintyre/share/potato_ASE/nf-ASE-mapping-comparison/drosophila_sam/align_comp_dm12272_01h_rep1.sam


