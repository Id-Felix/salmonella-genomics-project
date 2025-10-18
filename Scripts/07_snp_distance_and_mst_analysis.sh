#!/usr/bin/env bash
# ==========================================================
# 07_snp_distance_and_mst_analysis.sh
# Description:
#   - Computes SNP distances from Panaroo core alignment
#   - Generates a SNP distance matrix
#   - Optionally visualizes the data as a Minimum Spanning Tree (MST)
# ==========================================================

set -euo pipefail

# ==========================================================
# STEP 1️: Define paths and parameters
# ==========================================================
ALIGNMENT="panaroo_out/core_gene_alignment.aln"
OUTPUT_MATRIX="snp_distance_matrix.tsv"
OUTPUT_PNG="snp_mst.png"

# ==========================================================
# STEP 2️: Check dependencies
# ==========================================================
for cmd in snp-dists python; do
    if ! command -v $cmd &>/dev/null; then
        echo "Error: '$cmd' not found. Please install it before running this script."
        exit 1
    fi
done

# ==========================================================
# STEP 3️: Generate SNP distance matrix
# ==========================================================
if [[ ! -f "$ALIGNMENT" ]]; then
    echo "Core gene alignment not found at: $ALIGNMENT"
    exit 1
fi

echo "🧬 Computing SNP distances from alignment..."
snp-dists "$ALIGNMENT" > "$OUTPUT_MATRIX"

echo "SNP distance matrix saved to: $OUTPUT_MATRIX"
echo

# Preview first few lines
echo "SNP Distance Matrix (top 10 lines):"
head -n 10 "$OUTPUT_MATRIX" | column -t
echo

# ==========================================================
# STEP 4️: Generate MST visualization in Python
# ==========================================================
cat > plot_snp_mst.py <<'EOF'
#!/usr/bin/env python3
import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt

# Load the SNP distance matrix
matrix_file = "snp_distance_matrix.tsv"
df = pd.read_csv(matrix_file, sep="\t", index_col=0)

# Create a graph
G = nx.Graph()
for i in df.index:
    for j in df.columns:
        if i != j:
            G.add_edge(i, j, weight=df.loc[i, j])

# Compute Minimum Spanning Tree
mst = nx.minimum_spanning_tree(G)

# Draw MST
plt.figure(figsize=(8, 6))
pos = nx.spring_layout(mst, seed=42)
nx.draw_networkx_nodes(mst, pos, node_size=1200, node_color="#f97316", alpha=0.9)
nx.draw_networkx_labels(mst, pos, font_size=10, font_weight="bold")
nx.draw_networkx_edges(mst, pos, width=1.5)
edge_labels = {(u, v): f"{d['weight']}" for u, v, d in mst.edges(data=True)}
nx.draw_networkx_edge_labels(mst, pos, edge_labels=edge_labels, font_size=8)
plt.title("Minimum Spanning Tree of SNP Distances", fontsize=12)
plt.axis("off")
plt.tight_layout()
plt.savefig("snp_mst.png", dpi=300)
plt.close()
EOF

# ==========================================================
# STEP 5️: Run MST visualization
# ==========================================================
echo "Building Minimum Spanning Tree visualization..."
python plot_snp_mst.py
echo "MST visualization saved as: $OUTPUT_PNG"
echo

# ==========================================================
# STEP 6️: Summary
# ==========================================================
echo "SNP distance and MST analysis complete!"
echo "Outputs generated:"
echo "  - $OUTPUT_MATRIX   → SNP pairwise distances"
echo "  - $OUTPUT_PNG      → MST visualization"
echo
echo "Interpretation:"
echo "    - Small SNP distances (<20) → very closely related isolates"
echo "    - Medium distances (20–2000) → related but with variation"
echo "    - Large distances (>10,000) → distinct lineages"
