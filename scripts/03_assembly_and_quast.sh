#!/usr/bin/env bash
# ================================================================
# Script: 03_assembly_and_quast.sh
# Purpose: Perform genome assembly with SPAdes and evaluate with QUAST
# ================================================================

set -e  # Exit immediately on error
set -u  # Treat unset variables as errors

# === Directories ===
TRIM_DIR="trimmed_reads"
ASSEMBLY_DIR="assemblies"
QUAST_DIR="qc_reports/quast"

mkdir -p "${ASSEMBLY_DIR}"
mkdir -p "${QUAST_DIR}"

# === Assemble each sample with SPAdes ===
echo "Starting SPAdes genome assembly..."

for fq1 in ${TRIM_DIR}/*_1.trimmed.fastq.gz; do
    fq2=${fq1/_1.trimmed.fastq.gz/_2.trimmed.fastq.gz}
    sample=$(basename ${fq1} _1.trimmed.fastq.gz)
    
    outdir="${ASSEMBLY_DIR}/${sample}"
    echo "Assembling sample: ${sample}"
    
    # Run SPAdes with isolate mode
    spades.py \
        -1 ${fq1} \
        -2 ${fq2} \
        -o ${outdir} \
        -t 4 \
        -m 8 \
        --isolate
    
    echo "Assembly complete for ${sample}"
done

# === Summarize assembly results ===
echo -e "\n🔹 Checking which assemblies succeeded:"
for dir in ${ASSEMBLY_DIR}/*; do
    sample=$(basename "$dir")
    if [ -s "$dir/contigs.fasta" ]; then
        echo -e "${sample}\t Success"
    else
        echo -e "${sample}\t Failed or Incomplete"
    fi
done

# ===Run QUAST for assembly quality ===
echo -e "\n🔹 Running QUAST for assembly evaluation..."
quast.py ${ASSEMBLY_DIR}/*/contigs.fasta -o ${QUAST_DIR} -t 4

echo "QUAST analysis complete!"
echo "Results saved to: ${QUAST_DIR}"
