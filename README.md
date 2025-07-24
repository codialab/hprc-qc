# HPRC-QC: Human Pangenome Release Quality Control

## Motivation
The shift towards centering genomics around graph-based reference genomes is a large ask of downstream users. Rather than ask for blind trust where each release is comprised of a graph (or set of graphs), annotations (CAT, Ensembl, combined sets), and hundreds of assemblies, the quality control and assessment of the comprising factors needs to be clearly displayed. Transparency in reference creation is essential for community adoption.

## Repository Design 
Due to the nature and diversity of the core components of a HPRC release, the optimal organisation of a codebase for release quality control is not immediately apparent. The structure of the repository was devised prior to the establishment of a comprehensive set of QC requirements and as a result it has been initialised with a few key principles in mind:
- **Transparency** - The driving goal was that there would be a clear, auditable logic to how QC is carried out.
- **Reproducibility** - Each QC result should be ultimately reproducible independent of compute environment.
- **Extensibility** - Easy to add new QC modules and adapt to emerging needs. 

Since the repository was initialised by the Genebuild team at Ensembl, slight biases toward Annotation QC needs and our preferred tools may be noticed. 

These principles guided the development of a two-component architecture. The first component is a modular CLI executable Python application for bespoke quality assessment and reporting needs. Previous QC, at least from an Ensembl annotation perspective, was conducted using custom Perl scripts that relied on the core API. This component aims to formalise and modernise this codebase. 

The second is an orchestration layer where stable instances of containerised QC workflows are to be housed. This component is structurally inspired by the modularity of nf-core but is not restricted to Nextflow workflows. The primary requirement is that each workflow has a clear, focused purpose. Avoid monolithic workflows in favor of modular, composable components. Containerisation should be used strategically, either per module or per workflow as appropriate, with all containers being publicly accessible.

## Implementation Notes
This repository is designed to leverage the existing ecosystem of QC tools rather than reimplementing functionality. If an established QC tool exists in a public repository and produces suitable outputs, it can be integrated directly into workflows without requiring any additions to the Python component. However, many existing tools produce outputs in diverse formats that are not immediately suitable for standardised reporting or integration with tools like MultiQC. In these cases, we recommend creating lightweight Python modules that the the raw tool output and convert it to standardised formats for downstream analysis and reporting. These modules focus specifically on output harmonisation rather than reimplementing the core QC logic.

The Python component is therefore reserved for two primary use cases: filling gaps where no suitable existing tools exist and providing standardised interfaces to existing tools whose native outputs require formatting for integration into comprehensive QC reports.

