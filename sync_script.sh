!/bin/bash

GITLAB_REPO="git@gitlab.com:pfe20243/mirroring.git"
GITHUB_REPO="git@github.com:bvssel/mirroringRepo.git"

TEMP_DIR=$(mktemp -d)

git clone $GITLAB_REPO $TEMP_DIR

cd $TEMP_DIR

git pull origin master

git push $GITHUB_REPO master

rm -rf $TEMP_DIR

echo "Mirror complete."
