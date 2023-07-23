#!/bin/bash

set -e

# Get the list of subdirectories within "auxiliary-containers" directory containing a Dockerfile
a

# Loop through each subdirectory, build and push the Docker image
for subdir in "${subdirs[@]}"; do
  subdir=$(basename "${subdir}")
  docker buildx build \
    --push \
    --tag "ghcr.io/${GITHUB_REPOSITORY}/${subdir}:latest" \
    --platform linux/amd64,linux/arm64 \
    "${subdir}"
done
