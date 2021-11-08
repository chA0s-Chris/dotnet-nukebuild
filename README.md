![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/chA0s-Chris/dotnet-nukebuild?label=version&style=plastic)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/chaos/dotnet-nukebuild?style=plastic)
![Docker Pulls](https://img.shields.io/docker/pulls/chaos/dotnet-nukebuild?style=plastic)
![GitHub](https://img.shields.io/github/license/chA0s-Chris/dotnet-nukebuild?style=plastic)


# dotnet-nukebuild

A Linux-based Docker image intended to use with CI/CD servers for building .NET Core applications.

The image is based on the official .NET 6.0 SDK image (Debian 11) and contains:

* .NET Core Runtime 3.1.20
* .NET Runtime 6.0.0
* .NET Core SDK 3.1.414
* .NET SDK 5.0.403
* .NET SDK 6.0.100
* Docker CLI 20.10.10
* kubectl 1.22.3
* [nuke](https://nuke.build) 5.3.0  as global tool 
* PowerShell 7.2.0 (pwsh)
* Azure Devops credential provider for NuGet
* git 2.30.2
* git-lfs 2.13.2

## Get The Image

```bash
docker pull chaos/dotnet-nukebuild:latest
```

Or visit the [chaos/dotnet-nukebuild page](https://hub.docker.com/repository/docker/chaos/dotnet-nukebuild) on **docker hub**.

## Versioning

Since .NET 6 the major version of this image will always correspond to the highest .NET SDK version included.

## License

[MIT](https://github.com/chA0s-Chris/dotnet-cakebuild/blob/master/LICENSE)