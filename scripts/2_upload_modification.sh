#!/bin/bash

# Check if correct number of arguments provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <modified_segmentation>"
    echo "Example: $0 data/UserModifications/IXI022/IXI022_expert_EXP1_20250204_123456.nii.gz"
    exit 1
fi

MODIFIED_SEG=$1

# Verify file exists
if [ ! -f "$MODIFIED_SEG" ]; then
    echo "Error: File not found: $MODIFIED_SEG"
    exit 1
fi

# Extract patient ID
FILENAME=$(basename "$MODIFIED_SEG")
PATIENT_ID=$(echo "$FILENAME" | cut -d'_' -f1)

# Create expert annotations directory
EXPERT_DIR="data/ExpertAnnotations/${PATIENT_ID}"
mkdir -p "$EXPERT_DIR"

# Move file to expert annotations
DEST_PATH="${EXPERT_DIR}/$(basename "$MODIFIED_SEG")"
mv "$MODIFIED_SEG" "$DEST_PATH"

# Add to DVC and push to uploads
echo "Adding modified segmentation to DVC..."
dvc add "$DEST_PATH"
echo "Pushing to uploads remote..."
dvc push -r uploads

echo "Successfully uploaded modification!"
echo "File: $DEST_PATH"