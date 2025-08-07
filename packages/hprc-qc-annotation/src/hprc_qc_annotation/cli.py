

"""
Annotation QC command line interface
"""

import click


def add_annotation_commands(annotation_group):
    """Add annotation-specific commands to the annotation group."""
    
    @annotation_group.command()
    @click.option('--query-gff3', required=True, type=click.Path(exists=True), 
                  help='Query annotation GFF3 file')
    @click.option('--reference-gff3', required=True, type=click.Path(exists=True), 
                  help='Reference annotation GFF3 file')
    @click.option('--output-dir', default='.', help='Output directory')
    @click.option('--output-prefix', required=True, help='Output file prefix')
    def mapping_stats(query_gff3, reference_gff3, output_dir, output_prefix):
        """Calculate annotation mapping statistics between GFF3 files."""
        from .mapping_stats import run_mapping_stats
        
        run_mapping_stats(
            query_gff3=query_gff3,
            reference_gff3=reference_gff3,
            output_dir=output_dir,
            output_prefix=output_prefix
        )

    @annotation_group.command()
    @click.option('--gff3', required=True, type=click.Path(exists=True), 
                  help='Annotation GFF3 file')
    @click.option('--output-dir', default='.', help='Output directory')
    @click.option('--output-prefix', required=True, help='Output file prefix')
    def homepage_stats(gff3, output_dir, output_prefix):
        """Generate homepage statistics from GFF3 annotation."""
        from .homepage_stats import run_homepage_stats
        
        run_homepage_stats(
            gff3=gff3,
            output_dir=output_dir,
            output_prefix=output_prefix
        )