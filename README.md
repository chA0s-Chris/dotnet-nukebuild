![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/chA0s-Chris/dotnet-nukebuild?label=version&style=plastic)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/chaos/dotnet-nukebuild?style=plastic)
![Docker Pulls](https://img.shields.io/docker/pulls/chaos/dotnet-nukebuild?style=plastic)
![GitHub](https://img.shields.io/github/license/chA0s-Chris/dotnet-nukebuild?style=plastic)


# dotnet-nukebuild

A Linux-based Docker image intended to use with CI/CD servers for building .NET Core applications.

The image is based on the official .NET 5.0 SDK image (Debian 10) and contains:

* .NET Core Runtime 2.1.23
* .NET Core Runtime 3.1.9
* .NET Core Runtime 5.0.1
* .NET Core SDK 3.1.403
* .NET Core SDK 5.0.101
* Docker CLI 19.03.13
* kubectl 1.20.0
* [nuke](https://nuke.build) 5.0.2  as global tool 
* [GitVersion](https://gitversion.readthedocs.io) 5.6.1 as global tool
* PowerShell 7.2.0-preview.1 (pwsh)
* Azure Devops credential provider for NuGet



## License

[MIT](https://github.com/chA0s-Chris/dotnet-cakebuild/blob/master/LICENSE)