#!/bin/bash
#
IMAGE_TEMP_PATH="./tmp"
IMAGE_DOCKERFILE="${IMAGE_TEMP_PATH}/Dockerfile"
FEATURES_PATH="./features"

get_docker_pushrm() {
  mkdir -p ${DOCKER_PLUGIN_PATH}
  curl -L ${DOCKER_PUSHRM_RELEASE} -o ${DOCKER_PUSHRM_CMD}
  chmod +x ${DOCKER_PUSHRM_CMD}
}

remove_temp_path() {
  rm -rf "${IMAGE_TEMP_PATH}"
}

create_temp_path() {
  mkdir -p "${IMAGE_TEMP_PATH}"
}

add_feature() {
  if [ "${2}" = true ]; then
    echo "Adding feature: ${1}"

    cat "${FEATURES_PATH}/${1}" >> "${IMAGE_DOCKERFILE}"
  fi
}

create_image() {
  echo "Using base image file: ${BASE_IMAGE_FILE}"

  # copy base
  cp "${BASE_IMAGE_FILE}" "${IMAGE_DOCKERFILE}"

  add_feature "set_environment" "${FEATURE_SET_ENVIRONMENT}"
  add_feature "update_distro" "${FEATURE_UPDATE_DISTRO}"
  add_feature "install_docker" "${FEATURE_INSTALL_DOCKER}"
  add_feature "install_git-lfs" "${FEATURE_INSTALL_GIT_LFS}"
  add_feature "install_azure_devops_provider" "${FEATURE_INSTALL_AZURE_DEVOPS_PROVIDER}"
  add_feature "install_docker_pushrm" "${FEATURE_INSTALL_DOCKER_PUSHRM}"
  add_feature "install_kubectl" "${FEATURE_INSTALL_KUBECTL}"
  add_feature "install_nuke" "${FEATURE_INSTALL_NUKE}"
}

create_tag_parameters() {
  TAG_PARAMETERS=""

  for tag in ${IMAGE_TAGS[@]}; do
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

#get_docker_pushrm

for image in $(find ./images -type f); do
  echo "Image found: ${image}"

  # include image configuration
  . ${image}

  create_image
  build_image
done

#remove_temp_path

