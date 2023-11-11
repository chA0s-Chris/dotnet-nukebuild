![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/latest?label=Release&style=for-the-badge)
![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/preview?color=%23dd0000&label=Preview&style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/chA0s-Chris/dotnet-nukebuild?style=for-the-badge)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/chaos/dotnet-nukebuild/latest?style=for-the-badge)
![Docker Pulls](https://img.shields.io/docker/pulls/chaos/dotnet-nukebuild?style=for-the-badge)
![GitHub](https://img.shields.io/github/license/chA0s-Chris/dotnet-nukebuild?style=for-the-badge)

# dotnet-nukebuild

A Linux-based Docker image intended to use with CI/CD servers for building .NET Core applications.

The image is based on the official .NET 7.0 SDK image (Ubuntu Jammy) and contains:

* .NET Runtime 6.0.24
* .NET Runtime 7.0.13
* .NET SDK 6.0.416
* .NET SDK 7.0.403
* Docker CLI 24.0.7
* kubectl 1.28.3
* [nuke](https://nuke.build) 7.0.6  as global tool 
* PowerShell 7.3.7 (pwsh)
* Azure Devops credential provider for NuGet
* docker pushrm 1.9.0 ([Docker Push Readme](https://github.com/christian-korneck/docker-pushrm))
* git 2.42.0
* git-lfs 3.4.0

## Get The Image

```bash
docker pull chaos/dotnet-nukebuild:latest
```

Or visit the [chaos/dotnet-nukebuild page](https://hub.docker.com/r/chaos/dotnet-nukebuild) on **docker hub**.

## Versioning

Since .NET 6 the major version of this image will always correspond to the highest .NET SDK version included.

## Preview .NET 8

The current preview version is available using the `preview` tag and also includes:

* .NET Runtime 8.0.0-rc.2.23479.6
* .NET SDK 8.0.100-rc.2.23502.2

```bash
docker pull chaos/dotnet-nukebuild:preview
```

## License

[MIT](https://github.com/chA0s-Chris/dotnet-cakebuild/blob/master/LICENSE)