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

| Step                               | Tool(s)                        | Description                                                                                |
| ---------------------------------- | ------------------------------ | ------------------------------------------------------------------------------------------ |
| **1. Data Retrieval**              | `fasterq-dump`, `wget`         | Downloaded sequencing reads from ENA/SRA for Ghana, Guinea, and Nigeria isolates.          |
| **2. Quality Control**             | `FastQC`, `fastp`              | Performed quality assessment and adapter trimming on raw reads.                            |
| **3. Assembly**                    | `SPAdes`, `QUAST`              | De novo genome assembly and quality evaluation (contigs, N50, genome size).                |
| **4. Annotation**                  | `Prokka`                       | Annotated assembled contigs to identify coding regions, rRNAs, and tRNAs.                  |
| **5. AMR & Virulence Profiling**   | `ABRicate (ResFinder, VFDB)`   | Screened annotated genomes for known AMR and virulence genes.                              |
| **6. Pan-Genome Analysis**         | `Panaroo`                      | Clustered orthologous genes across isolates to define core and accessory genomes.          |
| **7. Phylogenetic Reconstruction** | `IQ-TREE`, `snp-dists`         | Built core genome phylogeny and SNP-based distance matrix for evolutionary interpretation. |
| **8. Visualization**               | `Python (matplotlib, seaborn)` | Generated AMR and virulence heatmaps, and iTOL-ready tree annotations.                     |



**4. Results**

**4.1 Organism Identification**

FastANI analysis of the assembled genomes provided definitve species identification. The top FastANI hit for the representative isolate showed 99.8% identity to the reference Salmonella genome, confirming the causative agent of the outbreak.


|**Subject Accession** | **Percent Identity (%)** |
| --------------------- | ------------------------ |
| Ghana_SRR7641995      | 98.5                     |
| Ghana_SRR7641996      | 98.5                     |
| Guinea_SRR13532031    | 99.8                     |
| Guinea_SRR13532116    | 99.8                     |
| Nigeria_ERR10359917   | 98.3                     |
| Nigeria_ERR10359918   | 98.3                    |



**4.2 Identification of AMR genes**

ABRicate analysis against the CARD database revealed specific AMR profile.

| **AMR Gene**      | **Function**                                                                                                                                                                                                                           | **Resistance** | **Antibiotic Class**              |
| ----------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------- | --------------------------------- |
| **aac(6’)-Iaa_1** | Confers resistance to certain aminoglycosides (like kanamycin and tobramycin). In *Salmonella*, **aac(6’)-Iaa** has also been associated with low-level fluoroquinolone resistance, especially when found together with **qnr** genes. | Ciprofloxacin  | Aminoglycosides, Fluoroquinolones |
| **qnrB19_1**      | Protects **DNA gyrase** and **topoisomerase IV** from fluoroquinolone inhibition, reducing the binding affinity of fluoroquinolones.                                                                                                   | Ciprofloxacin  | Fluoroquinolones                  |


**4.3 Identification of Virulence Factors**

Analysis with the VFDB database identified a full complement of critical virulence factors, explaining the strain's hypervirulence.

**Identified Toxin and Virulence-Associated Genes in Salmonella enterica Isolates**


