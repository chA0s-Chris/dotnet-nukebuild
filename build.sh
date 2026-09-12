#!/bin/bash
#
IMAGE_TEMP_PATH="./tmp"
IMAGE_DOCKERFILE="${IMAGE_TEMP_PATH}/Dockerfile"
RENDER_CMD="./scripts/render-dockerfile.sh"

set -e

remove_temp_path() {
  rm -rf "${IMAGE_TEMP_PATH}"
}

create_temp_path() {
  mkdir -p "${IMAGE_TEMP_PATH}"
}

create_image() {
  echo "Rendering Dockerfile from: ${1}"

  "${RENDER_CMD}" "${1}" > "${IMAGE_DOCKERFILE}"
}

create_tag_parameters() {
  TAG_PARAMETERS=""

  for tag in "${IMAGE_TAGS[@]}"; do
    TAG_PARAMETERS="${TAG_PARAMETERS} -t ${BUILD_IMAGE_NAME}:${tag}"
  done
}

build_image() {
  create_tag_parameters
  
  echo "Building image..."
  
  docker build ${TAG_PARAMETERS} -f ${IMAGE_DOCKERFILE} .
}

# include defaults
. ./defaults

remove_temp_path
create_temp_path

for image in $(find ./images -type f); do
  echo "Image found: ${image}"

  # reset to defaults
  . ./defaults

  # include image configuration
  . ${image}

  create_image "${image}"
  build_image
done

remove_temp_path
