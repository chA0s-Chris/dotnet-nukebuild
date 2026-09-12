# Switch to GitHub workflows

> Issue: [#1](https://github.com/chA0s-Chris/dotnet-nukebuild/issues/1)

## Rationale

AppVeyor builds and publishes every commit to `main`, making publication a side effect of merging
and leaving no way to build an image without pushing it. `build.sh` reinforces this: it bootstraps a
Docker CLI plugin, logs in to Docker Hub, renders Dockerfiles, builds, pushes, and updates the
Docker Hub description in one unconditional sequence. Because that sequence cannot run without
publishing, its Dockerfile rendering has been reimplemented outside the repository in order to
verify images locally.

Replacing AppVeyor alone would preserve the coupling. The work is one story in two ordered layers:
first separate rendering from publishing so a build can be verified without credentials, then move
CI to GitHub Actions with publishing behind an explicit manual release. Stacked review keeps the
credential-free refactor — provable by comparing rendered output against the current
implementation — separate from the workflow and publishing changes, whose only real risk is
registry access.

## Acceptance Criteria

### Layer 1: Dockerfile rendering

- [x] Rendering an image's Dockerfile requires no Docker daemon, registry credentials, or network access.
- [x] Expected Dockerfiles captured from `create_image`'s output at trunk `main` (`334b60b`) are committed for all four image configurations.
- [x] `build.sh` renders through the new path and no longer contains its own feature-concatenation logic.
- [x] `build.sh` retains its existing login, build, tag, push, and Docker Hub description sequence unchanged, confirmed by inspecting its diff against trunk `main` (`334b60b`) rather than by running it.
- [x] Rendering exits non-zero with a diagnostic when an image enables both Nuke features, or omits `BASE_IMAGE_FILE` or `IMAGE_TAGS`.
- [x] The image set, including each configuration's tags, is emitted as JSON in a deterministic order.
- [x] No configuration variable set by one image configuration affects the rendering of another.
- [x] `bash -n` succeeds for every shell script and sourced configuration file.
- [x] A committed check renders every image configuration, diffs the result against the expected Dockerfiles, asserts each rejection case, and succeeds without Docker, registry credentials, or network access.

### Layer 2: GitHub Actions

- [ ] A CI workflow builds every image in the emitted set as parallel matrix jobs, on pull requests and on pushes to `main`.
- [ ] The CI workflow runs the rendering check before building images.
- [ ] CI runs never authenticate to Docker Hub and never push an image or a description.
- [ ] A failing image job does not cancel the remaining image jobs.
- [ ] A release workflow runs only on manual dispatch and publishes every tag of each selected image.
- [ ] The release defaults to all images and accepts an input narrowing the run to a subset.
- [ ] The release workflow refuses to publish from any ref other than `main`.
- [ ] The release workflow updates the Docker Hub description from `README.md` only after every image job in that run has succeeded.
- [ ] The Docker Hub username is read from a repository variable and the token from a repository secret, and the token does not appear in workflow logs.
- [ ] Concurrent release runs are prevented.
- [ ] `appveyor.yml` is removed and no AppVeyor configuration remains.
- [ ] `README.md` shows a CI workflow status badge.

## Technical Details

Keep the existing data model: `defaults` for globals and feature flags, one file per image in
`images/`, one Dockerfile fragment per feature in `features/`. It maps directly onto Dockerfile
concatenation and is what the external update tooling already understands. Do not convert it to
YAML or a Bake file.

AppVeyor is disconnected by the maintainer before layer 1 merges, so no merge in this stack
publishes anything. After layer 2, publishing happens only on an explicit release dispatch.

### Rendering contract

Rendering must reproduce `create_image` exactly: copy `BASE_IMAGE_FILE`, then append enabled
features in this order — `set_environment`, `update_distro`, `install_docker`, `install_git-lfs`,
`install_azure_devops_provider`, `install_docker_pushrm`, `install_kubectl`, `install_nuke`,
`install_nuke9`, `install_node`. Changing that order changes layer caching and breaks the
expected-Dockerfile comparison.

The expected Dockerfiles are regenerated whenever a base image or feature file changes; the check
therefore needs a regeneration mode, and the external update tooling must refresh them as part of
a dependency update.

`defaults` defines every `FEATURE_*` flag, so only `BASE_IMAGE_FILE` and `IMAGE_TAGS` come solely
from an image configuration; those are the two variables that can silently carry over between
images in the current single-process loop.

`features/install_nuke` and `features/install_nuke9` both set `ENV NUKE_TOOL_VERSION`, so enabling
both yields a quietly wrong image. The current script has no validation; rendering must reject it.

### Workflow design

The matrix is driven from the emitted image set via `fromJSON`, so adding or removing a .NET line
needs no workflow edit. Building uses `docker/build-push-action` with `push` disabled for CI runs.
No feature uses `COPY` or `ADD`, so the build context can be empty rather than the repository root.

`get_docker_pushrm` in `build.sh` installs a Docker CLI plugin onto the CI host — unrelated to the
`install_docker_pushrm` feature that installs the same tool *into* the images. Layer 2 removes the
host bootstrap from the build path and handles the description push as a release job step.

Publishing reads the Docker Hub username from the `DOCKERHUB_USERNAME` repository variable and the
access token from the `DOCKERHUB_TOKEN` repository secret, so the workflow must reference
`vars.DOCKERHUB_USERNAME` and `secrets.DOCKERHUB_TOKEN`. Both are configured. The AppVeyor-era
token behind the encrypted `CI_DOCKER_TOKEN` variable must be revoked in Docker Hub once the
release workflow has published successfully.

The release workflow's subset input selects images by their `images/` configuration name.

Branch protection is a repository setting, not a file: once layer 2 reports a stable CI check name,
`main` gets a ruleset requiring pull requests and that check, with exact settings confirmed before
they are applied.

### Out of scope

Multi-architecture images. `features/install_kubectl`, `features/install_git-lfs`, and
`features/install_docker_pushrm` pin amd64 URLs and amd64 checksums, so arm64 is a change to the
feature files and their verification, not to CI.

GHCR publishing, build provenance, and attestations.

Step 7 of the `update-dotnet-nukebuild` skill instructs an agent not to run `build.sh` and to
reproduce its Dockerfile generation instead. Once layer 1 defines the rendering entry point, that
step should call it. The skill is maintained outside this repository and is tracked separately.

### Stack Design

1. `0001-switch-to-github-workflows-render` — separate credential-free Dockerfile rendering and
   image enumeration from publishing, leaving `build.sh` behaviour unchanged. Verified by comparing
   rendered output with trunk `main` (`334b60b`); no Docker or registry access required.
2. `0001-switch-to-github-workflows-actions` — build every image in GitHub Actions and publish
   through an explicit manual release, then remove AppVeyor; depends on layer 1's rendering and
   enumeration entry points. Its publishing path cannot be verified until the release workflow is
   dispatched on `main`.
