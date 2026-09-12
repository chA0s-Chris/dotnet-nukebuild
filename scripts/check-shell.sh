#!/bin/bash
#
# Run ShellCheck over every shell script in the repository.
#
# The image configurations, features, and base files are data rather than
# scripts and are deliberately left out: the feature and base files are
# Dockerfile fragments, and the configurations are assignments that ShellCheck
# can only report as unused. check-render.sh already sources every image
# configuration, so a syntax error there fails that check instead.
#
# Needs no Docker daemon, registry credentials, or network access. Run from the
# repository root, like build.sh.

BUILD_SCRIPT="./build.sh"
SCRIPTS_PATH="./scripts"

set -e

fail() {
  echo "${0##*/}: ${1}" >&2
  exit 1
}

if ! command -v shellcheck > /dev/null; then
  fail "shellcheck not found; install it with your package manager"
fi

# severity stays at the default so style and info findings are reported too;
# .shellcheckrc disables only the checks that cannot follow a runtime source
shellcheck "${BUILD_SCRIPT}" "${SCRIPTS_PATH}"/*.sh

echo "all shell scripts pass shellcheck"
