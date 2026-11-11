![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/chA0s-Chris/dotnet-nukebuild/ci.yml?branch=main&label=Build&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/latest?label=Current&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/10?label=SDK%2010%20(LTS)&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/9?label=SDK%209%20(EOL)&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/8?label=SDK%208%20(EOL)&style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/chA0s-Chris/dotnet-nukebuild?style=for-the-badge)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/chaos/dotnet-nukebuild/latest?style=for-the-badge)
![Docker Pulls](https://img.shields.io/docker/pulls/chaos/dotnet-nukebuild?style=for-the-badge)
![GitHub](https://img.shields.io/github/license/chA0s-Chris/dotnet-nukebuild?style=for-the-badge)

# dotnet-nukebuild

A Linux-based Docker image intended to use with CI/CD servers for building .NET Core applications.

The image is tagged for the current .NET releases and is based on the corresponding official .NET SDK (Ubuntu flavor). 

## Tags

| Tags       | Status | SDK      | Runtime | Base            |
|------------|--------|----------|---------|-----------------|
| 11, latest | STS    | 11.0.100 | 11.0.0  | Ubuntu Resolute |
| 10         | LTS    | 10.0.404 | 10.0.15 | Ubuntu Noble    |
| 9          | EOL    | 9.0.321  | 9.0.23  | Ubuntu Noble    |
| 8          | EOL    | 8.0.428  | 8.0.34  | Ubuntu Noble    |

## Additional software

* Docker CLI 29.9.3
* kubectl 1.37.2
* [nuke](https://nuke.build) 9.0.4 (10.1.0) as global tool 
* [Fallout](https://fallout.build) 10.5.0 as global tool (SDK 10 and 11 images only)
* Azure Artifacts Credential Provider
* docker pushrm 1.9.0 ([Docker Push Readme](https://github.com/christian-korneck/docker-pushrm))
* git 2.53.0
* git-lfs 3.8.1
* .NET Aspire SDK
* Node.js 24.22.2

## NUKE and Fallout

NUKE is no longer maintained. [Fallout](https://fallout.build), its hard-fork successor, is
installed next to it, so each repository can switch on its own schedule: run `nuke` for a build
project that references NUKE and `fallout` for one that references Fallout. To move a build over,
follow Fallout's
[migration guide from NUKE](https://github.com/Fallout-build/Fallout/blob/develop/docs/Migration/from-nuke.md).

Fallout requires .NET 10 or later, so the SDK 8 and 9 images ship NUKE only.

## Get The Image

```bash
docker pull chaos/dotnet-nukebuild:latest
```

Or visit the [chaos/dotnet-nukebuild page](https://hub.docker.com/r/chaos/dotnet-nukebuild) on **docker hub**.

## Versioning

Since .NET 6 the major version of this image will always correspond to the .NET SDK version included.

## Preview/RC

There is currently no preview/RC version of .NET available.

## License

[MIT](https://github.com/chA0s-Chris/dotnet-cakebuild/blob/master/LICENSE)