#!/usr/bin/env bash
# ==========================================================
# 04_annotation_and_abricate.sh
# Description:
#   - Annotates assembled genomes using Prokka
#   - Screens genomes for AMR (ResFinder) and Virulence (VFDB) genes using ABRicate
#   - Summarizes the ABRicate results into CSV reports
# ==========================================================

set -euo pipefail

#Define directories
ASSEMBLY_DIR="assemblies"
ANNOTATION_DIR="annotation/prokka"
ABRICATE_DIR="abricate_reports"
SAMPLES_FILE="samples.txt"

mkdir -p "$ANNOTATION_DIR" "$ABRICATE_DIR"

echo "Starting annotation and AMR/Virulence gene detection..."

# ==========================================================
# STEP 1: Annotate genomes with Prokka
# ==========================================================
echo "Running Prokka annotations..."

while read -r SAMPLE; do
    ASSEMBLY="$ASSEMBLY_DIR/${SAMPLE}.fasta"
    OUT_DIR="$ANNOTATION_DIR/${SAMPLE}"
    
    if [[ ! -f "$ASSEMBLY" ]]; then
        echo "Skipping $SAMPLE — assembly not found!"
        continue
    fi

    echo "Annotating $SAMPLE..."
    prokka --outdir "$OUT_DIR" \
           --prefix "$SAMPLE" \
           --cpus 4 \
           --force \
           "$ASSEMBLY"
done < "$SAMPLES_FILE"

echo "Prokka annotations complete!"
echo

# ==========================================================
# STEP 2️: Run ABRicate for AMR and Virulence genes
# ==========================================================
echo "Running ABRicate scans..."

for DB in resfinder vfdb; do
    echo "Database: $DB"
    mkdir -p "$ABRICATE_DIR/$DB"

    while read -r SAMPLE; do
        GFF_FILE="$ANNOTATION_DIR/${SAMPLE}/${SAMPLE}.gff"
        OUT_FILE="$ABRICATE_DIR/$DB/${SAMPLE}_${DB}.txt"

        if [[ ! -f "$GFF_FILE" ]]; then
            echo "Skipping $SAMPLE — GFF not found!"
            continue
        fi

        echo "Scanning $SAMPLE with $DB..."
        abricate --db "$DB" "$GFF_FILE" > "$OUT_FILE"
    done < "$SAMPLES_FILE"
done

echo "ABRicate scans complete!"
echo

# ==========================================================
# STEP 3️: Summarize ABRicate results
# ==========================================================
echo "Summarizing ABRicate results..."

cd "$ABRICATE_DIR"

for DB in resfinder vfdb; do
    echo "Summarizing $DB..."
    abricate --summary "$DB"/*.txt > "${DB}_summary.csv"
done

cd ../..

echo "ABRicate summaries generated!"
echo "Outputs saved in: $ABRICATE_DIR/resfinder_summary.csv and $ABRICATE_DIR/vfdb_summary.csv"
echo
echo "Annotation and gene detection pipeline completed successfully!"
