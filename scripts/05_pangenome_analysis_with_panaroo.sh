#!/usr/bin/env bash
# ==========================================================
# 05_pangenome_analysis_with_panaroo.sh
# Description:
#   - Runs Panaroo to infer the pangenome
#   - Produces core gene alignment for phylogenetic analysis
# ==========================================================

set -euo pipefail

#Define directories
ANNOTATION_DIR="annotation/prokka"
PANAROO_OUT="panaroo_out"
THREADS=4

mkdir -p "$PANAROO_OUT"

echo "Starting Panaroo pangenome analysis..."

# ==========================================================
# STEP 1️: Run Panaroo
# ==========================================================
echo "Running Panaroo..."

panaroo \
    -i ${ANNOTATION_DIR}/*/*.gff \
    -o "$PANAROO_OUT" \
    -t $THREADS \
    --clean-mode strict \
    --aligner mafft \
    --core_threshold 0.99

echo "Panaroo run completed!"
echo

# ==========================================================
# STEP 2️: Display summary statistics
# ==========================================================
echo "Summary statistics (top lines):"
head -n 10 "$PANAROO_OUT/summary_statistics.txt"
echo

# ==========================================================
# STEP 3️: Verify core gene alignment
# ==========================================================
if [[ -f "$PANAROO_OUT/core_gene_alignment.aln" ]]; then
    echo "Core gene alignment generated successfully!"
    echo "File: $PANAROO_OUT/core_gene_alignment.aln"
    echo "Size:"
    ls -lh "$PANAROO_OUT/core_gene_alignment.aln"
else
    echo "core_gene_alignment.aln not found. Check Panaroo logs."
    exit 1
fi

# ==========================================================
# STEP 4️: Summarize output files
# ==========================================================
echo
echo "Panaroo output contents:"
ls -lh "$PANAROO_OUT"

echo
echo "Pangenome analysis completed successfully!"
