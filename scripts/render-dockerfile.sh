#!/bin/bash
#
# Render the Dockerfile for one image configuration to stdout.
#
# Needs no Docker daemon, registry credentials, or network access. Run from the
# repository root, like build.sh, so the paths in defaults and the image
# configuration resolve.

IMAGES_PATH="./images"
FEATURES_PATH="./features"

set -e

# feature file and its flag, in the order features are appended
FEATURE_ORDER=(
  "set_environment:FEATURE_SET_ENVIRONMENT"
  "update_distro:FEATURE_UPDATE_DISTRO"
  "install_docker:FEATURE_INSTALL_DOCKER"
  "install_git-lfs:FEATURE_INSTALL_GIT_LFS"
  "install_azure_devops_provider:FEATURE_INSTALL_AZURE_DEVOPS_PROVIDER"
  "install_docker_pushrm:FEATURE_INSTALL_DOCKER_PUSHRM"
  "install_kubectl:FEATURE_INSTALL_KUBECTL"
  "install_nuke:FEATURE_INSTALL_NUKE"
  "install_nuke9:FEATURE_INSTALL_NUKE9"
  "install_node:FEATURE_INSTALL_NODE"
)

fail() {
  echo "${0##*/}: ${1}" >&2
  exit 1
}

IMAGE_CONFIG="${1}"

if [ -z "${IMAGE_CONFIG}" ]; then
  fail "usage: ${0##*/} <image configuration>, e.g. ${IMAGES_PATH}/sdk-10.0"
fi

if [ ! -f "${IMAGE_CONFIG}" ]; then
  fail "image configuration not found: ${IMAGE_CONFIG}"
fi

# include defaults, then the image configuration
. ./defaults
. "${IMAGE_CONFIG}"

if [ -z "${BASE_IMAGE_FILE}" ]; then
  fail "${IMAGE_CONFIG}: BASE_IMAGE_FILE is not set"
fi

if [ ! -f "${BASE_IMAGE_FILE}" ]; then
  fail "${IMAGE_CONFIG}: base image file not found: ${BASE_IMAGE_FILE}"
fi

if [ "${#IMAGE_TAGS[@]}" -eq 0 ]; then
  fail "${IMAGE_CONFIG}: IMAGE_TAGS is not set"
fi

if [ "${FEATURE_INSTALL_NUKE}" = true ] && [ "${FEATURE_INSTALL_NUKE9}" = true ]; then
  fail "${IMAGE_CONFIG}: install_nuke and install_nuke9 both set NUKE_TOOL_VERSION; enable only one"
fi

# copy base
cat "${BASE_IMAGE_FILE}"

for entry in "${FEATURE_ORDER[@]}"; do
  feature="${entry%%:*}"
  flag="${entry##*:}"

  if [ "${!flag}" = true ]; then
    cat "${FEATURES_PATH}/${feature}"
  fi
done
