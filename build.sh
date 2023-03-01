#!/bin/bash
#

BUILD_IMAGE_NAME="chaos/dotnet-nukebuild"
DOCKER_PLUGIN_PATH="${HOME}/.docker/cli-plugins"
DOCKER_PUSHRM_CMD="${DOCKER_PLUGIN_PATH}/docker-pushrm"
DOCKER_PUSHRM_RELEASE="https://github.com/christian-korneck/docker-pushrm/releases/download/v1.9.0/docker-pushrm_linux_amd64"

mkdir -p ${DOCKER_PLUGIN_PATH}
curl -L ${DOCKER_PUSHRM_RELEASE} -o ${DOCKER_PUSHRM_CMD}
chmod +x ${DOCKER_PUSHRM_CMD}

. ./versions

docker build -t ${BUILD_IMAGE_NAME}:${IMAGE_RELEASE_VERSION} ./release
docker tag ${BUILD_IMAGE_NAME}:${IMAGE_RELEASE_VERSION} ${BUILD_IMAGE_NAME}:latest
docker tag ${BUILD_IMAGE_NAME}:${IMAGE_RELEASE_VERSION} ${BUILD_IMAGE_NAME}:${IMAGE_RELEASE_MAJOR}

docker build -t ${BUILD_IMAGE_NAME}:${IMAGE_PRERELEASE_VERSION} ./pre
docker tag ${BUILD_IMAGE_NAME}:${IMAGE_PRERELEASE_VERSION} ${BUILD_IMAGE_NAME}:preview

echo ${CI_DOCKER_TOKEN} | docker login -u ${CI_DOCKER_LOGIN} --password-stdin

docker push ${BUILD_IMAGE_NAME}:${IMAGE_RELEASE_VERSION}
docker push ${BUILD_IMAGE_NAME}:latest
docker push ${BUILD_IMAGE_NAME}:${IMAGE_RELEASE_MAJOR}
docker push ${BUILD_IMAGE_NAME}:${IMAGE_PRERELEASE_VERSION}
docker push ${BUILD_IMAGE_NAME}:preview

docker pushrm ${BUILD_IMAGE_NAME}
