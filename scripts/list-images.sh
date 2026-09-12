#!/bin/bash
#
# Emit the image set as JSON, one entry per image configuration, in a
# deterministic order:
#
#   [{"config":"sdk-10.0","tags":["10","latest","10.11"]}]
#
# Needs no Docker daemon, registry credentials, or network access. Run from the
# repository root, like build.sh.

IMAGES_PATH="./images"

set -e

# pin collation so the emitted order does not depend on the environment
export LC_ALL=C

printf '['

separator=""

for config in "${IMAGES_PATH}"/*; do
  # read the tags in a subshell so no configuration leaks into the next one
  tags=$(
    . ./defaults
    . "${config}"
    printf '%s\n' "${IMAGE_TAGS[@]}"
  )

  if [ -z "${tags}" ]; then
    echo "${0##*/}: ${config}: IMAGE_TAGS is not set" >&2
    exit 1
  fi

  printf '%s{"config":"%s","tags":[' "${separator}" "${config##*/}"

  tag_separator=""

  while IFS= read -r tag; do
    printf '%s"%s"' "${tag_separator}" "${tag}"
    tag_separator=","
  done <<< "${tags}"

  printf ']}'

  separator=","
done

printf ']\n'
