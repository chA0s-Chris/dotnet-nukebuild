#!/bin/bash
#
# Verify that every image configuration renders exactly as recorded in
# expected/ and that invalid configurations are rejected.
#
# Needs no Docker daemon, registry credentials, or network access. Run from the
# repository root, like build.sh.
#
# Pass --regenerate to rewrite the expected Dockerfiles. Do that whenever a base
# image or feature file changes on purpose, and commit the result with it.

IMAGES_PATH="./images"
EXPECTED_PATH="./expected"
RENDER_CMD="./scripts/render-dockerfile.sh"

set -e

REGENERATE=false

if [ "${1}" = "--regenerate" ]; then
  REGENERATE=true
elif [ -n "${1}" ]; then
  echo "${0##*/}: usage: ${0##*/} [--regenerate]" >&2
  exit 1
fi

FAILURES=0
WORK_PATH="$(mktemp -d)"

trap 'rm -rf "${WORK_PATH}"' EXIT

report_failure() {
  echo "FAIL ${1}" >&2
  FAILURES=$((FAILURES + 1))
}

# every image configuration renders exactly as recorded
check_images() {
  for config in "${IMAGES_PATH}"/*; do
    name="${config##*/}"
    expected="${EXPECTED_PATH}/${name}.Dockerfile"

    if [ "${REGENERATE}" = true ]; then
      "${RENDER_CMD}" "${config}" > "${expected}"
      echo "regenerated ${expected}"
      continue
    fi

    if [ ! -f "${expected}" ]; then
      report_failure "${name}: no expected Dockerfile at ${expected}"
      continue
    fi

    if ! "${RENDER_CMD}" "${config}" > "${WORK_PATH}/rendered" 2> "${WORK_PATH}/stderr"; then
      report_failure "${name}: rendering failed"
      cat "${WORK_PATH}/stderr" >&2
      continue
    fi

    if diff -u "${expected}" "${WORK_PATH}/rendered"; then
      echo "ok   ${name} renders as expected"
    else
      report_failure "${name}: rendered output differs from ${expected}"
    fi
  done
}

# an invalid configuration must fail with a diagnostic instead of rendering
expect_rejected() {
  description="${1}"
  config="${2}"

  if "${RENDER_CMD}" "${config}" > "${WORK_PATH}/rendered" 2> "${WORK_PATH}/stderr"; then
    report_failure "${description}: rendered instead of being rejected"
    return
  fi

  if [ ! -s "${WORK_PATH}/stderr" ]; then
    report_failure "${description}: rejected without a diagnostic"
    return
  fi

  echo "ok   ${description} rejected: $(cat "${WORK_PATH}/stderr")"
}

check_rejections() {
  cat > "${WORK_PATH}/both-nuke" <<'CONFIG'
BASE_IMAGE_FILE="./basefiles/sdk-10.0-base"
IMAGE_TAGS=("check")
FEATURE_INSTALL_NUKE=true
FEATURE_INSTALL_NUKE9=true
CONFIG

  cat > "${WORK_PATH}/no-base-image" <<'CONFIG'
IMAGE_TAGS=("check")
CONFIG

  cat > "${WORK_PATH}/no-tags" <<'CONFIG'
BASE_IMAGE_FILE="./basefiles/sdk-10.0-base"
CONFIG

  cat > "${WORK_PATH}/missing-base-image" <<'CONFIG'
BASE_IMAGE_FILE="./basefiles/does-not-exist"
IMAGE_TAGS=("check")
CONFIG

  expect_rejected "both Nuke features enabled" "${WORK_PATH}/both-nuke"
  expect_rejected "BASE_IMAGE_FILE unset" "${WORK_PATH}/no-base-image"
  expect_rejected "IMAGE_TAGS unset" "${WORK_PATH}/no-tags"
  expect_rejected "base image file missing" "${WORK_PATH}/missing-base-image"
  expect_rejected "image configuration missing" "${WORK_PATH}/not-a-configuration"
}

check_images

if [ "${REGENERATE}" = true ]; then
  exit 0
fi

check_rejections

if [ "${FAILURES}" -ne 0 ]; then
  echo "${FAILURES} check(s) failed" >&2
  exit 1
fi

echo "all checks passed"
