#!/usr/bin/env bash
# ==========================================================
# 08_species_identity_verification.sh
# Description:
#   - Confirms species identity of assembled isolates
#     by comparing to a Salmonella enterica reference genome
#   - Uses FastANI for Average Nucleotide Identity (ANI) analysis
# ==========================================================

set -euo pipefail

# ==========================================================
# STEP 1️: Define directories and parameters
# ==========================================================
REF_DIR="references"
REF_FILE="$REF_DIR/Salmonella_enterica_ref.fna"
ASSEMBLIES_DIR="assemblies"
OUT_DIR="ani_results"
SUMMARY_FILE="$OUT_DIR/ani_summary.tsv"

mkdir -p "$REF_DIR" "$OUT_DIR"


# ==========================================================
# STEP 2: Download reference genome (if not present)
# ==========================================================
if [[ ! -f "$REF_FILE" ]]; then
    echo "Downloading Salmonella enterica reference genome..."
    wget -O "$REF_FILE.gz" \
      "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/009/885/GCF_000009885.2_ASM988v2/GCF_000009885.2_ASM988v2_genomic.fna.gz" \
      || { echo "Download failed. Please check internet or URL."; exit 1; }

    gzip -d "$REF_FILE.gz"
    echo "Reference genome saved at: $REF_FILE"
else
    echo "Reference genome already exists: $REF_FILE"
fi

# ==========================================================
# STEP 3: Run FastANI on all assemblies
# ==========================================================
echo -e "Country\tIsolate\tANI\tMatches" > "$SUMMARY_FILE"

for country in "$ASSEMBLIES_DIR"/*; do
    if [[ -d "$country" ]]; then
        cname=$(basename "$country")
        for isolate_dir in "$country"/*; do
            if [[ -d "$isolate_dir" && -f "$isolate_dir/contigs.fasta" ]]; then
                iname=$(basename "$isolate_dir")
                echo "🔹 Running FastANI for $cname / $iname..."
                
                fastANI \
                    --query "$isolate_dir/contigs.fasta" \
                    --ref "$REF_FILE" \
                    --output "$OUT_DIR/${iname}_ani.txt" \
                    >/dev/null 2>&1 || true

                if [[ -s "$OUT_DIR/${iname}_ani.txt" ]]; then
                    ani_val=$(awk '{print $3}' "$OUT_DIR/${iname}_ani.txt")
                    n_match=$(awk '{print $4}' "$OUT_DIR/${iname}_ani.txt")
                    echo -e "${cname}\t${iname}\t${ani_val}\t${n_match}" >> "$SUMMARY_FILE"
                else
                    echo -e "${cname}\t${iname}\tN/A\tN/A" >> "$SUMMARY_FILE"
                fi
            fi
        done
    fi
done

# ==========================================================
# STEP 4: Display summary table
# ==========================================================
echo
echo "ANI Summary (first 10 lines):"
column -t "$SUMMARY_FILE" | head -n 10
echo

# ==========================================================
# STEP 5: Interpret results
# ==========================================================
echo "Interpretation:"
echo "   - ANI ≥ 95% → Same species as Salmonella enterica"
echo "   - ANI < 95% → Possible contamination or misidentification "
echo
echo "🧾 Full results saved to: $SUMMARY_FILE"
