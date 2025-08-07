process ENSEMBL_CORE_HOMEPAGE_STATS {
    tag "$core_dbname"
    
    publishDir "${params.outdir}/core_statistics", mode: 'copy'
    
    container 'ensemblorg/ensembl-genes:latest'
    
    input:
    val(core_dbname)
    val(production_name)
    val(assembly_accession)
    val(db_user)
    val(db_host)
    val(db_port)
    val(assembly_names_file)
    val(output_dir)
    
    output:
    path("stats_${core_dbname}.sql"), emit: stats_sql
    path("${assembly_accession}_*_assembly_stats.txt"), emit: assembly_stats, optional: true
    path("versions.yml"), emit: versions
    
    when:
    task.ext.when == null || task.ext.when
    
    script:
    def args = task.ext.args ?: ''
    
    """
    generate_species_homepage_stats.pl \\
        -host ${db_host} \\
        -port ${db_port} \\
        -dbname ${core_dbname} \\
        -production_name ${production_name} \\
        -assembly_names ${assembly_names_file} \\
        -output_dir ${output_dir} \\
        ${args}
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        perl: \$(perl --version | head -n2 | tail -n1 | sed 's/.*v\\([0-9.]\\+\\).*/\\1/')
        ensembl-genes: \$(echo "Latest from container")
    END_VERSIONS
    """
    
    stub:
    """
    touch stats_${core_dbname}.sql
    touch ${assembly_accession}_assembly_stats.txt
    touch versions.yml
    """
}