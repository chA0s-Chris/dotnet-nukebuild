![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/chA0s-Chris/dotnet-nukebuild?label=version&style=plastic)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/chaos/dotnet-nukebuild?style=plastic)
![Docker Pulls](https://img.shields.io/docker/pulls/chaos/dotnet-nukebuild?style=plastic)
![GitHub](https://img.shields.io/github/license/chA0s-Chris/dotnet-nukebuild?style=plastic)


# dotnet-nukebuild

A Linux-based Docker image intended to use with CI/CD servers for building .NET Core applications.

The image is based on the official .NET 6.0 SDK image (Ubuntu Focal) and contains:

* .NET Core Runtime 3.1.23
* .NET Runtime 5.0.15
* .NET Runtime 6.0.3
* .NET Core SDK 3.1.417
* .NET SDK 5.0.406
* .NET SDK 6.0.201
* Docker CLI 20.10.13
* kubectl 1.23.4
* [nuke](https://nuke.build) 6.0.1  as global tool 
* PowerShell 7.2.1 (pwsh)
* Azure Devops credential provider for NuGet
* docker pushrm 1.8.0 ([Docker Push Readme](https://github.com/christian-korneck/docker-pushrm))
* git 2.35.1
* git-lfs 3.1.2

## Get The Image

```bash
docker pull chaos/dotnet-nukebuild:latest
```

Or visit the [chaos/dotnet-nukebuild page](https://hub.docker.com/repository/docker/chaos/dotnet-nukebuild) on **docker hub**.

## Versioning

Since .NET 6 the major version of this image will always correspond to the highest .NET SDK version included.

## License

[MIT](https://github.com/chA0s-Chris/dotnet-cakebuild/blob/master/LICENSE)