#!/bin/bash

# Define repository URLs
GITLAB_REPO="git@gitlab.com:pfe20243/mirroring.git"
GITHUB_REPO="git@github.com:bvssel/mirroringRepo.git"

# Define a temporary directory to clone the GitLab repo
TEMP_DIR=$(mktemp -d)

# Clone the GitLab repo
git clone $GITLAB_REPO $TEMP_DIR

# Navigate into the cloned repository
cd $TEMP_DIR

# Pull latest changes
git pull origin master

# Push changes to GitHub
git push $GITHUB_REPO master

# Clean up
rm -rf $TEMP_DIR

echo "Mirror complete."
