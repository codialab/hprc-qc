#!/usr/bin/env python3
"""
HPRC-QC: Command line interface for HPRC pangenome quality control
"""

import click


@click.group()
@click.version_option()
def cli():
    """HPRC Pangenome Quality Control toolkit."""
    pass


@cli.group()
def assembly():
    """Assembly quality control commands."""
    click.echo("Assembly QC - implementation would go here")
    from .assembly.cli import add_assembly_commands
    add_assembly_commands(assembly)

@cli.group()
def alignment():
    """Alignment quality control commands."""
    click.echo("Alignment QC - implementation would go here")
    from .alignment.cli import add_alignment_commands
    add_alignment_commands(annotation)

@cli.group()
def annotation():
    """Annotation quality control commands."""
    # Import and add annotation-specific commands
    from .annotation.cli import add_annotation_commands
    add_annotation_commands(annotation)


@cli.group()
def reporting():
    """Report generation commands."""
    click.echo("Reporting QC - implementation would go here")


if __name__ == '__main__':
    cli()