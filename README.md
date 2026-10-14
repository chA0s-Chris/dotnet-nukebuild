![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/chA0s-Chris/dotnet-nukebuild/ci.yml?branch=main&label=Build&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/latest?label=Current&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/11-rc?color=%23dd0000&label=RC&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/9?label=SDK%209%20(STS)&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/8?label=SDK%208%20(LTS)&style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/chA0s-Chris/dotnet-nukebuild?style=for-the-badge)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/chaos/dotnet-nukebuild/latest?style=for-the-badge)
![Docker Pulls](https://img.shields.io/docker/pulls/chaos/dotnet-nukebuild?style=for-the-badge)
![GitHub](https://img.shields.io/github/license/chA0s-Chris/dotnet-nukebuild?style=for-the-badge)

# dotnet-nukebuild

A Linux-based Docker image intended to use with CI/CD servers for building .NET Core applications.

The image is tagged for the current .NET releases and is based on the corresponding official .NET SDK (Ubuntu flavor). 

## Tags

| Tags            | Status   | SDK                     | Runtime               | Base            |
|-----------------|----------|-------------------------|-----------------------|-----------------|
| 10, latest      | LTS      | 10.0.402                | 10.0.13               | Ubuntu Noble    |
| 11-rc.2, 11-rc  | RC       | 11.0.100-rc.2.26504.105 | 11.0.0-rc.2.26504.105 | Ubuntu Resolute |
| 9               | STS      | 9.0.319                 | 9.0.21                | Ubuntu Noble    |
| 8               | LTS      | 8.0.426                 | 8.0.32                | Ubuntu Noble    |

## Additional software

* Docker CLI 29.9.0
* kubectl 1.37.1
* [nuke](https://nuke.build) 9.0.4 (10.1.0) as global tool 
* Azure Artifacts Credential Provider
* docker pushrm 1.9.0 ([Docker Push Readme](https://github.com/christian-korneck/docker-pushrm))
* git 2.43.0
* git-lfs 3.8.0
* .NET Aspire SDK
* Node.js 24.21.0

## Get The Image

```bash
docker pull chaos/dotnet-nukebuild:latest
```

Or visit the [chaos/dotnet-nukebuild page](https://hub.docker.com/r/chaos/dotnet-nukebuild) on **docker hub**.

## Versioning

Since .NET 6 the major version of this image will always correspond to the .NET SDK version included.

## Preview/RC .NET 11

The current release candidate of .NET 11 is available using the `11-rc` tag.

## License

[MIT](https://github.com/chA0s-Chris/dotnet-cakebuild/blob/master/LICENSE)