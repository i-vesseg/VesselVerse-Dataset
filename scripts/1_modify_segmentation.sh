#!/bin/bash

# Check if correct number of arguments provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_segmentation> <expert_id>"
    echo "Example: $0 data/STAPLE/IXI022/IXI022-Guys-0701-MRA.nii.gz EXP1"
    exit 1
fi

SOURCE_SEG=$1
EXPERT_ID=$2

# Extract filename parts
FILENAME=$(basename "$SOURCE_SEG")
PATIENT_ID=$(echo "$FILENAME" | cut -d'-' -f1)
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create user modification directory with parents if they don't exist
USER_DIR="data/UserModifications/${PATIENT_ID}"
mkdir -p "$USER_DIR"

# Create destination filename with expert ID and timestamp
DEST_FILE="${PATIENT_ID}_expert_${EXPERT_ID}_${TIMESTAMP}.nii.gz"
DEST_PATH="${USER_DIR}/${DEST_FILE}"

# First ensure we have latest data
echo "Pulling latest data from database..."
dvc pull -r storage

# Copy the file to user modifications
echo "Copying segmentation to user workspace..."
cp "$SOURCE_SEG" "$DEST_PATH"

echo "Created user copy at: $DEST_PATH"
echo ""
echo "Next steps:"
echo "1. Modify the segmentation using 3D Slicer"
echo "2. Once done, run:"
echo "   dvc add $DEST_PATH"
echo "   dvc push -r uploads"
echo ""