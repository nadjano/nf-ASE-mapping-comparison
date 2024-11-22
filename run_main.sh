#!/bin/bash

# Run the main script
module load nextflow
nextflow run main.nf  -bg  -with-report report.html -resume