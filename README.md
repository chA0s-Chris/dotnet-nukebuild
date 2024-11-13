![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/latest?label=Current&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/8?label=SDK%208%20(LTS)&style=for-the-badge)
![Docker Image Version](https://img.shields.io/docker/v/chaos/dotnet-nukebuild/6?label=SDK%206%20(LTS)&style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/chA0s-Chris/dotnet-nukebuild?style=for-the-badge)
![Docker Image Size (latest semver)](https://img.shields.io/docker/image-size/chaos/dotnet-nukebuild/latest?style=for-the-badge)
![Docker Pulls](https://img.shields.io/docker/pulls/chaos/dotnet-nukebuild?style=for-the-badge)
![GitHub](https://img.shields.io/github/license/chA0s-Chris/dotnet-nukebuild?style=for-the-badge)

# dotnet-nukebuild

A Linux-based Docker image intended to use with CI/CD servers for building .NET Core applications.

The image is tagged for the current .NET releases and is bases on the corresponding official .NET SDK (Ubuntu flavor). 

## Tags

| Tags      | Status | SDK     | Runtime | Base         |
|-----------|--------|---------|---------| ------------ |
| 9, latest | STS    | 9.0.100 | 9.0.0   | Ubuntu Noble |
| 8         | LTS    | 8.0.404 | 8.0.11  | Ubuntu Jammy |
| 6         | LTS    | 6.0.428 | 6.0.36  | Ubuntu Jammy |

## Additional software

* Docker CLI 27.3.1
* kubectl 1.31.0
* [nuke](https://nuke.build) 8.1.4 as global tool 
* Azure Devops credential provider for NuGet
* docker pushrm 1.9.0 ([Docker Push Readme](https://github.com/christian-korneck/docker-pushrm))
* git 2.34.1 / 2.43.0
* git-lfs 3.5.1

## Get The Image

```bash
docker pull chaos/dotnet-nukebuild:latest
```

Or visit the [chaos/dotnet-nukebuild page](https://hub.docker.com/r/chaos/dotnet-nukebuild) on **docker hub**.

## Versioning

Since .NET 6 the major version of this image will always correspond to the .NET SDK version included.

## Preview/RC

The is currently no preview/rc available.

## License

[MIT](https://github.com/chA0s-Chris/dotnet-cakebuild/blob/master/LICENSE)