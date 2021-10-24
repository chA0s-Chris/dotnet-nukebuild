![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/chA0s-Chris/dotnet-nukebuild?label=version&style=plastic)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/chaos/dotnet-nukebuild?style=plastic)
![Docker Pulls](https://img.shields.io/docker/pulls/chaos/dotnet-nukebuild?style=plastic)
![GitHub](https://img.shields.io/github/license/chA0s-Chris/dotnet-nukebuild?style=plastic)


# dotnet-nukebuild

A Linux-based Docker image intended to use with CI/CD servers for building .NET Core applications.

The image is based on the official .NET 5.0 SDK image (Debian 10) and contains:

* .NET Core Runtime 2.1.29
* .NET Core Runtime 3.1.20
* .NET Core Runtime 5.0.11
* .NET Core SDK 3.1.414
* .NET SDK 5.0.402
* Docker CLI 20.10.9
* kubectl 1.22.2
* [nuke](https://nuke.build) 5.3.0  as global tool 
* PowerShell 7.1.4 (pwsh)
* Azure Devops credential provider for NuGet
* git 2.20.1
* git-lfs 2.7.1

## Get The Image

```bash
docker pull chaos/dotnet-nukebuild:latest
```

Or visit the [chaos/dotnet-nukebuild page](https://hub.docker.com/repository/docker/chaos/dotnet-nukebuild) on **docker hub**.

## License

[MIT](https://github.com/chA0s-Chris/dotnet-cakebuild/blob/master/LICENSE)