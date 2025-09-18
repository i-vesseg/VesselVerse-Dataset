# VesselverseDatasets

## Overview
The **VesselverseDatasets** repository is designed to manage multiple medical imaging datasets for vessel segmentation. Each dataset is maintained as a Git submodule, allowing independent updates and version control while keeping all datasets accessible within a single repository.

## Repository Structure
```
VesselverseDatasets/
├── datasets/                 # Directory containing dataset submodules
│   ├── COW23MR/              # Example dataset (submodule)
│   ├── IXI/                  # Another dataset (submodule)
│   ├── .../                  # Additional dataset (submodule)
├── scripts/                  # Utility scripts for dataset management
├── .gitmodules               # Git submodule configurations
├── .gitignore                # Ignore rules for repository
├── .dvcignore                # Ignore rules for DVC
├── requirements.txt          # Dependencies for dataset processing
├── toy_config.sh             # Example configuration file
└── README.md                 # Documentation
```

## Cloning the Repository with Submodules
To clone this repository along with its dataset submodules, use the following command:
```bash
git clone --recurse-submodules https://github.com/your-org/VesselverseDatasets.git
cd VesselverseDatasets
```

If you have already cloned the repository but forgot to include submodules, initialize and update them with:
```bash
git submodule update --init --recursive
```

## Adding a New Dataset as a Submodule
To add a new dataset as a submodule, follow these steps:
```bash
cd VesselverseDatasets
# Add the dataset repository as a submodule
git submodule add https://github.com/your-org/vesselverse_dataset_NEW datasets/NEW
# Commit and push the changes
git add .gitmodules datasets/NEW
git commit -m "Added NEW dataset as a submodule"
git push origin main
```

## Updating Submodules
To pull the latest updates for all datasets, run:
```bash
git submodule update --remote --merge
```

For a specific dataset submodule:
```bash
cd datasets/COW23MR  # Navigate to the dataset folder
git pull origin main  # Pull the latest changes
cd ../..  # Return to the root directory
```

## Removing a Dataset Submodule
If a dataset needs to be removed, use the following commands:
```bash
git submodule deinit -f datasets/OLD_DATASET
git rm -f datasets/OLD_DATASET
rm -rf .git/modules/datasets/OLD_DATASET
git commit -m "Removed OLD_DATASET submodule"
git push origin main
```

## Contributing
If you would like to contribute a new dataset, please:
1. Fork the dataset repository.
2. Ensure the dataset follows the structure of other submodules.
3. Submit a pull request with a clear description of the dataset.

## License
This repository follows the licensing terms specified by each dataset. Please refer to the individual dataset repositories for specific licensing information.

---

For any issues or inquiries, feel free to contact the maintainers. 🚀

