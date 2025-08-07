

process ENSEMBL_CORE_MAPPING_STATS {
    tag "$core_dbname"
    
    publishDir "${params.outdir}/annotation_mapping_stats", mode: 'copy'
    
    container 'ensemblorg/ensembl-genes:latest' // This packaging is stil WIP - JT 08-2025
    
    input:
    val(core_dbname)
    val(assembly_accession)
    val(xy_scanner)
    val(query_user)
    val(query_host)
    val(query_port)
    val(reference_user)
    val(reference_host)
    val(reference_port)
    val(reference_dbname)
    
    output:
    path("${assembly_accession}_mapping_stats*"), emit: stats
    path("versions.yml"), emit: versions
    
    when:
    task.ext.when == null || task.ext.when
    
    script:
    def args = task.ext.args ?: ''
    def output_prefix = "${assembly_accession}_mapping_stats"
    
    """
    calculate_remapping_stats.pl \\
        -xy_scanner ${xy_scanner} \\
        -query_user ${query_user} \\
        -query_host ${query_host} \\
        -query_port ${query_port} \\
        -query_dbname ${core_dbname} \\
        -reference_user ${reference_user} \\
        -reference_host ${reference_host} \\
        -reference_port ${reference_port} \\
        -reference_dbname ${reference_dbname} \\
        -output_dir . \\
        -output_file_prefix ${output_prefix} \\
        ${args}
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        perl: \$(perl --version | head -n2 | tail -n1 | sed 's/.*v\\([0-9.]\\+\\).*/\\1/')
        ensembl-analysis: \$(echo "Latest from container")
    END_VERSIONS
    """
    
    stub:
    def output_prefix = "${assembly_accession}_mapping_stats"
    """
    touch ${output_prefix}.txt
    touch ${output_prefix}.summary
    touch versions.yml
    """
}