#!/bin/sh

set -u

# Function to URL encode a string
urlencode() (
    i=1
    max_i=${#1}
    while test $i -le $max_i; do
        c="$(expr substr $1 $i 1)"
        case $c in
            [a-zA-Z0-9.~_-])
                printf "$c" ;;
            *)
                printf '%%%02X' "'$c" ;;
        esac
        i=$(( i + 1 ))
    done
)

# Default timeout value for polling
DEFAULT_POLL_TIMEOUT=10
POLL_TIMEOUT=${POLL_TIMEOUT:-$DEFAULT_POLL_TIMEOUT}

# Set up Git credentials for GitLab
git config --global --add safe.directory /gitlab/workspace
git checkout "$CI_COMMIT_REF_NAME"

# Get the branch name
branch="$(git symbolic-ref --short HEAD)"
# URL encode the branch name
branch_uri="$(urlencode ${branch})"

# Configure GitLab credentials
git config --global credential.username $GITLAB_USERNAME
git config --global core.askPass /cred-helper.sh
git config --global credential.helper cache
# Add GitLab repository as a remote
git remote add mirror $GITLAB_REPO_URL

echo "Pushing to $branch branch at $GITLAB_REPO_URL"
if [ "${FORCE_PUSH:-}" = "true" ]; then
    git push --force mirror $branch
else
    git push mirror $branch
fi

# Push changes to GitHub repository
echo "Pushing changes to GitHub repository"
git push origin $branch
