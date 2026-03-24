## Long-read RNA-seq Mapping Strategies for Haplotype-Resolved Genomes
This repository contains the scripts to run the analyis from the paper [*The promise of long-read RNA-seq: reducing bias in analyses of allele imbalance*](https://doi.org/10.1101/2025.10.14.682301).

Prequesites:
- nextflow 
- run the scripts for reference preperation

### Recommendations

We recommend:

1. **Mapping to a personalized genome** to increase the number of allele assignments.
2. **Tracking multimapping reads and tuning mapping parameters** to ensure accurate allele and gene expression counts.
3. **Evaluating apparent extreme allele bias** to identify errors in genome assembly and annotation.

We show that these steps can be executed in a straightforward manner and recommend tools for each step.

#### Mapping Parameters
We compared competitive and parallel mapping strategies and tested two different minimap2 parameter settings. Based on this, we recommend:

1. **Use competitive mapping** (mapping to the combined reference at once) over parallel mapping, as it simplifies downstream analysis.
2. **Use `-P`** over `-N 200` for secondary alignment handling, as it resulted in higher concordance between competitive and parallel mapping strategies.
3. **For most genomes, we recommend the following command:**
```bash
minimap2 -x splice -c --secondary=yes -P [reference] [reads]
```
4. **For high-complexity or phased genomes** (e.g. polyploids or genomes with high sequence similarity between haplotypes), additionally decrease `-f` (e.g. `-f 0.000002`) to further increase concordance:
```bash
minimap2 -x splice -c --secondary=yes -P -f 0.000002 [reference] [reads]
```
5. **Always use the latest version of minimap2.** We observed an increase in concordance when upgrading from v2.24 to v2.28, suggesting that newer versions improve alignment accuracy. Using an outdated version may affect reproducibility.
