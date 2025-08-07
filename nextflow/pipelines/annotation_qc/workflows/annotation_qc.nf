#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { ENSEMBL_STATS } from '../subworkflows/ensembl/main'

workflow ANNOTATION_QC {
    
    take:
    ch_databases    // channel: [ core_dbname, assembly_accession ]
    db_config       // map: database connection configuration
    
    main:
    
    ch_versions = Channel.empty()
    ch_reports  = Channel.empty()
    
    if (params.run_mapping_stats) {
        ENSEMBL_STATS (
            ch_databases,
            db_config
        )
        ch_versions = ch_versions.mix(ENSEMBL_STATS.out.versions)
        ch_reports  = ch_reports.mix(ENSEMBL_STATS.out.stats.map { it -> ['mapping_stats', it] })
    }
    
    // Future QC modules can be added here:
    // - indel statistics 
    
    emit:
    reports  = ch_reports
    versions = ch_versions
}