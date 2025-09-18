# Check if a parameter is passed
if [ -z "$1" ]; then
    echo "No dataset parameter provided. Exiting."
    exit 1
fi

# Assign the passed parameter to a variable
DATASET=$1
SCRIPT_DIR=$2

echo "Updating STAPLE and metadata for $DATASET."
BASE_PATH=$(pwd)

if [ "$DATASET" == "IXI" ]; then
    DATASET_NAME='IXI'
elif [ "$DATASET" == "COW23MR" ]; then
    DATASET_NAME='COW'
else
    echo "Invalid dataset parameter. Exiting."
    exit 1
fi

echo "Dataset name: $DATASET_NAME"


# Use the dataset parameter in the python script
python ${SCRIPT_DIR}/scripts_py/compute_staple.py --dataset $DATASET_NAME --base_path $BASE_PATH
python ${SCRIPT_DIR}/scripts_py/generate_metadata.py --base_path $BASE_PATH

# Automatically add all directories in the current working directory to DVC tracking, excluding specific ones
echo "Adding directories to DVC tracking..."
for dir in */ ; do
    dir_name=$(basename "$dir")
    
    # Skip excluded directories
    if [[ "$dir_name" == "ExpertAnnotations" || "$dir_name" == "metadata" || "$dir_name" == *_TOT* ]]; then
        echo "Skipping $dir_name..."
        continue
    fi

    if [ -d "$dir" ]; then
        echo "Tracking $dir_name with DVC..."
        dvc add "$dir"
    fi
done

echo "STAPLE and metadata updated for $DATASET_NAME."
echo "COMPLETE PATH: $BASE_PATH"
echo "Exiting."
