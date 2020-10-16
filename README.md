![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/chA0s-Chris/dotnet-nukebuild?label=version&style=plastic)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/chaos/dotnet-nukebuild?style=plastic)
![Docker Pulls](https://img.shields.io/docker/pulls/chaos/dotnet-nukebuild?style=plastic)
![GitHub](https://img.shields.io/github/license/chA0s-Chris/dotnet-nukebuild?style=plastic)


# dotnet-nukebuild

A Linux-based Docker image intended to use with CI/CD servers for building .NET Core applications.

The image is based on [dotnet/aspnet:5.0-buster-slim-amd64](https://github.com/dotnet/dotnet-docker/blob/63b8443439ec2ad494d704ced088e4657ea8f255/src/aspnet/5.0/buster-slim/amd64/Dockerfile) (Debian 10) and contains:

* .NET Core Runtime 2.1.23
* .NET Core Runtime 3.1.9
* .NET Core Runtime 5.0.0-rc.2.20475.17
* .NET Core SDK 3.1.403
* .NET Core SDK 5.0.100-rc.2.20479.15
* Docker CLI 19.03.13
* kubectl 1.19.0
* [nuke](https://nuke.build) 0.24.11  as global tool 
* [GitVersion](https://gitversion.readthedocs.io) 5.3.7 as global tool
* Azure Devops credential provider for NuGet



## License

[MIT](https://github.com/chA0s-Chris/dotnet-cakebuild/blob/master/LICENSE)