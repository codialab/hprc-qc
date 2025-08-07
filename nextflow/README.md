# Annotation QC Pipeline

## Overview
Quality control pipeline for HPRC pangenome annotations, focusing on Ensembl core database validation. This will move away from using core dbs and using flat files with the move to the python package. As a result Ensembl elements have limited portability currently. 

## What it does
- **Mapping Statistics**: Validates gene projection success rates between reference and query genomes
- **Homepage Statistics**: Generates comprehensive gene model statistics (coding, non-coding, pseudogenes) for each standalone haplotype annotation
- **Database Validation**: Connects to Ensembl production databases to extract annotation metrics
## Usage
```bash
nextflow run main.nf --input core-dbs.csv
```

## Future Development Note
Other annotaiton QC workflows may be added as additional subworkflows when we all use the same input file types but for now a workflow that would take GFF3 files would likely be set up independently within `nextflow/`.