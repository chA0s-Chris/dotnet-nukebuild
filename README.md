![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/chA0s-Chris/dotnet-nukebuild?label=version&style=plastic)
![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/chaos/dotnet-nukebuild?style=plastic)
![Docker Pulls](https://img.shields.io/docker/pulls/chaos/dotnet-nukebuild?style=plastic)
![GitHub](https://img.shields.io/github/license/chA0s-Chris/dotnet-nukebuild?style=plastic)


# dotnet-nukebuild

A Linux-based Docker image intended to use with CI/CD servers for building .NET Core applications.

The image is based on [buildpack-deps:stretch-scm](https://github.com/docker-library/buildpack-deps/blob/1845b3f918f69b4c97912b0d4d68a5658458e84f/stretch/scm/Dockerfile) (Debian 9) and contains:

* .NET Core Runtime 2.1.16
* .NET Core SDK 3.1.102
* Docker CLI 19.03.08
* kubectl 1.17.0
* [nuke](https://nuke.build) 0.22.2  as global tool 
* [GitVersion](https://gitversion.readthedocs.io) 5.0.1 as global tool
* Azure Devops credential provider for NuGet



## License

[MIT](https://github.com/chA0s-Chris/dotnet-cakebuild/blob/master/LICENSE)