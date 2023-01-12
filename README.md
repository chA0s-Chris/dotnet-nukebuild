![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/chA0s-Chris/dotnet-nukebuild?label=version&style=plastic)
![GitHub last commit](https://img.shields.io/github/last-commit/chA0s-Chris/dotnet-nukebuild?style=plastic)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/chaos/dotnet-nukebuild?style=plastic)
![Docker Pulls](https://img.shields.io/docker/pulls/chaos/dotnet-nukebuild?style=plastic)
![GitHub](https://img.shields.io/github/license/chA0s-Chris/dotnet-nukebuild?style=plastic)


# dotnet-nukebuild

A Linux-based Docker image intended to use with CI/CD servers for building .NET Core applications.

The image is based on the official .NET 7.0 SDK image (Ubuntu Jammy) and contains:

* .NET Runtime 6.0.13
* .NET Runtime 7.0.2
* .NET SDK 6.0.405
* .NET SDK 7.0.102
* Docker CLI 20.10.22
* kubectl 1.26.0
* [nuke](https://nuke.build) 6.3.0  as global tool 
* PowerShell 7.3.1 (pwsh)
* Azure Devops credential provider for NuGet
* docker pushrm 1.9.0 ([Docker Push Readme](https://github.com/christian-korneck/docker-pushrm))
* git 2.39.0
* git-lfs 3.3.0

## Get The Image

```bash
docker pull chaos/dotnet-nukebuild:latest
```

Or visit the [chaos/dotnet-nukebuild page](https://hub.docker.com/r/chaos/dotnet-nukebuild) on **docker hub**.

## Versioning

Since .NET 6 the major version of this image will always correspond to the highest .NET SDK version included.

## License

[MIT](https://github.com/chA0s-Chris/dotnet-cakebuild/blob/master/LICENSE)