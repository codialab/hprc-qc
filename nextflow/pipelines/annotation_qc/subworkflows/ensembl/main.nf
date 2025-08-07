//
// Run Ensembl core database mapping statistics
//

include { ENSEMBL_CORE_MAPPING_STATS } from '../../../modules/annotation_mapping_stats'
include { ENSEMBL_CORE_HOMEPAGE_STATS } from '../../../modules/ensembl_core_homepage_stats'

workflow ENSEMBL_STATS{
    
    take:
    ch_databases    // channel: [ core_dbname, assembly_accession ]
    db_config       // map: [xy_scanner, query_user, query_host, query_port, reference_user, reference_host, reference_port, reference_dbname]
    
    main:
    
    ch_versions = Channel.empty()
    
    // Run mapping statistics for each database
    ENSEMBL_CORE_MAPPING_STATS (
        ch_databases.map { it[0] },              // core_dbname
        ch_databases.map { it[1] },              // assembly_accession
        db_config.xy_scanner,
        db_config.query_user,
        db_config.query_host,
        db_config.query_port,
        db_config.reference_user,
        db_config.reference_host,
        db_config.reference_port,
        db_config.reference_dbname
    )

    ENSEMBL_CORE_HOMEPAGE_STATS (
        ch_databases.map { it[0] },              // core_dbname
        ch_databases.map { it[2] },              // production_name  
        ch_databases.map { it[1] },              // assembly_accession
        db_config.query_user,                    // db_user
        db_config.query_host,                    // db_host
        db_config.query_port,                    // db_port
        params.assembly_names_file ?: "default_assembly_names.txt",  // assembly_names_file
        params.outdir                            // output_dir
    )
    
    ch_versions = ch_versions.mix(ENSEMBL_CORE_MAPPING_STATS.out.versions, 
                                  ENSEMBL_CORE_HOMEPAGE_STATS.out.versions)
    
    emit:
    stats    = ENSEMBL_CORE_MAPPING_STATS.out.stats
    versions = ch_versions
}