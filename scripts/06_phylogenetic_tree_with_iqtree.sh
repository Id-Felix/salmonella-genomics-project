#!/usr/bin/env bash
# ==========================================================
# 06_phylogenetic_tree_with_iqtree.sh
# Description:
#   - Constructs a phylogenetic tree using IQ-TREE
#   - Performs bootstrap analysis
#   - Produces tree files ready for iTOL visualization
# ==========================================================

set -euo pipefail

# Input and output paths
ALIGNMENT="panaroo_out/core_gene_alignment.aln"
OUTPUT_DIR="panaroo_out"
THREADS=4

# ==========================================================
# STEP 1️: Check input
# ==========================================================
if [[ ! -f "$ALIGNMENT" ]]; then
    echo "Core gene alignment not found at: $ALIGNMENT"
    echo "Please ensure Panaroo was run successfully."
    exit 1
fi

echo "Core gene alignment found!"
echo "Starting IQ-TREE phylogenetic inference..."
echo

# ==========================================================
# STEP 2️: Run IQ-TREE
# ==========================================================
cd "$OUTPUT_DIR"

iqtree -s core_gene_alignment.aln \
       -m GTR+G \
       -nt $THREADS \
       -bb 1000 \
       -alrt 1000 \
       -pre panaroo_core_tree

cd ..

# ==========================================================
# STEP 3️: Confirm successful run
# ==========================================================
if [[ -f "$OUTPUT_DIR/panaroo_core_tree.treefile" ]]; then
    echo "IQ-TREE analysis completed successfully!"
    echo "Tree file: $OUTPUT_DIR/panaroo_core_tree.treefile"
else
    echo "Tree file not found — something went wrong."
    exit 1
fi

# ==========================================================
# STEP 4️: Summarize results
# ==========================================================
echo
echo "Log summary (last 10 lines):"
tail -n 10 "$OUTPUT_DIR/panaroo_core_tree.log"
echo

echo "Tree preview (first line):"
head -n 1 "$OUTPUT_DIR/panaroo_core_tree.treefile"
echo

echo "Phylogenetic tree construction completed!"
echo "Files generated in $OUTPUT_DIR:"
echo "  - panaroo_core_tree.treefile  → Final tree (upload to iTOL)"
echo "  - panaroo_core_tree.iqtree    → Run summary"
echo "  - panaroo_core_tree.log       → Execution log"
echo "  - panaroo_core_tree.contree   → Consensus tree (if bootstrapping done)"
