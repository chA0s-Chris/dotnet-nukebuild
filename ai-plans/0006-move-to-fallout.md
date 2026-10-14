# Move to Fallout

> Issue: [#6](https://github.com/chA0s-Chris/dotnet-nukebuild/issues/6)

## Rationale

NUKE is no longer maintained and its last release has problems. Fallout is its hard-fork
successor, and the issue accepts supporting both. Shipping Fallout next to NUKE in every image that
can run it lets each repository switch on its own schedule — the build project it references
decides which tool it uses — instead of the image forcing a migration. Moving exclusively to
Fallout and dropping NUKE is deferred.

## Acceptance Criteria

- [ ] The built `sdk-10.0` and `sdk-11.0` images list `Fallout.GlobalTool` 10.4.0 next to
      `Nuke.GlobalTool` 10.1.0 in `dotnet tool list --global`, with both `fallout` and `nuke` on
      `PATH`.
- [ ] Building an image that enables Fallout fails when the installed `fallout` command cannot
      start, so CI's image builds catch a broken install without manual inspection.
- [ ] The `sdk-8.0` and `sdk-9.0` images are unchanged and their expected Dockerfiles are
      byte-for-byte identical.
- [ ] Fallout is a separate feature, disabled by default and enabled only in the `sdk-10.0` and
      `sdk-11.0` image configurations.
- [ ] The expected Dockerfiles for `sdk-10.0` and `sdk-11.0` are regenerated and
      `scripts/check-render.sh` passes.
- [ ] The `sdk-10.0` image revision tag is incremented from `10.12` to `10.13`.
- [ ] `scripts/check-shell.sh` passes.
- [ ] `README.md` lists Fallout and its version under "Additional software", states that it ships
      only in the SDK 10 and 11 images, explains that a repository uses `nuke` or `fallout`
      depending on its build project, and links Fallout's migration guide from NUKE.

## Technical Details

### Package

Install `Fallout.GlobalTool` pinned to `10.4.0`: it is the install command documented by the
official `Fallout-build/Fallout` repository, owned by `Fallout.build` on nuget.org, and its latest
release (v10.4.0, 2026-08-07). Do not use `Fallout.Cli` 11.x — it is unlisted on nuget.org and its
project URL points to the `ChrisonSimtian/Fallout` fork — nor `Fallout.GlobalTools`, which has a
single release candidate.

The tool targets only `net10.0` with `rollForward: LatestMajor`, so it runs on the SDK 11 image's
.NET 11 runtime. It cannot run on the SDK 8 or 9 images, and Fallout's build libraries also target
only `net10.0`, so a Fallout build needs the .NET 10 SDK anyway; adding a runtime to those images
would enable nothing. They keep Nuke 9.0.4.

### Feature wiring

New `features/install_fallout`, modelled on `features/install_nuke`, sets the new
`ENV FALLOUT_TOOL_VERSION` and installs the tool globally. New `FEATURE_INSTALL_FALLOUT=false` in
`defaults`, set to `true` in `images/sdk-10.0` and `images/sdk-11.0`. `install_fallout` is added to
`FEATURE_ORDER` in `scripts/render-dockerfile.sh` immediately after `install_nuke9`; existing
entries keep their order.

The tools differ in package ID, command, and version variable, so unlike `install_nuke` and
`install_nuke9` the renderer needs no rule rejecting both.

### Build-time check

Like `features/install_kubectl`, the install step runs the installed command to prove it works.
A bare `fallout` cannot be used: outside a build repository it prompts to set one up and exits `1`
in non-interactive mode (`nuke` behaves the same). `fallout :complete` exits `0` without a build
repository, including from `/`, the image build's working directory, and exits non-zero when the
tool cannot start: `150` when no compatible .NET runtime is present, `154` when the tool's files
are missing. Verified with 10.4.0 on `mcr.microsoft.com/dotnet/sdk:10.0.402-noble` and on
`mcr.microsoft.com/dotnet/sdk:11.0.100-rc.2-resolute`, whose only runtime is .NET 11. It is an
internal shell-completion command rather than a documented contract, so if a later release changes
it the image build fails loudly and the check must be revisited — the intended outcome.

The check resolves `fallout` through the `/root/.dotnet/tools` `PATH` entry added by
`features/set_environment`, which every image enables.

### Telemetry

No Fallout-specific telemetry variable exists in 10.4.0. Keep `NUKE_TELEMETRY_OPTOUT` in
`features/set_environment` and do not add a speculative one.

### README

Link the migration guide at
`https://github.com/Fallout-build/Fallout/blob/develop/docs/Migration/from-nuke.md`. The
`docs.fallout.build` migration paths, including the one linked from fallout.build, return 404.

### Out of scope

Installing `Fallout.Migrate` — a one-time migration users run locally on their repository.

Renaming the `chaos/dotnet-nukebuild` image, which would break existing pulls.

Removing NUKE.
