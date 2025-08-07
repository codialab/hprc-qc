#!/usr/bin/env nextflow


nextflow.enable.dsl = 2

include { ANNOTATION_QC } from './workflows/annotation_qc'

workflow HPRC_ANNOTATION_QC {
    
    if (!params.input && (!params.core_dbname || !params.assembly_accession)) {
        error "Either --input CSV file or --core_dbname + --assembly_accession must be provided"
    }
    
    if (params.input) {
        ch_input = Channel
            .fromPath(params.input, checkIfExists: true)
            .splitCsv(header:true)
            .map { row ->
                if (!row.core_dbname || !row.assembly_accession) {
                    error "CSV must contain core_dbname and assembly_accession columns"
                }
                [row.core_dbname, row.assembly_accession]
            }
    } else {
        ch_input = Channel.of([params.core_dbname, params.assembly_accession])
    }
    
    db_config = [
        xy_scanner:         params.xy_scanner,
        query_user:         params.query_user,
        query_host:         params.query_host,
        query_port:         params.query_port,
        reference_user:     params.reference_user,
        reference_host:     params.reference_host,
        reference_port:     params.reference_port,
        reference_dbname:   params.reference_dbname
    ]
    
    ANNOTATION_QC (
        ch_input,
        db_config
    )
}

workflow.onComplete {
    log.info "Pipeline completed at: ${workflow.complete}"
    log.info "Execution status: ${workflow.success ? 'OK' : 'failed'}"
    log.info "Results published to: ${params.outdir}"
}
