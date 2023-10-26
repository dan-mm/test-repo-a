#!/bin/bash
set -euo pipefail

# loop through the passed arguements and put them in an array called "changed_folders"
changed_folders=()
for arg in "$@"; do
  changed_folders+=("$arg")
done

echo "Changed folders: ${changed_folders[@]}"

## loop through all the changed folders
for folder in "${changed_folders[@]}"; do
    # get latest tag version from dockerhub for "greencoding/${folder}"
    response=$(curl -s "https://hub.docker.com/v2/repositories/greencoding/${folder}/tags/?page_size=1")
    latest_version=$(echo "${response}" | jq -r '.results[0].name')
    #latest_version=$(curl -s "https://hub.docker.com/v2/repositories/greencoding/${folder}/tags/?page_size=1" | jq -r '.results[0].name')
    # if latest_version is null, set it to 1
    if [ "${latest_version}" == "null" ]; then
        latest_version=1
    else
        # increment latest_version
        latest_version=$((latest_version+1))
    fi
    echo "Latest version for ${folder} is ${latest_version}"
    echo "Building ${folder}..."
    # docker buildx build \
    #     --push \
    #     --tag "greencoding/${folder}:v1.${version}" \
    #     --platform linux/amd64,linux/arm64 \
    #     ./docker/auxiliary-containers/"${folder}"
done