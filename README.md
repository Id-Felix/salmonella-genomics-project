**Genomic Characterization and Antimicrobial Resistance Profiling of Salmonella enterica Isolates from a Foodborne Outbreak in West Africa**

**1. Project Overview**

In mid-2023, public health authorities in Lagos, Nigeria, launched an investigation into a series of severe food poisoning cases traced to contaminated street-vended chicken salad and boiled eggs. Hospitals across Lagos and Ogun States reported a surge in gastroenteritis cases — some progressing to sepsis, particularly among children and immunocompromised adults.

Preliminary lab analyses identified Salmonella enterica as the causative agent. Alarmingly, several isolates showed poor response to ciprofloxacin and ceftriaxone, two antibiotics commonly used against Salmonella infections.

To address this public health concern, the Nigeria Centre for Disease Control (NCDC) collaborated with academic researchers to perform whole-genome sequencing of bacterial isolates from affected regions.
This project aims to analyze genomic data to reveal the molecular mechanisms of antimicrobial resistance (AMR), trace transmission patterns, and inform future outbreak responses.


**2. Objectives**

a. Confirm the identity of outbreak isolates using genomic data.

b. Detect antimicrobial resistance (AMR) genes and plasmids responsible for multidrug resistance.

c. Compare genomes from multiple West African regions (Nigeria, Ghana, Côte d’Ivoire) to trace possible transmission or contamination sources.

d. Construct a phylogenetic tree to explore genetic relatedness and potential outbreak origins.

e. Provide recommendations for antibiotic stewardship and public health intervention.


**3. Workflow Summary**

| **Step**                     | **Tool/Software**                       | **Description**                                                                                    |
| ---------------------------- | --------------------------------------- | -------------------------------------------------------------------------------------------------- |
| **1. Data Retrieval**        | `wget`, `SRA Toolkit`                   | Download raw sequence reads (FASTQ files) for *Salmonella enterica* isolates from NCBI SRA or ENA. |
| **2. Quality Control**       | `FastQC`, `fastp`                       | Assess sequence quality, trim adapters, and remove low-quality bases.                              |
| **3. Genome Assembly**       | `SPAdes`                                | Assemble high-quality reads into contigs.                                                          |
| **4. Genome Annotation**     | `Prokka`                                | Annotate genes, tRNAs, rRNAs, and hypothetical proteins.                                           |
| **5. AMR Gene Detection**    | `ABRicate` (CARD, ResFinder databases)  | Identify resistance genes and plasmid-borne determinants.                                          |
| **6. Comparative Genomics**  |           `Panaroo`                     | Perform pangenome analysis to identify core and accessory genes.                                   |
| **7. Phylogenetic Analysis** | `IQ-TREE`                     | Build phylogenetic trees from core gene alignments to visualize isolate relationships.             |
| **8. Reporting**             | `Python`  | Summarize AMR profiles, visualize heatmaps, and interpret results.                                 |


**4. Results**

**4.1 Organism Identification**

