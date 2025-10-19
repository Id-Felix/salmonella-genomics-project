#!/bin/bash
# 01_data_retrieval.sh
# Download Salmonella isolates from Nigeria, Ghana, and Guinea

set -euo pipefail

# Create directories
mkdir -p raw_reads reads

# Input file with accession IDs
SAMPLES_FILE="samples.txt"

# Loop through samples
while read -r country isolate; do
  [[ "$country" == "Country" ]] && continue  # skip header
  echo "Downloading $isolate from $country..."
  mkdir -p reads/"$country"
  fasterq-dump "$isolate" -O reads/"$country" --split-files --progress
  gzip reads/"$country"/*.fastq
  echo "Finished $isolate ($country)"
done < "$SAMPLES_FILE"
