#!/bin/bash
#
IMAGE_TEMP_PATH="./tmp"
IMAGE_DOCKERFILE="${IMAGE_TEMP_PATH}/Dockerfile"
RENDER_CMD="./scripts/render-dockerfile.sh"

set -e

get_docker_pushrm() {
  mkdir -p "${DOCKER_PLUGIN_PATH}"
  curl -L "${DOCKER_PUSHRM_RELEASE}" -o "${DOCKER_PUSHRM_CMD}"
  chmod +x "${DOCKER_PUSHRM_CMD}"
}

docker_pushrm() {
  docker pushrm "${BUILD_IMAGE_NAME}"
}

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

docker_login() {
  if [ -n "${CI_DOCKER_TOKEN}" ] && [ -n "${CI_DOCKER_LOGIN}" ]; then
    echo "${CI_DOCKER_TOKEN}" | docker login -u "${CI_DOCKER_LOGIN}" --password-stdin
  else
    echo "WARNING: docker login skipped."
  fi
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

push_image() {
  echo "Pushing image..."
  
  for tag in "${IMAGE_TAGS[@]}"; do
    PUSH_IMAGE="${BUILD_IMAGE_NAME}:${tag}"
    docker push "${PUSH_IMAGE}"
  done
}

# include defaults
. ./defaults

remove_temp_path
create_temp_path

get_docker_pushrm
docker_login

for image in $(find ./images -type f); do
  echo "Image found: ${image}"

  # reset to defaults
  . ./defaults

  # include image configuration
  . ${image}

  create_image "${image}"
  build_image
  push_image
done

docker_pushrm
remove_temp_path
