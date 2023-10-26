#!/bin/bash
set -euo pipefail

# get list of changed folders
changed_folders=()
for arg in "$@"; do
  changed_folders+=("$arg")
done

echo "Changed folders: ${changed_folders[@]}"

## loop through all the changed folders
for folder in "${changed_folders[@]}"; do
    response=$(curl -s "https://hub.docker.com/v2/repositories/greencoding/${folder}/tags/?page_size=2")
    # echo "${response}" | jq .
    latest_version=$(echo "${response}" | jq -r '.results[0].name')
    echo "Last version for ${folder} is ${latest_version}"
    if [ "$latest_version" = "null" ]; then
        new_version=1
    elif [[ "$latest_version" =~ ^[0-9]+$ ]]; then
        new_version=$((latest_version+1))
    else
        new_version="latest"
    fi

    echo "Building new version: greencoding/${folder}:v${new_version}"
    docker buildx build \
        --push \
        --tag "greencoding/${folder}:v${new_version}" \
        --platform linux/amd64,linux/arm64 \
        ./docker/auxiliary-containers/"${folder}"
    echo "Image pushed"
done