| **S/N** | **Gene**                    | **Function / Role in Pathogenicity**                                                                                    |
| :-----: | :-------------------------- | :---------------------------------------------------------------------------------------------------------------------- |
|    1    | **avrA**                    | SPI-1 effector; inhibits host inflammatory response by deactivating MAPK signaling.                                     |
|    2    | **cdtB**                    | Cytolethal distending toxin; causes host DNA damage and cell cycle arrest.                                              |
|   3–9   | **csgA–csgG**               | Curli fiber biosynthesis genes; mediate adhesion and biofilm formation on surfaces.                                     |
|  10–11  | **entA, entB**              | Enterobactin biosynthesis; involved in iron acquisition during infection.                                               |
|  12–14  | **faeC–faeE**               | Fimbrial assembly proteins; promote bacterial attachment to intestinal epithelial cells.                                |
|  15–16  | **fepC, fepG**              | Iron transport system components; support bacterial survival under low iron conditions.                                 |
|  17–21  | **fimC–fimI**               | Type 1 fimbriae genes; mediate adhesion to host cell receptors and colonization.                                        |
|    22   | **gogB**                    | SPI-1 effector; inhibits NF-κB activation, suppressing inflammation.                                                    |
|    23   | **grvA**                    | Global regulator of virulence; modulates gene expression during host invasion.                                          |
|  24–32  | **invA–invJ**               | SPI-1 invasion genes; encode type III secretion system (T3SS) components and effectors that facilitate host cell entry. |
|  33–37  | **lpfA–lpfE**               | Long polar fimbriae genes; promote adhesion to Peyer’s patches and intestinal mucosa.                                   |
|  38–39  | **mgtB, mgtC**              | Magnesium transporters; essential for intracellular survival within macrophages.                                        |
|    40   | **mig-14**                  | Macrophage-induced gene; contributes to intracellular survival and virulence.                                           |
|    41   | **misL**                    | Autotransporter protein; mediates adhesion to host extracellular matrix proteins.                                       |
|    42   | **ompA**                    | Outer membrane protein A; supports biofilm formation and immune evasion.                                                |
|  43–45  | **orgA–orgC**               | SPI-1 T3SS structural components; required for effector secretion and invasion.                                         |
|  46–49  | **pefA–pefD**               | Plasmid-encoded fimbriae; aid in adhesion and intestinal colonization.                                                  |
|  50–51  | **pipB, pipB2**             | SPI-2 effectors; manipulate host endocytic trafficking for intracellular replication.                                   |
|  52–54  | **prgH–prgK**               | SPI-1 secretion system apparatus proteins; form structural base of the injectisome.                                     |
|    55   | **ratB**                    | Outer membrane protein involved in intestinal persistence.                                                              |
|    56   | **rck**                     | Outer membrane invasin; contributes to serum resistance and cell invasion.                                              |
|    57   | **shdA**                    | Adhesin that binds fibronectin; important for persistent colonization.                                                  |
|  58–59  | **sicA, sicP**              | SPI-1 chaperones; stabilize and deliver T3SS effectors to the secretion system.                                         |
|  60–61  | **sifA, sifB**              | SPI-2 effectors; modify host endosomal system to form Salmonella-containing vacuoles.                                   |
|    62   | **sinH**                    | Outer membrane protein; facilitates host cell adhesion.                                                                 |
|  63–66  | **sipA–sipD**               | SPI-1 effectors; mediate cytoskeletal rearrangement during host cell invasion.                                          |
|    67   | **slrP**                    | SPI-2 effector; ubiquitin ligase that modulates host immune responses.                                                  |
|    68   | **sodCI**                   | Periplasmic superoxide dismutase; protects bacteria from oxidative stress in macrophages.                               |
|  69–81  | **sopA–sopE2**              | SPI-1 effectors; promote host cytoskeletal remodeling, inflammation, and bacterial entry.                               |
|  82–86  | **spaO–spaS**               | SPI-1 structural genes; assemble the type III secretion needle complex.                                                 |
|    87   | **spiC / ssaB**             | SPI-2 regulator; essential for secretion system stability and intracellular survival.                                   |
|    88   | **sptP**                    | SPI-1 effector; reverses host cell signaling changes after invasion.                                                    |
|  89–91  | **spvB, spvC, spvR**        | Plasmid virulence genes; promote intracellular replication and systemic infection.                                      |
|  92–110 | **ssaC–ssaV**               | SPI-2 secretion apparatus components; enable effector translocation across host membranes.                              |
| 111–115 | **sseA–sseK2**              | SPI-2 effectors; interfere with host immune signaling and vesicle trafficking.                                          |
| 116–119 | **sspH1, sspH2, steA–steC** | SPI-2 and SPI-1 effectors; manipulate host cytoskeletal and immune functions to favor infection.                        |
| 120–123 | **sscA, sscB, sseL**        | SPI-2 chaperones and effectors; regulate secretion and modulate host immune response.                                   |




**4.4 Comparative Genomic Analysis Across Regions**


The Minimum Spanning Tree (MST) based on pairwise SNP distances revealed a cluster of two Guinea isolates (0 SNPs apart), suggesting clonal expansion within Guinea. Isolates from Ghana and Nigeria were separated by >50,000 SNPs, indicating distinct lineages with no evidence of recent cross-border transmission. The MST therefore supports localized outbreaks in each country rather than a single transnational transmission chain.

The IQ-Tree phylogeny suggested a closer evolutionary relationship between Guinean and Nigerian isolates, while Ghanaian isolates diverged earlier, indicating distinct ancestral separation.


