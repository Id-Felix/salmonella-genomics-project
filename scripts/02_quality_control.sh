#!/usr/bin/env bash
# ================================================================
# Script: 02_quality_control.sh
# Purpose: Perform quality control and trimming on raw reads
# Author: Holuwabiggest
# ================================================================


# === Directories ===
RAW_DIR="raw_reads"
TRIM_DIR="trimmed_reads"
QC_DIR="qc_reports"

# Create output directories if they don’t exist
mkdir -p "${TRIM_DIR}"
mkdir -p "${QC_DIR}/fastqc_raw"
mkdir -p "${QC_DIR}/fastqc_trimmed"

# === 1️⃣ Run FastQC on raw reads ===
echo "🔹 Running FastQC on raw reads..."
fastqc ${RAW_DIR}/*.fastq.gz -o ${QC_DIR}/fastqc_raw -t 4

# === 2️⃣ Run fastp for quality trimming ===
echo "🔹 Running fastp for quality trimming..."
for fq1 in ${RAW_DIR}/*_1.fastq.gz; do
    fq2=${fq1/_1.fastq.gz/_2.fastq.gz}
    sample=$(basename ${fq1} _1.fastq.gz)
    
    echo "Processing sample: ${sample}"
    
    fastp \
        -i ${fq1} \
        -I ${fq2} \
        -o ${TRIM_DIR}/${sample}_1.trimmed.fastq.gz \
        -O ${TRIM_DIR}/${sample}_2.trimmed.fastq.gz \
        --detect_adapter_for_pe \
        --thread 4 \
        --html ${QC_DIR}/${sample}_fastp.html \
        --json ${QC_DIR}/${sample}_fastp.json
done

# === 3️⃣ Run FastQC again on trimmed reads ===
echo "🔹 Running FastQC on trimmed reads..."
fastqc ${TRIM_DIR}/*.fastq.gz -o ${QC_DIR}/fastqc_trimmed -t 4

# === ️⃣ Summary ===
echo "Quality control and trimming complete!"
echo "Raw QC reports:     ${QC_DIR}/fastqc_raw/"
echo "Trimmed QC reports: ${QC_DIR}/fastqc_trimmed/"
echo "Trimmed reads:      ${TRIM_DIR}/"
